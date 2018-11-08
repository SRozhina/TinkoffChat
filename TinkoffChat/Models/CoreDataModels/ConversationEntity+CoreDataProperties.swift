//
//  ConversationEntity+CoreDataProperties.swift
//  
//
//  Created by Sofia on 08/11/2018.
//
//

import Foundation
import CoreData


extension ConversationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConversationEntity> {
        return NSFetchRequest<ConversationEntity>(entityName: "ConversationEntity")
    }

    @NSManaged public var isOnline: Bool
    @NSManaged public var user: UserInfoEntity?
    @NSManaged public var messages: MessageEntity?

}
