//
//  IConversationsListInteractor.swift
//  TinkoffChat
//
//  Created by Sofia on 15/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

protocol IConversationsListInteractor: class {
    func setup()
    func selectConversation(_ conversation: Conversation)
    func getOnlineConversations() -> [Conversation]
    func getHistoryConversations() -> [Conversation]
    var delegate: ConversationsListInteractorDelegate? { get set }
}
