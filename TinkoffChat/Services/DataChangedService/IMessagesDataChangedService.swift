//
//  IMessagesDataChangedService.swift
//  TinkoffChat
//
//  Created by Sofia on 13/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

protocol IMessagesDataChangedService {
    func setupService(with conversationId: String)
    var messagesDelegate: MessagesDataChangedServiceDelegate? { get set }
}
