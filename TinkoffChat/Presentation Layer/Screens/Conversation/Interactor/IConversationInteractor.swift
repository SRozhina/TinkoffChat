//
//  IConversationInteractor.swift
//  TinkoffChat
//
//  Created by Sofia on 15/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol IConversationInteractor: class {
    func setup()
    func sendMessage(_ message: Message, to conversation: Conversation)
    var delegate: ConversationInteractorDelegate? { get set }
}
