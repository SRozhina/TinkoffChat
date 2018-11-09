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
        return Message(id: id, text: text)
    }
}
