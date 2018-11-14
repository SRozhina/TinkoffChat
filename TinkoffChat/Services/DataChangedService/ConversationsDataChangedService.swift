//
//  ConversationsDataChangedService.swift
//  TinkoffChat
//
//  Created by Sofia on 14/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import CoreData

class ConversationsDataChangedService: NSObject, NSFetchedResultsControllerDelegate, IConversationsDataChangedService {
    private let context: NSManagedObjectContext
    private var fetchResultsController: NSFetchedResultsController<ConversationEntity>!
    private let conversationConverter: IConversationConverter
    weak var conversationsDelegate: ConversationsDataChangedServiceDelegate?
    
    init(container: NSPersistentContainer, conversationConverter: IConversationConverter) {
        self.context = container.viewContext
        self.conversationConverter = conversationConverter
    }
    
    func setupService() {
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: String(describing: ConversationEntity.self))
        let sortDescriptorName = NSSortDescriptor(key: #keyPath(ConversationEntity.user.name), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorName]
        fetchRequest.resultType = .managedObjectResultType
        
        fetchResultsController = NSFetchedResultsController<ConversationEntity>(fetchRequest: fetchRequest,
                                                                                managedObjectContext: context,
                                                                                sectionNameKeyPath: nil,
                                                                                cacheName: nil)
        fetchResultsController.delegate = self
        try? fetchResultsController.performFetch()
    }
    
    func getOnlineConversations() -> [Conversation] {
        guard let section = fetchResultsController.sections?.first else { return [] }
        let conversationEntities = section.objects as? [ConversationEntity]
        return conversationEntities?
            .compactMap { conversationConverter.makeConversation(from: $0) }
            .filter { $0.isOnline } ?? []
    }
    
    func getHistoryConversations() -> [Conversation] {
        guard let section = fetchResultsController.sections?.first else { return [] }
        let conversationEntities = section.objects as? [ConversationEntity]
        return conversationEntities?
            .compactMap { conversationConverter.makeConversation(from: $0) }
            .filter { !$0.isOnline } ?? []
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .update:
            conversationsDelegate?.updateConversations()
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            conversationsDelegate?.updateConversation(in: newIndexPath.section)
        case .delete:
            guard let indexPath = indexPath else { return }
            conversationsDelegate?.updateConversation(in: indexPath.section)
        case .move:
            conversationsDelegate?.updateConversations()
        default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationsDelegate?.startUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationsDelegate?.endUpdates()
    }
}
