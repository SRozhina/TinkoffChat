//
//  UIApplicationState.swift
//  TinkoffChat
//
//  Created by Sofia on 23/09/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

extension UIApplicationState {
    var toString: String {
        switch self {
            case .active:
                return "active"
            case .inactive:
                return "inactive"
            case .background:
                return "background"
            }
    }
}
