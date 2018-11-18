//
//  ConversationsInMemoryStorage.swift
//  TinkoffChat
//
//  Created by Sofia on 03/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//
import Foundation

//class ConversationsInMemoryStorage: IConversationsStorage {
//    func appendMessage(_ message: Message, to conversationId: String) {
//    }
//    
//    private var conversations: [Conversation] = []
//
//    func getConversations(_ completion: @escaping ([Conversation]) -> Void) {
//        completion(conversations)
//    }
//    
//    func updateConversation(by newConversation: Conversation) {
//        var oldConversation = conversations.filter { $0.id == newConversation.id }.first
//        oldConversation = newConversation
//    }
//    
//    func goOffline() {
//        conversations.forEach { $0.isOnline = false }
//    }
//}
