//
//  ConversationsListService.swift
//  TinkoffChat
//
//  Created by Sofia on 11/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import CoreData

protocol ConversationsListServiceDelegate: class {
    func startUpdates()
    func endUpdates()
    func updateConversation(in section: Int)
    func updateConversations()
    func showError(with error: String, retryAction: @escaping () -> Void)
}

protocol IConversationsListService {
    func getOnlineConversations() -> [Conversation]
    func getHistoryConversations() -> [Conversation]
    func setupService()
    var delegate: ConversationsListServiceDelegate? { get set }
}

class ConversationsListService: NSObject, IConversationsListService {
    private let context: NSManagedObjectContext
    private let conversationsStorage: IConversationsStorage
    private var communicationService: ICommunicationService
    private var fetchResultsController: NSFetchedResultsController<ConversationEntity>!
    private let conversationConverter: IConversationConverter
    weak var delegate: ConversationsListServiceDelegate?
    
    init(conversationsStorage: IConversationsStorage,
         conversationConverter: IConversationConverter,
         communicationService: ICommunicationService,
         container: NSPersistentContainer) {
        self.conversationsStorage = conversationsStorage
        self.conversationConverter = conversationConverter
        self.communicationService = communicationService
        self.context = container.viewContext
        super.init()
        
    }
    
    func setupService() {
        createFetchResultsController()
        
        fetchResultsController.delegate = self
        try? fetchResultsController.performFetch()
        communicationService.delegate = self
        communicationService.online = true
    }
    
    private func createFetchResultsController() {
        let fetchRequest = NSFetchRequest<ConversationEntity>(entityName: String(describing: ConversationEntity.self))
        let sortDescriptorName = NSSortDescriptor(key: #keyPath(ConversationEntity.user.name), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorName]
        fetchRequest.resultType = .managedObjectResultType

        fetchResultsController = NSFetchedResultsController<ConversationEntity>(fetchRequest: fetchRequest,
                                                                                managedObjectContext: context,
                                                                                sectionNameKeyPath: nil,
                                                                                cacheName: nil)
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
}

extension ConversationsListService: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        switch type {
        case .update:
            delegate?.updateConversations()
        case .insert:
            delegate?.updateConversation(in: indexPath.section)
        case .delete:
            delegate?.updateConversation(in: indexPath.section)
        case .move:
            delegate?.updateConversations()
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.startUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.endUpdates()
    }
}

extension ConversationsListService: ICommunicationServiceDelegate {
    func communicationService(_ communicationService: ICommunicationService, didFoundPeer user: UserInfo) {
        if let existingConversation = getHistoryConversations().filter({ $0.user.name == user.name }).first {
            conversationsStorage.setOnlineStatus(true, to: existingConversation.id)
            return
        }
        let conversation = Conversation(user: user)
        conversationsStorage.createConversation(conversation)
    }
    
    func communicationService(_ communicationService: ICommunicationService, didLostPeer user: UserInfo) {
        if let onlineConversation = getOnlineConversations().filter({ $0.user.name == user.name }).first {
            conversationsStorage.setOnlineStatus(false, to: onlineConversation.id)
        }
    }
    
    func communicationService(_ communicationService: ICommunicationService, didNotStartBrowsingForPeers error: Error) {
        delegate?.showError(with: error.localizedDescription) {
            self.communicationService.online = true
        }
    }
    
    func communicationService(_ communicationService: ICommunicationService,
                              didReceiveInviteFromPeer peer: UserInfo,
                              invintationClosure: (Bool) -> Void) {
        invintationClosure(true)
    }
    
    func communicationService(_ communicationService: ICommunicationService, didNotStartAdvertisingForPeers error: Error) {
        delegate?.showError(with: error.localizedDescription) {
            self.communicationService.online = true
        }
    }
    
    func communicationService(_ communicationService: ICommunicationService, didReceiveMessage message: Message, from user: UserInfo) {
        if let conversation = getOnlineConversations().filter({ $0.user.name == user.name }).first {
            conversationsStorage.appendMessage(message, to: conversation.id)
        }
    }
}
