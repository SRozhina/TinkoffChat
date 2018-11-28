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
    weak var messagesDelegate: MessagesDataServiceDelegate?
    
    init(container: NSPersistentContainer, messageConverter: IMessageConverter) {
        self.context = container.viewContext
        self.messageConverter = messageConverter
    }
    
    func setupService(with conversationId: String) {
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .update:
            guard let indexPath = indexPath else { return }
            messagesDelegate?.updateMessage(at: indexPath)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            guard let messageEntity = anObject as? MessageEntity else { return }
            let message = messageConverter.makeMessage(from: messageEntity)
            messagesDelegate?.insertMessage(message, at: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            messagesDelegate?.deleteMessage(at: indexPath)
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
