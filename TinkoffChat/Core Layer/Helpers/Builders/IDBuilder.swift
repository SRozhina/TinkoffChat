//
//  IDBuilder.swift
//  TinkoffChat
//
//  Created by Sofia on 09/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class IDBuilder {
    static func generateID() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))\(Date.timeIntervalSinceReferenceDate)\(arc4random_uniform(UINT32_MAX))"
        let encodedString = string.data(using: .utf8)?.base64EncodedString()
        return encodedString!
    }
}
