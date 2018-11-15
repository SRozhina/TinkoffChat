//
//  ConversationCellConfiguration.swift
//  TinkoffChat
//
//  Created by Sofia on 03/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//
import Foundation

protocol ConversationCellConfiguration: class {
    var id: String { get set }
    var name: String { get set }
    var message: String? { get set }
    var date: Date? { get set }
    var online: Bool { get set }
    var hasUnreadMessages: Bool { get set }
}

class ConversationPreview: ConversationCellConfiguration {
    var id: String
    var name: String
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessages: Bool
    
    init(id: String, name: String, online: Bool, hasUnreadMessages: Bool, message: String? = nil, date: Date? = nil) {
        self.id = id
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
    }
}
