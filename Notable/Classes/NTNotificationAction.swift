//
//  NTNotificationAction.swift
//  Notable
//
//  Created by Ephraim Russo on 2/18/19.
//

import Foundation

public struct NTNotificationAction {
    
    let stringValue: String
    
    init(stringValue: String) {
        self.stringValue = stringValue
    }
}

extension NTNotificationAction: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.init(stringValue: value)
    }
}

extension NTNotificationAction: Equatable { }

public func ==(lhs: NTNotificationAction, rhs: NTNotificationAction) -> Bool { return lhs.stringValue == rhs.stringValue }
