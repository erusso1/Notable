//
//  NTNotificationAction.swift
//  Notable
//
//  Created by Ephraim Russo on 2/18/19.
//

import Foundation
import UserNotifications

public struct NTNotificationAction {
    
    public let identifier: String
    
    public let title: String?
    
    public let options: UNNotificationActionOptions?
    
    init(identifier: String, title: String?, options: UNNotificationActionOptions?) {
        self.identifier = identifier
        self.title = title
        self.options = options
    }
}

extension NTNotificationAction {

    public static let `default` = NTNotificationAction(stringLiteral: UNNotificationDefaultActionIdentifier)

    public static let dismiss = NTNotificationAction(stringLiteral: UNNotificationDismissActionIdentifier)
}

extension NTNotificationAction {
    
    func toUNNotificationAction() -> UNNotificationAction? {
        
        guard let title = title, let options = options else { return nil }
        return UNNotificationAction(identifier: identifier, title: title, options: options)
    }
}

extension NTNotificationAction: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.init(identifier: value, title: nil, options: nil)
    }
}

extension NTNotificationAction: Equatable { }

public func ==(lhs: NTNotificationAction, rhs: NTNotificationAction) -> Bool { return lhs.identifier == rhs.identifier }
