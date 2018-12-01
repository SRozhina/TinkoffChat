//
//  MessagesDataService.swift
//  TinkoffChat
//
//  Created by Sofia on 13/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import CoreData

class MessagesDataService: NSObject, NSFetchedResultsControllerDelegate, IMessagesDataService {
    private let context: NSManagedObjectContext
    private var fetchResultsController: NSFetchedResultsController<MessageEntity>!
    private var messageConverter: IMessageConverter!
    private let messagesStorage: IMessagesStorage
    weak var messagesDelegate: MessagesDataServiceDelegate?
    private var conversationId: String = ""
    
    init(container: NSPersistentContainer, messageConverter: IMessageConverter, messagesStorage: IMessagesStorage) {
        self.context = container.viewContext
        self.messageConverter = messageConverter
        self.messagesStorage = messagesStorage
    }
    
    func setupService(with conversationId: String) {
        self.conversationId = conversationId
        let predicate = NSPredicate(format: "conversation.id==%@", conversationId)
        let fetchRequest = NSFetchRequest<MessageEntity>(entityName: String(describing: MessageEntity.self))
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: #keyPath(MessageEntity.date), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.resultType = .managedObjectResultType
        
        fetchResultsController = NSFetchedResultsController<MessageEntity>(fetchRequest: fetchRequest,
                                                                           managedObjectContext: context,
                                                                           sectionNameKeyPath: nil,
                                                                           cacheName: nil)
        fetchResultsController.delegate = self
        try? fetchResultsController.performFetch()
    }
    
    func setAllMessagesAsRead() {
        if conversationId.isEmpty { return }
        messagesStorage.setAllMessagesAsRead(in: conversationId)
    }
    
    func appendMessage(_ message: Message) {
        messagesStorage.appendMessage(message, to: conversationId)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            guard let messageEntity = anObject as? MessageEntity else { return }
            let message = messageConverter.makeMessage(from: messageEntity)
            messagesDelegate?.insertMessage(message, at: newIndexPath)
        default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        messagesDelegate?.startUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        messagesDelegate?.endUpdates()
    }
}
