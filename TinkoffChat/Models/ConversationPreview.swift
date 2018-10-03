//
//  ConversationCellConfiguration.swift
//  TinkoffChat
//
//  Created by Sofia on 03/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//
import Foundation

protocol ConversationCellConfiguration: class {
    var name: String { get set }
    var message: String? { get set }
    var date: Date? { get set }
    var online: Bool { get set }
    var hasUnreadMessages: Bool { get set }
}

class ConversationPreview: ConversationCellConfiguration {
    var name: String
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessages: Bool
    
    init(name: String, online: Bool, hasUnreadMessages: Bool, message: String? = nil, date: Date? = nil) {
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
    }
}
