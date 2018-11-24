//
//  IConversationsDataService.swift
//  TinkoffChat
//
//  Created by Sofia on 14/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol IConversationsDataService {
    func setupService()
    func getOnlineConversations() -> [Conversation]
    func getHistoryConversations() -> [Conversation]
    func goOffline()
    func appendMessage(_ message: Message, to conversationId: String)
    func createConversation(_ newConversation: Conversation)
    func setOnlineStatus(_ value: Bool, to conversationId: String)
    func setAllMessagesAsRead(in conversationId: String)
    var conversationsDelegate: ConversationsDataServiceDelegate? { get set }
}
