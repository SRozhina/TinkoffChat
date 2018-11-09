//
//  IConversationConverter.swift
//  TinkoffChat
//
//  Created by Sofia on 09/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol IConversationConverter {
    func makeConversation(from conversationEntity: ConversationEntity?) -> Conversation
}

class ConversationConverter: IConversationConverter {
    private let userInfoConverter: IUserInfoConverter
    private let messageConverter: IMessageConverter
    
    init(userInfoConverter: IUserInfoConverter, messageConverter: IMessageConverter) {
        self.userInfoConverter = userInfoConverter
        self.messageConverter = messageConverter
    }
    
    func makeConversation(from conversationEntity: ConversationEntity?) -> Conversation {
        let user = userInfoConverter.makeUserInfo(from: conversationEntity?.user)
        let messagesEntities = (conversationEntity?.messages.allObjects.compactMap { $0 as? MessageEntity }) ?? []
        let messages = messagesEntities.map { messageConverter.makeMessage(from: $0) }
        let isOnline = conversationEntity?.isOnline ?? false
        
        return Conversation(user: user, messages: messages, isOnline: isOnline)
    }
}
