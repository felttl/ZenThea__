//
//  User.swift
//  ZenThea
//
//  Created by felix on 28/01/2025.
//

import Foundation

class UserDAO: Codable {
    
    private static var storageName: String = "jsonUser.json"
    private static let storageNameS: String = UserDAO.storageName
    
    // obligatoire pour les tests unitaires
    public static func getStorageName()->String{
        return UserDAO.storageName
    }
    public static func setStorageName(_ storageName: String){
        UserDAO.storageName = storageName
    }
    public static func resetStorageName(){
        UserDAO.storageName=UserDAO.storageNameS
    }
    
    /// sauvegarde les données en local
    public static func writeJSON(_ user2save: User){
        let fileUrl : URL = UserDAO.getURL()
        let urlFic = fileUrl.appendingPathComponent(
            UserDAO.storageName
        )
        let data2Save = try? JSONEncoder().encode(user2save)
        FileManager.default.createFile(
            atPath: urlFic.path,
            contents: data2Save,
            attributes: nil
        )
    }
    
    /// récupère les données enregistrées en persistant
    public static func loadJSON() -> User{
        var msgsDecoded : User
        do {
            let data = try Data(
                contentsOf: UserDAO.getURL()
            )
            msgsDecoded = try JSONDecoder().decode(
                [User].self,
                from: data
            ).first!
        } catch {
            print("erreur : \(error)")
        }
        return msgsDecoded
    }
    
    private static func getURL()->URL{
        return FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
    }
    
    
}
