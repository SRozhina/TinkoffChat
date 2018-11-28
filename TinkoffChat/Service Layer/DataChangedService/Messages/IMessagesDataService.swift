//
//  IMessagesDataService.swift
//  TinkoffChat
//
//  Created by Sofia on 13/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

protocol IMessagesDataService {
    func setupService(with conversationId: String)
    var messagesDelegate: MessagesDataServiceDelegate? { get set }
}
