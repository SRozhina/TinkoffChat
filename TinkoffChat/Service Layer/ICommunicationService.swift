//
//  ICommunicationService.swift
//  TinkoffChat
//
//  Created by Sofia on 27/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol ICommunicationService {
    var delegate: ICommunicationServiceDelegate? { get set }
    var online: Bool { get set }
    func send(_ message: Message, to user: UserInfo)
}
