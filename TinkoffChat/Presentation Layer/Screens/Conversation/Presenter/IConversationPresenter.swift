//
//  IConversationPresenter.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

protocol IConversationPresenter {
    func setup()
    func sendMessage(_ message: String)
}
