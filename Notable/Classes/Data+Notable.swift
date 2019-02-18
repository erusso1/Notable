//
//  Data+Notable.swift
//  Notable
//
//  Created by Ephraim Russo on 2/17/19.
//

import Foundation

extension Data {
    
    func hexString() -> String { return self.map { String(format: "%02.2hhx", $0) }.joined() }
}
