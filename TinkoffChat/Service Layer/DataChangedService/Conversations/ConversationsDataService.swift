//
//  ConversationsDataService.swift
//  TinkoffChat
//
//  Created by Sofia on 14/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import CoreData

class ConversationsDataService: NSObject, NSFetchedResultsControllerDelegate, IConversationsDataService {
    private let context: NSManagedObjectContext
    private var fetchResultsController: NSFetchedResultsController<ConversationEntity>!
    private let conversationConverter: IConversationConverter
    private let conversationsStorage: IConversationsStorage
    private let messagesStorage: IMessagesStorage
    weak var conversationsDelegate: ConversationsDataServiceDelegate?
    
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
        guard let conversationEntity = anObject as? ConversationEntity else { return }
        let conversation = conversationConverter.makeConversation(from: conversationEntity)
        switch type {
        case .update:
            guard let indexPath = indexPath else { return }
            conversationsDelegate?.updateConversation(conversation, at: indexPath)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            conversationsDelegate?.insertConversation(conversation, at: newIndexPath)
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
    
    func goOffline() {
        conversationsStorage.goOffline()
    }
    
    func appendMessage(_ message: Message, to conversationId: String) {
        messagesStorage.appendMessage(message, to: conversationId)
    }
    
    func createConversation(_ newConversation: Conversation) {
        conversationsStorage.createConversation(newConversation)
    }
    
    func setOnlineStatus(_ value: Bool, to conversationId: String) {
        conversationsStorage.setOnlineStatus(value, to: conversationId)
    }
    
    func setAllMessagesAsRead(in conversationId: String) {
        messagesStorage.setAllMessagesAsRead(in: conversationId)
    }
}
