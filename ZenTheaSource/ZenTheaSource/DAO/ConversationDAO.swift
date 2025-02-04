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

    
    //MARK: persistance des données
    
    /// sauvegarde les données en persistant
    public static func writeJSON(_ msgs2save: [Conversation]){
        let fileUrl : URL = ConversationDAO.getURL()
        let urlFic = fileUrl.appendingPathComponent(
            ConversationDAO.storageName
        )
        let data2Save = try? JSONEncoder().encode(msgs2save)
        FileManager.default.createFile(
            atPath: urlFic.path,
            contents: data2Save,
            attributes: nil
        )
    }
    
    /// récupère les données enregistrées en persistant
    public static func loadJSON() -> [Conversation]{
        var msgsDecoded : [Conversation] = []
        do {
            let data = try Data(
                contentsOf: ConversationDAO.getURL()
            )
            msgsDecoded = try JSONDecoder().decode(
                [Conversation].self,
                from: data
            )
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
