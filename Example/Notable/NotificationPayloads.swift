//
//  NotificationPayloads.swift
//  Notable_Example
//
//  Created by Ephraim Russo on 2/19/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Notable

enum NotificationAction: String, Codable {
    
    case newRestaurantNearby
    
    case friendRequest
}

struct BaseNotificationPayload: Codable {
    
    let action: NotificationAction
    
    let reference: String?
    
    init(action: NotificationAction, reference: String?) {
        self.action = action
        self.reference = reference
    }
}

extension BaseNotificationPayload: NTNotificationPayloadContaining {
    
    var bannerTitle: String {
        
        switch self.action {
        case .newRestaurantNearby: return "New Restaurant Nearby!"
        case .friendRequest: return "John Abhinor wants to connect."
        }
    }
    
    var bannerCaption: String {
        
        switch self.action {
        case .newRestaurantNearby: return "A restaurant you've never been too just opened up 4.2 mi away. Tap to check it out!"
        case .friendRequest: return "You and John have 7 mutual friends and share 3 interests, including swimming."
        }
    }
    
    var localNotificationCustomSoundFileName: String? { return nil }
    
    var notificationName: Notification.Name { return Notification.Name(action.rawValue) }
}
