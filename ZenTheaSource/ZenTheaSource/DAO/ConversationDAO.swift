//
//  ConversationDAO.swift
//  ZenThea
//
//  Created by felix on 28/01/2025.
//

import Foundation


class ConversationDAO : Codable{
        
    /// doit être unique dans chaque classe DAO
    private static var storageName: String = "convDAO.json"
    private static let storageNameS: String = ConversationDAO.storageName
    
    // obligatoire pour les tests unitaires
    public static func getStorageName()->String{
        return ConversationDAO.storageName
    }
    public static func setStorageName(_ storageName: String){
        ConversationDAO.storageName = storageName
    }
    public static func resetStorageName(){
        ConversationDAO.storageName=ConversationDAO.storageNameS
    }
    
    private static func getURL()->URL{
        return FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
    }
    
    private static func getFinalPath()->String{
        let url = ConversationDAO.getURL()
        return url.appendingPathComponent(
            ConversationDAO.storageName
        ).path
    }
    
    public static func writeJSON(_ liste: [Conversation]) {
        let jsonUrl = ConversationDAO.getFinalPath()
        let data2save = try? JSONEncoder().encode(
            liste
        )
        FileManager.default.createFile(
            atPath: jsonUrl,
            contents: data2save,
            attributes: nil
        )
    }
    
    /// cherche les données dans les sauvegardes précédentes
    public static func loadJSON() throws -> [Conversation]{
        var res : [Conversation] = []
        // singleton liste des liens
        let fManager = FileManager.default
        // accés a la partie document du conteneur sécurisé
        let urls = fManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        // ajout de notre chemin a la première url du "document"
        let urlDuJson = urls.first!.appendingPathComponent(
            ConversationDAO.storageName
        )
        if FileManager.default.fileExists(atPath: urlDuJson.path){
            res = ConversationDAO.loadJSON(urlDuJson)
        }
        return res
    }
    /// (2e etape) obligatoire car peut renvoyer un élément vide ou une erreur
    private static func loadJSON(_ url: URL)->[Conversation]{
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let tousLesSites = try decoder.decode(
                [Conversation].self,
                from: data
            )
            return tousLesSites
        } catch {
            print("error: \(error)")
        }
        return []
    }
    
}
