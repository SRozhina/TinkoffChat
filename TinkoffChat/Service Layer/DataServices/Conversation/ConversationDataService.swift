//
//  ConversationsDataService.swift
//  TinkoffChat
//
//  Created by Sofia on 14/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import CoreData

class ConversationDataService: NSObject, NSFetchedResultsControllerDelegate, IConversationDataService {
    private let context: NSManagedObjectContext
    private var fetchResultsController: NSFetchedResultsController<ConversationEntity>!
    private let conversationConverter: IConversationConverter
    weak var conversationDelegate: ConversationDataServiceDelegate?
    private var conversationId = ""
    
    init(container: NSPersistentContainer,
         conversationConverter: IConversationConverter) {
        self.context = container.viewContext
        self.conversationConverter = conversationConverter
    }
    
    func setupService(with conversationId: String) {
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: String(describing: ConversationEntity.self))
        let sordDescriptor = NSSortDescriptor(key: #keyPath(ConversationEntity.id), ascending: true)
        let predicate = NSPredicate(format: "id == %@", conversationId)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sordDescriptor]
        fetchRequest.resultType = .managedObjectResultType
        
        fetchResultsController = NSFetchedResultsController<ConversationEntity>(fetchRequest: fetchRequest,
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
        guard let conversationEntity = anObject as? ConversationEntity else { return }
        let conversation = conversationConverter.makeConversation(from: conversationEntity)
        switch type {
        case .update:
            conversationDelegate?.updateConversation(conversation)
        default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationDelegate?.startUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationDelegate?.endUpdates()
    }
}
