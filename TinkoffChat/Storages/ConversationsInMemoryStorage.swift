//
//  ConversationsInMemoryStorage.swift
//  TinkoffChat
//
//  Created by Sofia on 03/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//
import Foundation

class ConversationsInMemoryStorage: IConversationsStorage {
    private var conversations: [Conversation] = []

    func getConversations(_ completion: @escaping ([Conversation]) -> Void) {
        completion(conversations)
    }
    
    func updateConversations(by newConversations: [Conversation]) {
        self.conversations = newConversations
    }
    
    func updateConversation(by newConversation: Conversation) { }
}
