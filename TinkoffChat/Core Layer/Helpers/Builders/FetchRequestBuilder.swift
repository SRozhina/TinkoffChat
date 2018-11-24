//
//  FetchRequestBuilder.swift
//  TinkoffChat
//
//  Created by Sofia on 11/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import CoreData

class FetchRequestBuilder {
    func conversationFetchRequest(with id: String) -> NSFetchRequest<ConversationEntity> {
        let predicate = NSPredicate(format: "id==%@", id)
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: String(describing: ConversationEntity.self))
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    func conversationsFetchRequest() -> NSFetchRequest<ConversationEntity> {
        //for conversation list
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: String(describing: ConversationEntity.self))
        let sortDescriptorName = NSSortDescriptor(key: #keyPath(ConversationEntity.user.name), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorName]
        return fetchRequest
    }
    
    func onlineConversationsFetchRequest() -> NSFetchRequest<ConversationEntity> {
        let predicateOnline = NSPredicate(format: "isOnline==%@", NSNumber(value: true))
        let predicateHasMessages = NSPredicate(format: "messages.@count>%d", 0)
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOnline, predicateHasMessages])
        
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: String(describing: ConversationEntity.self))
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    func messagesFetchRequest(by conversationId: String) -> NSFetchRequest<MessageEntity> {
        //for conversation
        let predicate = NSPredicate(format: "conversation.id==%@", conversationId)
        let fetchRequest = NSFetchRequest<MessageEntity>(entityName: String(describing: MessageEntity.self))
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    func usersOnlineFetchRequest() -> NSFetchRequest<UserInfoEntity> {
        let predicate = NSPredicate(format: "conversation.isOnline==%@", NSNumber(value: true))
        let fetchRequest = NSFetchRequest<UserInfoEntity>(entityName: String(describing: UserInfoEntity.self))
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    func userFetchRequest(with name: String) -> NSFetchRequest<UserInfoEntity> {
        //for user profile
        let predicate = NSPredicate(format: "name==%@", name)
        let fetchRequest = NSFetchRequest<UserInfoEntity>(entityName: String(describing: UserInfoEntity.self))
        fetchRequest.predicate = predicate
        return fetchRequest
    }
}
