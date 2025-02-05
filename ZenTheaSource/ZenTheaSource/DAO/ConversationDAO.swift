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
    
    /// cherche les données dans les sauvegardes précédentes
    public static func loadJSON()->[Conversation]{
        var res : [Conversation] = []
        let jsonFilePath : String = ConversationDAO.getFinalPath()
        if FileManager.default.fileExists(atPath: jsonFilePath){
            res = ConversationDAO.loadJSON(ConversationDAO.getURL())
        }
        return res
    }
    /// (2e etape) obligatoire car peut renvoyer un élément vide ou une erreur
    private static func loadJSON(_ url: URL)->[Conversation]{
        do {
            let data = try Data(contentsOf: url)
            var conversations = try JSONDecoder().decode(
                [Conversation].self,
                from: data
            )
            return conversations
        } catch {
            print("error from ConversationDAO.loadJSON: \(error)")
        }
        return []
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
    

    
    
}
