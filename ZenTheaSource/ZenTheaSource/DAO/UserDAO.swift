//
//  User.swift
//  ZenThea
//
//  Created by felix on 28/01/2025.
//

import Foundation

class UserDAO: Codable {
    
    private static var sexe: Sexe = Sexe.homme
    private static var connexion : Bool = false
    
    // MARK: données persistantes
    
    private static let storageName: String = "jsonUser.json"
    
    public static func writeJSON(_ msgs2save: [UserDAO]){
        let fileUrl : URL = UserDAO.getURL()
        let urlFic = fileUrl.appendingPathComponent(
            UserDAO.storageName
        )
        let data2Save = try? JSONEncoder().encode(msgs2save)
        FileManager.default.createFile(
            atPath: urlFic.path,
            contents: data2Save,
            attributes: nil
        )
    }
    
    /// récupère les données enregistrées en persistant
    public static func loadJSON() -> [UserDAO]{
        var msgsDecoded : [UserDAO] = []
        do {
            let data = try Data(
                contentsOf: UserDAO.getURL()
            )
            msgsDecoded = try JSONDecoder().decode(
                [UserDAO].self,
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
