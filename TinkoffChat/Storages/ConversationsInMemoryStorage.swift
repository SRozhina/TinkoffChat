//
//  ConversationsInMemoryStorage.swift
//  TinkoffChat
//
//  Created by Sofia on 03/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class ConversationsInMemoryStorage {
    internal func getOnlineConversations() -> [ConversationPreview] {
        return [
            ConversationPreview(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: "Привет",
                                          date: Date(timeIntervalSinceNow: -86400)),
            ConversationPreview(name: "Анна Павловна Анна Павловна Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: "Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет",
                                          date: Date()),
            ConversationPreview(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: "Привет",
                                          date: Date(timeIntervalSinceNow: -172800)),
            ConversationPreview(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSinceNow: -86400)),
            ConversationPreview(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date()),
            ConversationPreview(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: Date(timeIntervalSince1970: 1538594020)),
            ConversationPreview(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: "Привет",
                                          date: nil),
            ConversationPreview(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: nil,
                                          date: nil),
            ConversationPreview(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: nil),
            ConversationPreview(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSinceNow: -172800)),
            ConversationPreview(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: "Привет",
                                          date: Date()),
            ConversationPreview(name: "Анна Павловна Анна Павловна Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: "Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет",
                                          date: Date(timeIntervalSince1970: 1538594020)),
            ConversationPreview(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: "Привет",
                                          date: Date(timeIntervalSince1970: 1538594020)),
            ConversationPreview(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSinceNow: -86400)),
            ConversationPreview(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSince1970: 1538594020)),
            ConversationPreview(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: Date(timeIntervalSince1970: 1538594020)),
            ConversationPreview(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: "Привет",
                                          date: nil),
            ConversationPreview(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: nil),
            ConversationPreview(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: nil)
        ]
    }
    
    internal func getHistoryConversations() -> [ConversationPreview] {
        return [
            ConversationPreview(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSinceNow: -86400)),
            ConversationPreview(name: "Анна Павловна Анна Павловна Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет",
                                          date: Date(timeIntervalSince1970: 1538594020)),
            ConversationPreview(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSince1970: -172800)),
            ConversationPreview(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSinceNow: -86400)),
            ConversationPreview(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSince1970: 1538594020)),
            ConversationPreview(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: Date()),
            ConversationPreview(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: nil),
            ConversationPreview(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: nil),
            ConversationPreview(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: nil),
            ConversationPreview(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSince1970: -172800)),
            ConversationPreview(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSince1970: 1538594020)),
            ConversationPreview(name: "Анна Павловна Анна Павловна Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет",
                                          date: Date(timeIntervalSince1970: 1538594020)),
            ConversationPreview(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSince1970: 1538594020)),
            ConversationPreview(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: nil),
            ConversationPreview(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: nil)
        ]
    }
}
