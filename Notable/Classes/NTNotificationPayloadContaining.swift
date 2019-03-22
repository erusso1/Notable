//
//  NTNotificationHandling.swift
//  Notable
//
//  Created by Ephraim Russo on 2/18/19.
//

import Foundation
import UserNotifications

public protocol NTNotificationPayloadContaining: Codable {
    
    var notificationName: Notification.Name? { get }
}

extension NTNotificationPayloadContaining {
    
    var notificationName: Notification.Name? { return nil }
}

public protocol NTNotificationPayloadDisplaying: NTNotificationPayloadContaining {
    
    var bannerTitle: String { get }
    
    var bannerCaption: String { get }
    
    var localNotificationCustomSoundFileName: String? { get }
    
    var userInfoEncoder: JSONEncoder { get }
}

extension NTNotificationPayloadDisplaying {
    
    public var userInfoEncoder: JSONEncoder { return JSONEncoder() }
    
    public var localNotificationCustomSoundFileName: String? { return nil }

    func toUNNotifcationContent(encoder: JSONEncoder = JSONEncoder()) -> UNMutableNotificationContent {
        
        let content = UNMutableNotificationContent()
        
        content.categoryIdentifier = NTNotificationCategory.notableDefaultUICategory.stringValue
        content.title = bannerTitle
        content.body = bannerCaption
        
        if let fileName = self.localNotificationCustomSoundFileName {
            content.sound = UNNotificationSound(named: .init(fileName))
        }
        else {
            content.sound = .default
        }
        
        let data = try! userInfoEncoder.encode(self)
        let userInfo = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
        content.userInfo = userInfo
        
        return content
    }
}
