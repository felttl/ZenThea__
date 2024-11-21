//
//  ConversationMO+CoreDataProperties.swift
//  ZenThea
//
//  Created by Felix Ton that-Lavarini on 21/11/2024.
//
//

import Foundation
import CoreData
import UIKit


extension ConversationMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConversationMO> {
        return NSFetchRequest<ConversationMO>(entityName: "Conversation")
    }

    @NSManaged public var title: String?
    @NSManaged public var subTitle: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var id: Int32
    @NSManaged public var start: Date?
    @NSManaged public var messageFromConversation: NSSet?

}

// MARK: Generated accessors for messageFromConversation
extension ConversationMO {

    @objc(addMessageFromConversationObject:)
    @NSManaged public func addToMessageFromConversation(_ value: MessageMO)

    @objc(removeMessageFromConversationObject:)
    @NSManaged public func removeFromMessageFromConversation(_ value: MessageMO)

    @objc(addMessageFromConversation:)
    @NSManaged public func addToMessageFromConversation(_ values: NSSet)

    @objc(removeMessageFromConversation:)
    @NSManaged public func removeFromMessageFromConversation(_ values: NSSet)

}

extension ConversationMO : Identifiable {

}
extension ConversationMO {
    public static func getConversations(Int32_ id: Int32)->[ConversationMO]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let ctx = appDelegate.persistentContainer.viewContext
        let rsql : NSFetchRequest<ConversationMO> = ConversationMO.fetchRequest()
        // on filtre la conversation de sortie par son id (choix utilisateur)
        rsql.predicate = NSPredicate(
            format: "id == %@",
            id
        )
        guard let dataCMO = try? (
            ctx.fetch(rsql)
        ) else {
            return []
        }
        return dataCMO
        
    }
}
