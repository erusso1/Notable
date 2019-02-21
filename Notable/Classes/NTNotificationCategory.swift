//
//  NTNotificationCategory.swift
//  Notable
//
//  Created by Ephraim Russo on 2/18/19.
//

import Foundation

public struct NTNotificationCategory {
    
    public let stringValue: String
    
    init(stringValue: String) {
        self.stringValue = stringValue
    }
}

extension NTNotificationCategory: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.init(stringValue: value)
    }
}

extension NTNotificationCategory: Equatable { }

extension NTNotificationCategory {
    
    static let notableDefaultUICategory: NTNotificationCategory = "notable_default_ui_category"
}

public func ==(lhs: NTNotificationCategory, rhs: NTNotificationCategory) -> Bool { return lhs.stringValue == rhs.stringValue }
