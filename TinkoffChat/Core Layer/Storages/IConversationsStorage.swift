//
//  IConversationsStorage.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

protocol IConversationsStorage {
    func goOffline()
    func createConversation(_ newConversation: Conversation)
    func setOnlineStatus(_ value: Bool, to conversationId: String)
}
