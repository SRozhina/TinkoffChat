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
        let id = conversationEntity?.id ?? IDBuilder.generateID()
        let user = userInfoConverter.makeUserInfo(from: conversationEntity?.user)
        let messagesEntities = (conversationEntity?.messages) ?? []
        let messages = messagesEntities.compactMap { messageConverter.makeMessage(from: $0 as? MessageEntity) }
        let isOnline = conversationEntity?.isOnline ?? false
        
        return Conversation(user: user, messages: messages, isOnline: isOnline, id: id)
    }
}
