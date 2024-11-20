//
//  UtilisateurMO+CoreDataProperties.swift
//  proj_ZenThéa
//
//  Created by Felix Ton that-Lavarini on 20/11/2024.
//
//

import Foundation
import CoreData


extension UtilisateurMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UtilisateurMO> {
        return NSFetchRequest<UtilisateurMO>(entityName: "Utilisateur")
    }

    @NSManaged public var nom: String?
    @NSManaged public var prenom: String?
    @NSManaged public var isAdmin: Bool

}

extension UtilisateurMO : Identifiable {
    // 9h-10h
}
/// extractions des données
extension UtilisateurMO {
    /// filtre les message en sortie pour avoir une liste ordonnées
    ///  selon les dates (plus tôt au plus tard)
    public static func descMessages(_ id: Int) -> [MessageMO]{
        return []
    }
}
