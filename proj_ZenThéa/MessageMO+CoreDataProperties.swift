//
//  MessageMO+CoreDataProperties.swift
//  proj_ZenThéa
//
//  Created by Felix Ton that-Lavarini on 20/11/2024.
//
//

import Foundation
import CoreData


extension MessageMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageMO> {
        return NSFetchRequest<MessageMO>(entityName: "Message")
    }

    @NSManaged public var titre: String?
    @NSManaged public var autheur: String?
    @NSManaged public var date: Date?
    @NSManaged public var msgPossedeUne: ConversationMO?

}

extension MessageMO : Identifiable {

}
