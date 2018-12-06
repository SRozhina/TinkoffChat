//
//  IOnlineConversationsDataService.swift
//  TinkoffChat
//
//  Created by Sofia on 01/12/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

protocol IOnlineConversationsDataService {
    func setupService()
    func getConversations() -> [Conversation]
    func createConversation(_ newConversation: Conversation)
    func setOnlineStatus(_ value: Bool, to conversationId: String)
    func appendMessage(_ message: Message, to conversationId: String)
    var conversationsDelegate: OnlineConversationsDataServiceDelegate? { get set }
}
