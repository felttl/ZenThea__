//
//  MessageMO+CoreDataProperties.swift
//  ZenThea
//
//  Created by Felix Ton that-Lavarini on 21/11/2024.
//
//

import Foundation
import CoreData
import UIKit


extension MessageMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageMO> {
        return NSFetchRequest<MessageMO>(entityName: "Message")
    }

    @NSManaged public var date: Date?
    @NSManaged public var author: String?
    @NSManaged public var content: String?
    @NSManaged public var conversationOfMessages: ConversationMO?

}

extension MessageMO : Identifiable {

}
extension MessageMO{
    
    // schéma simple : [Discussions]->[n]=Conversation, Conv'[n]=message
    // id lié a une conversation (tout ce qui est dans la meme conv a le meme id)
    
    /// récupère tous les objets de la base de données SQLite
    /// filtré par : nom ou surnon ou contenu de message ou le text est trouvé
    public static func getMessages() -> [MessageMO]{
        let appDegate = UIApplication.shared.delegate as! AppDelegate
        let ctx = appDegate.persistentContainer.viewContext
        let rsql : NSFetchRequest<MessageMO> = MessageMO.fetchRequest()
        // limiter la recherche et rajouter un bouton pour étendre
        rsql.fetchLimit = 50
        guard let dataMMO = try? (
            ctx.fetch(rsql)
        ) else {
            return []
        }
        return dataMMO
        
    }
}
