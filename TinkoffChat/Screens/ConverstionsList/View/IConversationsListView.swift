//
//  IConversationsListView.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

protocol IConversationsListView {
    func setOnlineConversations(_ conversations: [ConversationPreview])
    func setHistoryConversations(_ conversations: [ConversationPreview])
}
