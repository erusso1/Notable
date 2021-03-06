//
//  NotifcationHandler.swift
//  Notable_Example
//
//  Created by Ephraim Russo on 2/19/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Notable
import UserNotifications

final class NotificationHandler: NSObject {
    
    static let shared = NotificationHandler()
}

extension NotificationHandler: NTNotificationHandlingDelegate {
   
    func notable(_ notable: Notable, didRegisterWithDeviceToken deviceToken: String) {
        
        print(#function)
        
        print("Device token: \(deviceToken)")
    }
    
    func notable(_ notable: Notable, payloadFromNotification userInfo: [AnyHashable : Any], channel: NTNotificationChannel) -> NTNotificationPayloadContaining? {
        
        print(#function)
        
        return nil
    }
    
    func notable(_ notable: Notable, handleRemoteNotificationWithCategory category: NTNotificationCategory, channel: NTNotificationChannel, payload: NTNotificationPayloadContaining?, userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        
        print(#function)
        
        completionHandler()
    }
    
    func notable(_ notable: Notable, didSelectCustomNotificationActionWith category: NTNotificationCategory, action: NTNotificationAction, payload: NTNotificationPayloadContaining?, completionHandler: @escaping () -> Void) {
        
        print(#function)
        
        completionHandler()
    }
    
    func notable(_ notable: Notable, didSelectNotificationBannerWith category: NTNotificationCategory, payload: NTNotificationPayloadContaining?, completionHandler: @escaping () -> Void) {
        
        print(#function)

        completionHandler()
    }
}
