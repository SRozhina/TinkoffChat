//
//  IMessageConverter.swift
//  TinkoffChat
//
//  Created by Sofia on 09/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol IMessageConverter {
    func makeMessage(from messageEntity: MessageEntity?) -> Message
}

class MessageConverter: IMessageConverter {
    func makeMessage(from messageEntity: MessageEntity?) -> Message {
        let id = messageEntity?.id ?? ""
        let text = messageEntity?.text ?? ""
        let rawDirection = messageEntity?.direction ?? 0
        let direction = Message.Direction(rawValue: Int(rawDirection))
        let date = messageEntity?.date as Date?
        let isUnread = messageEntity?.isUnread
        return Message(id: id, text: text, date: date, direction: direction, isUnread: isUnread)
    }
}
