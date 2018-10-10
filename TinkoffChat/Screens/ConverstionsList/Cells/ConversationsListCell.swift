//
//  ConversationsListCell.swift
//  TinkoffChat
//
//  Created by Sofia on 03/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

class ConversationsListCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with configuration: ConversationPreview) {
        nameLabel.text = configuration.name
        setupMessageWith(text: configuration.message, isUnread: configuration.hasUnreadMessages)
        dateLabel.text = formatDate(configuration.date)
        backgroundColor = configuration.online ? UIColor(named: "cellOnline") : .white
    }
    
    private func setupMessageWith(text: String?, isUnread: Bool) {
        let fontWeight: UIFont.Weight = isUnread ? .bold : .regular
        let font = text == nil
            ? UIFont.italicSystemFont(ofSize: messageLabel.font.pointSize)
            : UIFont.systemFont(ofSize: messageLabel.font.pointSize, weight: fontWeight)
        messageLabel.font = font
        messageLabel.text = text ?? "No messages yet"
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateFormat = "d MMM"
        }
        return formatter.string(from: date)
    }
}
