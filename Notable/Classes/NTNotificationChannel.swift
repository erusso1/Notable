//
//  NTNotificationChannel.swift
//  Notable
//
//  Created by Ephraim Russo on 2/27/19.
//

import Foundation

public struct NTNotificationChannel {
    
    public let stringValue: String
    
    init(stringValue: String) {
        self.stringValue = stringValue
    }
}

extension NTNotificationChannel: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.init(stringValue: value)
    }
}

extension NTNotificationChannel: Equatable { }

extension NTNotificationChannel {
    
    public static let apns: NTNotificationChannel = "notable_remote_notification"
    
    public static let local: NTNotificationChannel = "notable_local_notification"
    
    public static let websocket: NTNotificationChannel = "notable_websocket_notification"
}

public func ==(lhs: NTNotificationChannel, rhs: NTNotificationChannel) -> Bool { return lhs.stringValue == rhs.stringValue }
