//
//  IConversationsListService.swift
//  TinkoffChat
//
//  Created by Sofia on 12/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol IConversationsListService {
    func getOnlineConversations() -> [Conversation]
    func getHistoryConversations() -> [Conversation]
    func setupService()
    var delegate: ConversationsListServiceDelegate? { get set }
}
