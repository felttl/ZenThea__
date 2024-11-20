//
//  ConversationMO+CoreDataProperties.swift
//  proj_ZenThéa
//
//  Created by Felix Ton that-Lavarini on 20/11/2024.
//
//

import Foundation
import CoreData


extension ConversationMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConversationMO> {
        return NSFetchRequest<ConversationMO>(entityName: "Conversation")
    }

    @NSManaged public var debut: Date?
    @NSManaged public var texte: String?
    @NSManaged public var possedePlusieursMSG: NSSet?

}

// MARK: Generated accessors for possedePlusieursMSG
extension ConversationMO {

    @objc(addPossedePlusieursMSGObject:)
    @NSManaged public func addToPossedePlusieursMSG(_ value: MessageMO)

    @objc(removePossedePlusieursMSGObject:)
    @NSManaged public func removeFromPossedePlusieursMSG(_ value: MessageMO)

    @objc(addPossedePlusieursMSG:)
    @NSManaged public func addToPossedePlusieursMSG(_ values: NSSet)

    @objc(removePossedePlusieursMSG:)
    @NSManaged public func removeFromPossedePlusieursMSG(_ values: NSSet)

}

extension ConversationMO : Identifiable {

}
