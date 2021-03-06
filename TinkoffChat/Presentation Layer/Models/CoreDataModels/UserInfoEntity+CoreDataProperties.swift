//
//  UserInfoEntity+CoreDataProperties.swift
//  
//
//  Created by Sofia on 23/11/2018.
//
//

import Foundation
import CoreData

extension UserInfoEntity {

    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<UserInfoEntity> {
        return NSFetchRequest<UserInfoEntity>(entityName: "UserInfoEntity")
    }

    @NSManaged
    public var avatar: URL?
    @NSManaged
    public var info: String?
    @NSManaged
    public var name: String?
    @NSManaged
    public var isProfile: Bool
    @NSManaged
    public var conversation: ConversationEntity?

}
