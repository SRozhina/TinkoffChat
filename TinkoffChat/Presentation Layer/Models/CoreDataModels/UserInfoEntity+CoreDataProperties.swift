//
//  UserInfoEntity+CoreDataProperties.swift
//  
//
//  Created by Sofia on 14/11/2018.
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
    public var id: Int16
    @NSManaged
    public var conversation: ConversationEntity?

}
