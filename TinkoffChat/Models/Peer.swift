//
//  Peer.swift
//  TinkoffChat
//
//  Created by Sofia on 27/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class Peer: Hashable, Equatable {
    var hashValue: Int {
        return name.hashValue ^ name.hashValue
    }
    
    static func == (lhs: Peer, rhs: Peer) -> Bool {
        return lhs.name == rhs.name
    }
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
}
