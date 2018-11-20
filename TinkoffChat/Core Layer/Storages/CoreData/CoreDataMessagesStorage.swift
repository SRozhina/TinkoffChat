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
        guard let fetchRequest = getFetchRequest(for: conversationId) else { return }
        let context = container.viewContext
        
        context.performAndWait {
            //let conversations = try? context.fetch(fetchRequest)
            //let conversation = conversations?.first
            let messages = try? context.fetch(fetchRequest)
            messages?.forEach { $0.isUnread = false }
            try? context.save()
        }
    }
    
    func appendMessage(_ message: Message, to conversationId: String) {
        guard let fetchRequest = getFetchRequest(for: conversationId) else { return }
        let context = container.viewContext
        
        context.performAndWait {
            //let conversations = try? context.fetch(fetchRequest)
            var messages = try? context.fetch(fetchRequest)

            //let conversation = conversations?.first
            let messageEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: MessageEntity.self),
                                                                    into: context) as? MessageEntity
            messageEntity?.id = message.id
            messageEntity?.date = message.date as NSDate
            messageEntity?.direction = Int32(message.direction.rawValue)
            messageEntity?.text = message.text
            messageEntity?.isUnread = message.isUnread
            
            guard let messageEntityUnwrapped = messageEntity else { return }
            messages?.append(messageEntityUnwrapped)
            //conversation?.addToMessages(messageEntityUnwrapped)
            try? context.save()
        }
    }
    
    func getFetchRequest(for conversationId: String) -> NSFetchRequest<MessageEntity>? {
        return container.managedObjectModel.fetchRequestFromTemplate(withName: "ConversationMessages",
                                                                     substitutionVariables: ["CONVERSATIONID": conversationId])
            as? NSFetchRequest<MessageEntity>
    }
}
