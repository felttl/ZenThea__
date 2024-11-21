//
//  UserMO+CoreDataProperties.swift
//  ZenThea
//
//  Created by Felix Ton that-Lavarini on 21/11/2024.
//
//

import Foundation
import CoreData
import UIKit


extension UserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var isAdmin: Bool

}

extension UserMO : Identifiable {

}
extension UserMO {
    public static func getUsers() -> [UserMO]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let ctx = appDelegate.persistentContainer.viewContext
        let rsql : NSFetchRequest<UserMO> = UserMO.fetchRequest()
        guard let dataUMO = try? (
            ctx.fetch(rsql)
        ) else {
            return []
        }
        return dataUMO
    }
}
