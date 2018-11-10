//
//  CoreDataConversationsStorage.swift
//  TinkoffChat
//
//  Created by Sofia on 09/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataConversationsStorage: IConversationsStorage {
    private let conversationConverter: IConversationConverter
    private let userInfoConverter: IUserInfoConverter
    
    init(conversationConverter: IConversationConverter, userInfoConverter: IUserInfoConverter) {
        self.conversationConverter = conversationConverter
        self.userInfoConverter = userInfoConverter
    }
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TinkoffChat")
        container.loadPersistentStores(completionHandler: { _, _ in })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    func getConversations(_ completion: @escaping ([Conversation]) -> Void) {
        
        let context = container.viewContext
        context.performAndWait {
            let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: String(describing: ConversationEntity.self))
            let conversationEntities = (try? context.fetch(fetchRequest)) ?? []
            let conversations = conversationEntities.map { conversationConverter.makeConversation(from: $0) }
            completion(conversations)
        }
    }
    
    func goOffline() {
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: String(describing: ConversationEntity.self))
        let context = container.viewContext

        context.performAndWait {
            let conversations = try? context.fetch(fetchRequest)
            conversations?.forEach { $0.isOnline = false }
            try? context.save()
        }
    }
    
    func createConversation(_ newConversation: Conversation) {
        let predicate = NSPredicate(format: "id==%@", "\(newConversation.id)")
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: String(describing: ConversationEntity.self))
        fetchRequest.predicate = predicate
        
        let context = container.viewContext
        context.performAndWait {
            let conversations = try? context.fetch(fetchRequest)
            var conversation = conversations?.first
            if conversation != nil { return }
            conversation = createNewConversation(in: context)
            conversation?.id = newConversation.id
            conversation?.user.name = newConversation.user.name
            conversation?.user.info = newConversation.user.info
            conversation?.user.avatar = userInfoConverter.getAvatarPath(for: newConversation.user.avatar)
            conversation?.isOnline = newConversation.isOnline
            try? context.save()
        }
    }
    
    func setOnlineStatus(_ value: Bool, to conversationId: String) {
        let predicate = NSPredicate(format: "id==%@", "\(conversationId)")
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: String(describing: ConversationEntity.self))
        fetchRequest.predicate = predicate
        
        let context = container.viewContext
        
        context.performAndWait {
            let conversations = try? context.fetch(fetchRequest)
            let conversation = conversations?.first
            conversation?.isOnline = value
            try? context.save()
        }
    }
    
    func setAllMessagesAsRead(in conversationId: String) {
        let predicate = NSPredicate(format: "id==%@", "\(conversationId)")
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: String(describing: ConversationEntity.self))
        fetchRequest.predicate = predicate
        
        let context = container.viewContext
        
        context.performAndWait {
            let conversations = try? context.fetch(fetchRequest)
            let conversation = conversations?.first
            conversation?.messages.forEach { ($0 as? MessageEntity)?.isUnread = false }
            try? context.save()
        }
    }
    
    func appendMessage(_ message: Message, to conversationId: String) {
        let predicate = NSPredicate(format: "id==%@", "\(conversationId)")
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: String(describing: ConversationEntity.self))
        fetchRequest.predicate = predicate
        
        let context = container.viewContext
        
        context.performAndWait {
            let conversations = try? context.fetch(fetchRequest)
            let conversation = conversations?.first
            let messageEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: MessageEntity.self),
                                                                    into: context) as? MessageEntity
            messageEntity?.id = message.id
            messageEntity?.date = message.date as NSDate
            messageEntity?.direction = Int32(message.direction.rawValue)
            messageEntity?.text = message.text
            messageEntity?.isUnread = message.isUnread
            
            guard let messageEntityUnwrapped = messageEntity else { return }
            conversation?.addToMessages(messageEntityUnwrapped)
            try? context.save()
        }
    }
    
    private func createNewConversation(in context: NSManagedObjectContext) -> ConversationEntity? {
        let conversationEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: ConversationEntity.self),
                                                                     into: context) as? ConversationEntity
        if let userEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: UserInfoEntity.self),
                                                                into: context) as? UserInfoEntity {
            conversationEntity?.user = userEntity
        }
        return conversationEntity
    }
}

class FetchRequestBuilder {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public lazy var fetchResultsController: NSFetchedResultsController<ConversationEntity> = {
        let sortDescriptorOnline = NSSortDescriptor(key: #keyPath(ConversationEntity.isOnline), ascending: true)
        let sortDescriptorName = NSSortDescriptor(key: #keyPath(ConversationEntity.user.name), ascending: true)
        let fetchRequest = onlineConversationsFetchRequest()
        fetchRequest.sortDescriptors = [sortDescriptorOnline, sortDescriptorName]
        fetchRequest.resultType = .managedObjectResultType
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        return controller
    }()
    
    func conversationFetchRequest(with id: String) -> NSFetchRequest<ConversationEntity> {
        let predicate = NSPredicate(format: "id==%@", id)
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: String(describing: ConversationEntity.self))
        fetchRequest.predicate = predicate
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
        let predicate = NSPredicate(format: "conversation.id==%@", conversationId)
        let fetchRequest = NSFetchRequest<MessageEntity>(entityName: String(describing: ConversationEntity.self))
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
        let predicate = NSPredicate(format: "name==%@", name)
        let fetchRequest = NSFetchRequest<UserInfoEntity>(entityName: String(describing: UserInfoEntity.self))
        fetchRequest.predicate = predicate
        return fetchRequest
    }
}
