//
//  IConversationsListPresenter.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

protocol IConversationsListPresenter: class {
    func setup() 
    func selectConversation(_ conversation: ConversationPreview)
}
