//
//  UserInfo.swift
//  TinkoffChat
//
//  Created by Sofia on 20/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

class UserInfo: Codable, Hashable, Equatable {
    var name: String
    var info: String = ""
    var avatar: UIImage?
    
    var hashValue: Int {
        return name.hashValue ^ name.hashValue
    }
    
    static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
        return lhs.name == rhs.name
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case info
        case avatar
    }
    
    init(name: String, info: String? = nil, avatar: UIImage? = nil) {
        self.name = name
        self.info = info ?? ""
        self.avatar = avatar
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.info = try container.decode(String.self, forKey: .info)
        guard let imageData = try? container.decode(Data.self, forKey: .avatar) else { return }
        self.avatar = UIImage(data: imageData)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(info, forKey: .info)
        let imageData = avatar != nil
            ? UIImageJPEGRepresentation(avatar!, 1)
            : nil
        try container.encode(imageData, forKey: .avatar)
    }
}
