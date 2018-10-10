//
//  IConversationsStorage.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

protocol IConversationsStorage {
    func getOnlineConversations() -> [ConversationPreview]
    func getHistoryConversations() -> [ConversationPreview]
}
