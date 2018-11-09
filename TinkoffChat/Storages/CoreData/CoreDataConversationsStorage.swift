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
        return container
    }()
    
    func getConversations(_ completion: @escaping ([Conversation]) -> Void) {
        let context = container.viewContext
        context .performAndWait {
            let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: String(describing: UserInfoEntity.self))
            let conversationEntities = (try? context.fetch(fetchRequest)) ?? []
            let conversations = conversationEntities.map { conversationConverter.makeConversation(from: $0) }
            completion(conversations)
        }
    }
    
    func updateConversation(by newConversation: Conversation) {
        let predicate = NSPredicate(format: "id==%@", "\(newConversation.id)")
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: String(describing: ConversationEntity.self))
        fetchRequest.predicate = predicate
        
        let context = container.viewContext
        context.performAndWait {
            let conversations = try? context.fetch(fetchRequest)
            var conversation = conversations?.first
            if conversation == nil {
                conversation = createNewConversation(in: context)
            }
            conversation?.user.name = newConversation.user.name
            conversation?.user.info = newConversation.user.info
            conversation?.user.avatar = userInfoConverter.getAvatarPath(for: newConversation.user.avatar)
            
            let messageEntities: [MessageEntity] = newConversation.messages.map {
                let messageEntity = MessageEntity(context: context)
                messageEntity.id = $0.id
                messageEntity.date = $0.date as NSDate
                messageEntity.direction = Int32($0.direction.rawValue)
                messageEntity.text = $0.text
                messageEntity.isUnread = $0.isUnread
                return messageEntity
            }
            conversation?.addToMessages(NSSet(array: messageEntities))
            //http://qaru.site/questions/495255/swift-and-coredata-problems-with-relationship-nsset-nsset-intersectsset-set-argument-is-not-an-nsset
            //https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/HowManagedObjectsarerelated.html
            conversation?.isOnline = newConversation.isOnline
            try? context.save()
        }
    }
    
    private func createNewConversation(in context: NSManagedObjectContext) -> ConversationEntity? {
        let conversationEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: ConversationEntity.self), into: context) as? ConversationEntity
        return conversationEntity
    }
    
    func updateConversations(by newConversations: [Conversation]) { }
}
