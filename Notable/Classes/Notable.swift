
import Foundation
import UIKit
import UserNotifications

public protocol NTNotificationHandlingDelegate: NSObjectProtocol {
    
    func notable(_ notable: Notable, didRegisterWithDeviceToken deviceToken: String)
    
    func notable(_ notable: Notable, payloadFromNotification userInfo: [AnyHashable : Any], channel: NTNotificationChannel) -> NTNotificationPayloadContaining?
    
    func notable(_ notable: Notable, handleRemoteNotificationWithCategory category: NTNotificationCategory, channel: NTNotificationChannel, payload: NTNotificationPayloadContaining?, userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void)
    
    func notable(_ notable: Notable, didSelectCustomNotificationActionWith category: NTNotificationCategory, action: NTNotificationAction, payload: NTNotificationPayloadContaining?, completionHandler: @escaping () -> Void)
    
    func notable(_ notable: Notable, didSelectNotificationBannerWith category: NTNotificationCategory, payload: NTNotificationPayloadContaining?, completionHandler: @escaping () -> Void)
}

public final class Notable: NSObject {
    
    public static let shared = Notable()
    
    weak var delegate: NTNotificationHandlingDelegate?
    
    private var ignoresForegroundRemoteNotifications: Bool!
    
    private var executesDeferredNotificationHandlerImmediately: Bool!
    
    private var deferredNotificationHandler: (() -> Void)?
    
    public func setup(delegate: NTNotificationHandlingDelegate, ignoresForegroundRemoteNotifications: Bool = true, executesDeferredNotificationHandlerImmediately: Bool = true) {
        
        UNUserNotificationCenter.current().delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveApplicationDidBecomeActiveNotification(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        self.delegate = delegate
        self.ignoresForegroundRemoteNotifications = ignoresForegroundRemoteNotifications
        self.executesDeferredNotificationHandlerImmediately = executesDeferredNotificationHandlerImmediately
    }
    
    public func performDeferredNotificationHandlerIfNeeded() {
        
        guard let handler = self.deferredNotificationHandler else { return }
        
        handler()
        
        self.deferredNotificationHandler = nil
    }
    
    @objc private func didReceiveApplicationDidBecomeActiveNotification(_ notification: Notification) {
        
        guard executesDeferredNotificationHandlerImmediately else { return }
        
        deferredNotificationHandler?()
        
        deferredNotificationHandler = nil
    }
    
    public func registerCustomNotificationCategory(_ category: NTNotificationCategory, actions: [NTNotificationAction] = []) {
        
        let customActions: [UNNotificationAction] = actions.compactMap { $0.toUNNotificationAction() }
        
        let customCategory = UNNotificationCategory(identifier: category.stringValue, actions: customActions, intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([customCategory])
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

extension Notable {
    
    public func cancelAllPendingNotificationRequests() {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    public func getNotificationAuthorizationSettings(completion:  @escaping (UNNotificationSettings) -> Void) {
        
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: completion)
    }
    
    public func getNotificationAuthorizationStatus(completion:  @escaping (UNAuthorizationStatus) -> Void) {
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
          
            completion(settings.authorizationStatus)
        }
    }
    
    public func requestAuthorization(options: UNAuthorizationOptions = [.alert, .sound, .badge], completion: @escaping (Bool, Error?) -> Void) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: completion)
    }
    
    public func registerForRemoteNotifications(application: UIApplication = .shared) {
        
        application.registerForRemoteNotifications()
    }
}

extension Notable {
    
    public func didRegisterRemoteNotificationDeviceToken(_ deviceToken: Data) {
        
        delegate?.notable(self, didRegisterWithDeviceToken: deviceToken.hexString())
    }
}

extension Notable: UNUserNotificationCenterDelegate {
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if ignoresForegroundRemoteNotifications {
            
            let options: UNNotificationPresentationOptions = notification.category() == .notableDefaultUICategory ? [.sound, .alert] : []
            completionHandler(options)
        }
        
        else {
            
            let category = notification.category()
    
            guard category != .notableDefaultUICategory else { return completionHandler([.sound, .alert])}
            
            let payload = delegate?.notable(self, payloadFromNotification: notification.userInfo(), channel: .apns)
            
            delegate?.notable(self, handleRemoteNotificationWithCategory: category, channel: .apns, payload: payload, userInfo: notification.userInfo()) {
                
                if let payload = payload, let notificationName = payload.notificationName {
                    
                    DispatchQueue.main.async {
                        
                        NotificationCenter.default.post(name: notificationName, object: payload)
                    }
                }
                
                completionHandler([.sound, .alert])
            }
        }
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let category = response.category()
        let action = response.action()
        let payload = delegate?.notable(self, payloadFromNotification: response.userInfo(), channel: category == .notableDefaultUICategory ? .local : .apns)

        // User selects notable-generated banner or non-custom action.
        if category == .notableDefaultUICategory || (action == .dismiss || action == .default) {
            
            if UIApplication.shared.applicationState == .active {
                
                delegate?.notable(self, didSelectNotificationBannerWith: category, payload: payload, completionHandler: completionHandler)
            }
            
            else {
                
                self.deferredNotificationHandler = { [unowned self] in
                    
                    self.delegate?.notable(self, handleRemoteNotificationWithCategory: category, channel: .apns, payload: payload, userInfo: response.notification.userInfo()) { [unowned self] in
                        
                        DispatchQueue.main.async {
                            
                            self.delegate?.notable(self, didSelectNotificationBannerWith: category, payload: payload, completionHandler: completionHandler)
                        }
                    }
                }
            }
        }
        
        // User selects a custom cateogry or custom action.
        else {
            
            delegate?.notable(self, didSelectCustomNotificationActionWith: category, action: action, payload: payload, completionHandler: completionHandler)
        }
    }
}

extension Notable {
    
    public func displayBannerUINotificationWith(payload: NTNotificationPayloadDisplaying, at date: Date) {

        let interval = date.timeIntervalSince(Date())
        
        guard interval > 0 else { return }
        
        displayBannerUINotificationWith(payload: payload, afterDelay: interval)
    }
    
    public func displayBannerUINotificationWith(payload: NTNotificationPayloadDisplaying, afterDelay delay: TimeInterval? = nil) {
        
        let trigger: UNTimeIntervalNotificationTrigger?
        
        if let delay = delay { trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false) }
        else { trigger = nil }
        
        // requestIdentifier is being hardcoded at the moment until we find a use for having multiple request ids
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: payload.toUNNotifcationContent(), trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
