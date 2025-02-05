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

    private static func getURL()->URL{
        return FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
    }
    
    private static func getFinalPath()->String{
        let url = UserDAO.getURL()
        return url.appendingPathComponent(
            UserDAO.storageName
        ).path
    }
    
    /// cherche les données dans les sauvegardes précédentes
    public static func loadJSON()->User?{
        var res : User? = nil
        let jsonFilePath : String = UserDAO.getFinalPath()
        if FileManager.default.fileExists(atPath: jsonFilePath){
            res = UserDAO.loadJSON(UserDAO.getURL())
        }
        return res
    }
    
    /// (2e etape) obligatoire car peut renvoyer un élément vide ou une erreur
    private static func loadJSON(_ url: URL)->User?{
        var res : User? = nil
        do {
            let data = try Data(contentsOf: url)
            //conversations = ... (bellow)
            res = try JSONDecoder().decode(
                User.self,
                from: data
            )
            //return conversations
        } catch {
            print("error from UserDAO.loadJSON: \(error)")
        }
        return res
    }
    
    
    public static func writeJSON(_ user : User) {
        let jsonUrl = UserDAO.getFinalPath()
        let data2save = try? JSONEncoder().encode(user)
        FileManager.default.createFile(
            atPath: jsonUrl,
            contents: data2save,
            attributes: nil
        )
    }

    
}
