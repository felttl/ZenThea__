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
    
    public static func writeJSON(_ user : User) {
        let jsonUrl = UserDAO.getFinalPath()
        let data2save = try? JSONEncoder().encode(user)
        FileManager.default.createFile(
            atPath: jsonUrl,
            contents: data2save,
            attributes: nil
        )
    }
    /// cherche les données dans les sauvegardes précédentes
    public static func loadJSON() throws -> User?{
        var res : User?
        let fManager = FileManager.default
        let urls = fManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        // ajout de notre chemin a la première url du "document"
        let urlDuJson = urls.first!.appendingPathComponent(
            UserDAO.storageName
        )
        if FileManager.default.fileExists(atPath: urlDuJson.path){
            res = UserDAO.loadJSON(urlDuJson)
        }
        return res
    }
    /// (2e etape) obligatoire car peut renvoyer un élément vide ou une erreur
    private static func loadJSON(_ url: URL)->User?{
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let user = try decoder.decode(
                User.self,
                from: data
            )
            return user
        } catch {
            print("error in UserDAO.LoadJSON(url:?) : \(error)")
        }
        return nil
    }
    
}
