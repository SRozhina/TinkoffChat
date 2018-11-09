//
//  Message.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol messageCellConfiguration {
    var text: String { get set }
}

class Message: messageCellConfiguration, Codable, Hashable {
    enum Direction: Int {
        case incoming = 0
        case outgoing = 1
    }
    
    var text: String
    let direction: Direction
    let id: String
    let date: Date
    var isUnread: Bool = true
    
    init(id: String = IDBuilder.generateID(), text: String) {
        self.id = id
        self.text = text
        self.date = Date()
        self.direction = .outgoing
    }
    
    var hashValue: Int {
        return id.hashValue ^ isUnread.hashValue ^ text.hashValue ^ date.hashValue
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    private enum CodingKeys: CodingKey {
        case id, date, direction, text, isUnread
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? values.decode(String.self, forKey: .id)) ?? ""
        date = (try? values.decode(Date.self, forKey: .date)) ?? Date()
        direction = .incoming
        text = (try? values.decode(String.self, forKey: .text)) ?? ""
        isUnread = true
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(id, forKey: .id)
        try? container.encode(date, forKey: .date)
        try? container.encode(text, forKey: .text)
        try? container.encode(isUnread, forKey: .isUnread)
    }
}
