//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    var conversation: ConversationPreview?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = conversation.name
        
    }

}
