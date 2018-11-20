//
//  CoreDataMessagesStorage.swift
//  TinkoffChat
//
//  Created by Sofia on 16/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataMessagesStorage: IMessagesStorage {
    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
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
}
