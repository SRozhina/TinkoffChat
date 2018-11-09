//
//  MessageEntity+CoreDataProperties.swift
//  
//
//  Created by Sofia on 09/11/2018.
//
//

import Foundation
import CoreData

extension MessageEntity {

    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<MessageEntity> {
        return NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
    }

    @NSManaged
    public var date: NSDate?
    @NSManaged
    public var direction: Int32
    @NSManaged
    public var id: String?
    @NSManaged
    public var isUnread: Bool
    @NSManaged
    public var text: String?

}
