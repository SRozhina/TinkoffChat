//
//  MessagesStorage.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

class MessagesInMemoryStorage: IMessagesStorage {
    func getMessages() -> [Message] {
        return [
            Message(text: "1",
                    direction: .incoming),
            Message(text: "1",
                    direction: .outgoing),
            Message(text: "text with 30 characters text w",
                    direction: .incoming),
            Message(text: "text with 30 characters text w",
                    direction: .outgoing),
            Message(text: """
                            text with 300 characters text with 300 characters text with 300 characters text with 300
                            characters text with 300 characters text with 300 characters text with 300 characters text with 300
                            characters text with 300 characters text with 300 characters text with 300 characters text with 300 characters
                    """,
                    direction: .incoming),
            Message(text: """
                            text with 300 characters text with 300 characters text with 300 characters text with 300
                            characters text with 300 characters text with 300 characters text with 300 characters text with 300
                            characters text with 300 characters text with 300 characters text with 300 characters text with 300 characters
                    """,
                    direction: .outgoing)
        ]
    }
}
