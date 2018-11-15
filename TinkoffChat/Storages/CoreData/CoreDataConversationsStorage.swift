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
    private let userInfoPathProvider: IUserInfoPathProvider
    private let container: NSPersistentContainer
    
    init(conversationConverter: IConversationConverter,
         userInfoConverter: IUserInfoConverter,
         container: NSPersistentContainer,
         userInfoPathProvider: IUserInfoPathProvider) {
        self.conversationConverter = conversationConverter
        self.userInfoConverter = userInfoConverter
        self.container = container
        self.userInfoPathProvider = userInfoPathProvider
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
        let context = container.viewContext
        context.performAndWait {
            let conversation = NSEntityDescription.insertNewObject(forEntityName: String(describing: ConversationEntity.self),
                                                                   into: context) as? ConversationEntity
            if let user = NSEntityDescription.insertNewObject(forEntityName: String(describing: UserInfoEntity.self),
                                                              into: context) as? UserInfoEntity {
                conversation?.user = user
            }

            conversation?.id = newConversation.id
            conversation?.user.name = newConversation.user.name
            conversation?.user.info = newConversation.user.info
            conversation?.user.avatar = userInfoConverter.getAvatarPath(for: newConversation.user.avatar)
            conversation?.isOnline = newConversation.isOnline

            try? context.save()
        }
    }
    
    private func createUserProfile() -> UserInfoEntity? {
        let context = container.viewContext
        var userEntity: UserInfoEntity?
        //context.performAndWait {
            userEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: UserInfoEntity.self),
                                                             into: context) as? UserInfoEntity
            userEntity?.id = 0
            userEntity?.name = "No name"
            userEntity?.info = ""
            try? context.save()
            return userEntity
        //}
    }
    
    func saveUserProfile(_ newUserInfo: UserInfo) {
        let predicate = NSPredicate(format: "id==0")
        let fetchRequest = NSFetchRequest<UserInfoEntity>(entityName: String(describing: UserInfoEntity.self))
        fetchRequest.predicate = predicate
        let context = container.viewContext
        context.performAndWait {
            let users = try? context.fetch(fetchRequest)
            guard let userEntity = (users?.first ?? createUserProfile()) else { return }
            userEntity.name = newUserInfo.name
            userEntity.info = newUserInfo.info
            if let image = newUserInfo.avatar,
                let imageData = UIImageJPEGRepresentation(image, 1) {
                try? imageData.write(to: self.userInfoPathProvider.avatarFilePath)
            }
            userEntity.avatar = self.userInfoPathProvider.avatarFilePath
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
