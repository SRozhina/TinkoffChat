//
//  OnlineConversationsDataService.swift
//  TinkoffChat
//
//  Created by Sofia on 01/12/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import CoreData

class OnlineConversationsDataService: NSObject, NSFetchedResultsControllerDelegate, IOnlineConversationsDataService {
    private let context: NSManagedObjectContext
    private var fetchResultsController: NSFetchedResultsController<ConversationEntity>!
    private let conversationConverter: IConversationConverter
    private let conversationsStorage: IConversationsStorage
    private let messagesStorage: IMessagesStorage
    weak var conversationsDelegate: OnlineConversationsDataServiceDelegate?
    
    init(container: NSPersistentContainer,
         conversationConverter: IConversationConverter,
         conversationsStorage: IConversationsStorage,
         messagesStorage: IMessagesStorage) {
        self.context = container.viewContext
        self.conversationConverter = conversationConverter
        self.conversationsStorage = conversationsStorage
        self.messagesStorage = messagesStorage
    }
    
    func setupService() {
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: String(describing: ConversationEntity.self))
        let predicate = NSPredicate(format: "isOnline == %@", NSNumber(value: true))
//        let sortDescriptorHasUnreadMessages = NSSortDescriptor(key: #keyPath(ConversationEntity.messages), ascending: true, selector: #selector(compare(_:)))
//        let sortDescriptorHasUnreadMessages = NSSortDescriptor(key: #keyPath(ConversationEntity.messages), ascending: true, comparator: {
//            guard let first = $0 as? [MessageEntity], let second = $1 as? [MessageEntity] else { return .orderedAscending }
//            if first.contains(where: { $0.isUnread }) { return .orderedAscending }
//            if second.contains(where: { $0.isUnread }) { return .orderedDescending }
//            return .orderedAscending
//        })
        let sortDescriptorName = NSSortDescriptor(key: #keyPath(ConversationEntity.user.name), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorName]
        fetchRequest.predicate = predicate
        fetchRequest.resultType = .managedObjectResultType
        
        fetchResultsController = NSFetchedResultsController<ConversationEntity>(fetchRequest: fetchRequest,
                                                                                managedObjectContext: context,
                                                                                sectionNameKeyPath: nil,
                                                                                cacheName: nil)
        fetchResultsController.delegate = self
        try? fetchResultsController.performFetch()
    }
    
    func getConversations() -> [Conversation] {
        return fetchResultsController.fetchedObjects?
            .compactMap { conversationConverter.makeConversation(from: $0) } ?? []
    }
    
    func createConversation(_ newConversation: Conversation) {
        conversationsStorage.createConversation(newConversation)
    }
    
    func setOnlineStatus(_ value: Bool, to conversationId: String) {
        conversationsStorage.setOnlineStatus(value, to: conversationId)
    }
    
    func appendMessage(_ message: Message, to conversationId: String) {
        messagesStorage.appendMessage(message, to: conversationId)
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
            guard let indexPath = indexPath else { return }
            conversationsDelegate?.updateConversation(conversation, at: indexPath)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            conversationsDelegate?.insertConversation(conversation, at: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            conversationsDelegate?.deleteConversation(conversation, at: indexPath)
        case .move:
            guard let indexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            conversationsDelegate?.moveConversation(conversation, from: indexPath, to: newIndexPath)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationsDelegate?.startUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationsDelegate?.endUpdates()
    }
}
