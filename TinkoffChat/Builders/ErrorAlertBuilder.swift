//
//  ErrorAlertBuilder.swift
//  TinkoffChat
//
//  Created by Sofia on 27/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

class ErrorAlertBuilder: IErrorAlertBuilder {
    func build(with title: String, retryAction: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "Error: \(title)", message: nil, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            retryAction()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        return alert
    }
}
