//
//  UNNotificationResponse+Notable.swift
//  Notable
//
//  Created by Ephraim Russo on 2/18/19.
//

import Foundation
import UserNotifications

extension UNNotification {
    
    func category() -> NTNotificationCategory { return .init(stringValue: request.content.categoryIdentifier) }

    func userInfo() -> [AnyHashable : Any] { return request.content.userInfo }
}

extension UNNotificationResponse {
    
    func category() -> NTNotificationCategory { return notification.category() }
    
    func action() -> NTNotificationAction { return .init(identifier: actionIdentifier, title: nil, options: nil) }
    
    func userInfo() -> [AnyHashable : Any] { return notification.userInfo() }
}
