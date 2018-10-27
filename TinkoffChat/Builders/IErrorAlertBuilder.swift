//
//  IErrorAlertBuilder.swift
//  TinkoffChat
//
//  Created by Sofia on 27/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

protocol IErrorAlertBuilder {
    func build(with title: String, retryAction: @escaping () -> Void) -> UIAlertController
}
