//
//  ConversationsInMemoryStorage.swift
//  TinkoffChat
//
//  Created by Sofia on 03/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class ConversationsInMemoryStorage {
    internal func getOnlineConversations() -> [Conversation] {
        return [
            Conversation(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: "Привет",
                                          date: Date(timeIntervalSinceNow: -86400)),
            Conversation(name: "Анна Павловна Анна Павловна Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: "Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет",
                                          date: Date()),
            Conversation(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: "Привет",
                                          date: Date(timeIntervalSinceNow: -172800)),
            Conversation(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSinceNow: -86400)),
            Conversation(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date()),
            Conversation(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: Date(timeIntervalSince1970: 1538594020)),
            Conversation(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: "Привет",
                                          date: nil),
            Conversation(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: nil,
                                          date: nil),
            Conversation(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: nil),
            Conversation(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSinceNow: -172800)),
            Conversation(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: "Привет",
                                          date: Date()),
            Conversation(name: "Анна Павловна Анна Павловна Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: "Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет",
                                          date: Date(timeIntervalSince1970: 1538594020)),
            Conversation(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: "Привет",
                                          date: Date(timeIntervalSince1970: 1538594020)),
            Conversation(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSinceNow: -86400)),
            Conversation(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSince1970: 1538594020)),
            Conversation(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: Date(timeIntervalSince1970: 1538594020)),
            Conversation(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: true,
                                          message: "Привет",
                                          date: nil),
            Conversation(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: nil),
            Conversation(name: "Анна Павловна",
                                          online: true,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: nil)
        ]
    }
    
    internal func getHistoryConversations() -> [Conversation] {
        return [
            Conversation(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSinceNow: -86400)),
            Conversation(name: "Анна Павловна Анна Павловна Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет",
                                          date: Date(timeIntervalSince1970: 1538594020)),
            Conversation(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSince1970: -172800)),
            Conversation(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSinceNow: -86400)),
            Conversation(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSince1970: 1538594020)),
            Conversation(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: Date()),
            Conversation(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: nil),
            Conversation(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: nil),
            Conversation(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: nil),
            Conversation(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSince1970: -172800)),
            Conversation(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSince1970: 1538594020)),
            Conversation(name: "Анна Павловна Анна Павловна Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет Привет",
                                          date: Date(timeIntervalSince1970: 1538594020)),
            Conversation(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: Date(timeIntervalSince1970: 1538594020)),
            Conversation(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: "Привет",
                                          date: nil),
            Conversation(name: "Анна Павловна",
                                          online: false,
                                          hasUnreadMessages: false,
                                          message: nil,
                                          date: nil)
        ]
    }
}
