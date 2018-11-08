//
//  MessageEntity+CoreDataProperties.swift
//  
//
//  Created by Sofia on 08/11/2018.
//
//

import Foundation
import CoreData


extension MessageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageEntity> {
        return NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var direction: Int16
    @NSManaged public var isUnread: Bool
    @NSManaged public var conversation: ConversationEntity?

}
