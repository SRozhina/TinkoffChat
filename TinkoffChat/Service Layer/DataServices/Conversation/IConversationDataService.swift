//
//  IConversationsDataService.swift
//  TinkoffChat
//
//  Created by Sofia on 14/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol IConversationDataService {
    func setupService(with conversationId: String)
    var conversationDelegate: ConversationDataServiceDelegate? { get set }
}
