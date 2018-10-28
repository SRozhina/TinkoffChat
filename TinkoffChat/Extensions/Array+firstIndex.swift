//
//  Array+firstIndex.swift
//  TinkoffChat
//
//  Created by Sofia on 28/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

extension Array {
    func firstIndex(where predicate: (Element) throws -> Bool) rethrows -> Int? {
        for index in 0..<self.count {
            if try predicate(self[index]) {
                return index
            }
        }
        return nil
    }
}
