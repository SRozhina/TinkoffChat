//
//  IncomingMessageCell.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

class IncomingMessageCell: UITableViewCell, ChatCell {    
    @IBOutlet private weak var messageView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = 10
    }
    
    internal func setup(with message: Message) {
        messageLabel.text = message.text
    }
}
