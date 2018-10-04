//
//  Message.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//
protocol messageCellConfiguration {
    var text: String? { get set }
}

class Message: messageCellConfiguration {
    enum Direction {
        case incoming
        case outgoing
    }
    
    var text: String?
    let direction: Direction?
    
    init(text: String? = nil, direction: Direction? = nil) {
        self.text = text
        self.direction = direction
    }
}
