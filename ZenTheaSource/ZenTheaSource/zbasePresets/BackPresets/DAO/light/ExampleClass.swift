//
//  Message.swift
//  ZenTheaSource
//
//  Created by felix on 03/02/2025.
//
import Foundation

/// exemple de classe permettant aux objets hérités d'avoir dirrectement les éléments nécessaires
/// pour avoir une pertistance des données minaimale (sans avoir de
/// choses lourdes comme CoreData)
class ExampleClass: Codable{
    
    /// doit être unique dans chaque classe DAO
    private static var storageName: String {
        "jsonPersistentObjectSorage.json"
    }
    
    /// sauvegarde les données en persistant
    public static func writeJSON(_ msgs2save: [ExampleClass]){
        let fileUrl : URL = ExampleClass.getURL()
        let urlFic = fileUrl.appendingPathComponent(
            ExampleClass.storageName
        )
        let data2Save = try? JSONEncoder().encode(msgs2save)
        FileManager.default.createFile(
            atPath: urlFic.path,
            contents: data2Save,
            attributes: nil
        )
    }
    
    /// récupère les données enregistrées en persistant
    public static func loadJSON() -> [ExampleClass]{
        var msgsDecoded : [ExampleClass] = []
        do {
            let data = try Data(
                contentsOf: ExampleClass.getURL()
            )
            msgsDecoded = try JSONDecoder().decode(
                [ExampleClass].self,
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

