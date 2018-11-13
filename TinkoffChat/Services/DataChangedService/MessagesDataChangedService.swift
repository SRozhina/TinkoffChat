//
//  MessagesDataChangedService.swift
//  TinkoffChat
//
//  Created by Sofia on 13/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import CoreData

class MessagesDataChangedService: NSObject, NSFetchedResultsControllerDelegate, IMessagesDataChangedService {
    private let context: NSManagedObjectContext
    private var fetchResultsController: NSFetchedResultsController<MessageEntity>!
    weak var messagesDelegate: MessagesDataChangedServiceDelegate?
    
    init(container: NSPersistentContainer) {
        self.context = container.viewContext
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
            messagesDelegate?.insertMessage(at: newIndexPath)
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
