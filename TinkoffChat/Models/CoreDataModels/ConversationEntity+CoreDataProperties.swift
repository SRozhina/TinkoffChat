//
//  ConversationEntity+CoreDataProperties.swift
//  
//
//  Created by Sofia on 09/11/2018.
//
//

import Foundation
import CoreData

extension ConversationEntity {

    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<ConversationEntity> {
        return NSFetchRequest<ConversationEntity>(entityName: "ConversationEntity")
    }

    @NSManaged
    public var isOnline: Bool
    @NSManaged
    public var messages: NSSet
    @NSManaged
    public var user: UserInfoEntity

}

// MARK: Generated accessors for messages
extension ConversationEntity {

    @objc(addMessagesObject:)
    @NSManaged
    public func addToMessages(_ value: MessageEntity)

    @objc(removeMessagesObject:)
    @NSManaged
    public func removeFromMessages(_ value: MessageEntity)

    @objc(addMessages:)
    @NSManaged
    public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged
    public func removeFromMessages(_ values: NSSet)

}
