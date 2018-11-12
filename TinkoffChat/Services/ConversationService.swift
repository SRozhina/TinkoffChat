//
//  ConversationService.swift
//  TinkoffChat
//
//  Created by Sofia on 12/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import CoreData

protocol ConversationServiceDelegate: class {
    func startUpdates()
    func endUpdates()
    func updateMessage(at indexPath: IndexPath)
    func insertMessage(at indexPath: IndexPath)
    func deleteMessage(at indexPath: IndexPath)
    func updateStateFor(_ user: UserInfo)
    func showError(with error: String, retryAction: @escaping () -> Void)
}

class ConversationService: NSObject, IConversationService {
    private let context: NSManagedObjectContext
    private let conversationsStorage: IConversationsStorage
    private var communicationService: ICommunicationService
    private var conversationsListService: IConversationsListService
    private var messagesFetchResultsController: NSFetchedResultsController<MessageEntity>!
    weak var delegate: ConversationServiceDelegate?
    
    init(conversationsStorage: IConversationsStorage,
         communicationService: ICommunicationService,
         conversationsListService: IConversationsListService,
         container: NSPersistentContainer) {
        self.conversationsStorage = conversationsStorage
        self.communicationService = communicationService
        self.conversationsListService = conversationsListService
        self.context = container.viewContext
        super.init()
        
    }
    
    func setupService(for conversationId: String) {
        createFetchResultsController(with: conversationId)
        
        messagesFetchResultsController.delegate = self
        try? messagesFetchResultsController.performFetch()
        communicationService.delegate = self
        communicationService.online = true
    }
    
    private func createFetchResultsController(with conversationId: String) {
        let messagesPredicate = NSPredicate(format: "conversation.id==%@", conversationId)
        let messagesFetchRequest = NSFetchRequest<MessageEntity>(entityName: String(describing: MessageEntity.self))
        messagesFetchRequest.predicate = messagesPredicate
        let messagesSortDescriptorName = NSSortDescriptor(key: #keyPath(MessageEntity.date), ascending: true)
        messagesFetchRequest.sortDescriptors = [messagesSortDescriptorName]
        messagesFetchRequest.resultType = .managedObjectResultType
        
        messagesFetchResultsController = NSFetchedResultsController<MessageEntity>(fetchRequest: messagesFetchRequest,
                                                                                   managedObjectContext: context,
                                                                                   sectionNameKeyPath: nil,
                                                                                   cacheName: nil)
    }
    
    func setAllMessagesAsRead(in conversationId: String) {
        conversationsStorage.setAllMessagesAsRead(in: conversationId)
    }
    
    func sendMessage(_ message: Message, in conversation: Conversation) {
        conversationsStorage.appendMessage(message, to: conversation.id)
        communicationService.send(message, to: conversation.user)
    }
}

extension ConversationService: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .update:
            guard let indexPath = indexPath else { return }
            delegate?.updateMessage(at: indexPath)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            delegate?.insertMessage(at: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            delegate?.deleteMessage(at: indexPath)
        default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.startUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.endUpdates()
    }
}

extension ConversationService: ICommunicationServiceDelegate {
    func communicationService(_ communicationService: ICommunicationService, didFoundPeer user: UserInfo) {
        if let existingConversation = conversationsListService.getHistoryConversations().filter({ $0.user.name == user.name }).first {
            conversationsStorage.setOnlineStatus(true, to: existingConversation.id)
            delegate?.updateStateFor(user)
            return
        }

        let conversation = Conversation(user: user)
        conversationsStorage.createConversation(conversation)
    }
    
    func communicationService(_ communicationService: ICommunicationService, didLostPeer user: UserInfo) {
        if let onlineConversation = conversationsListService.getOnlineConversations().filter({ $0.user.name == user.name }).first {
            conversationsStorage.setOnlineStatus(false, to: onlineConversation.id)
            delegate?.updateStateFor(user)
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
        if let conversation = conversationsListService.getOnlineConversations().filter({ $0.user.name == user.name }).first {
            conversationsStorage.appendMessage(message, to: conversation.id)
        }
    }
}
