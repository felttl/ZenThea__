//
//  DAOInformations.swift
//  ZenTheaSource
//
//  Created by felix on 06/02/2025.
//

import Foundation

/// sauvegarde les données statiques/(de classe) des classes DAO
class DAOInformations: Codable{
    
    private static var storageName : String = "daoInfos.json"
    private static let storageNameS : String = DAOInformations.storageName
    
    private static var instance : DAOInformations? = nil
    
    private var convAutoIncrement: Int?
    
    private init() {
        let objself : DAOInformations?
        objself = try? DAOInformations.loadJSON()
        self.convAutoIncrement = objself?.getConvAutoIncrement() ?? 0
    }
    
    public static func getDAOInformations()->DAOInformations{
        if DAOInformations.instance == nil {
            DAOInformations.instance = DAOInformations()
        }
        return DAOInformations.instance!
    }
    
    private static func getURL()->URL{
        return FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
    }
    
    private static func getFinalPath()->String{
        let url = DAOInformations.getURL()
        return url.appendingPathComponent(
            DAOInformations.storageName
        ).path
    }
    
    private static func writeJSON(_ infos: DAOInformations) {
        let jsonUrl = DAOInformations.getFinalPath()
        let data2save = try? JSONEncoder().encode(infos)
        FileManager.default.createFile(
            atPath: jsonUrl,
            contents: data2save,
            attributes: nil
        )
    }
    
    /// cherche les données dans les sauvegardes précédentes
    private static func loadJSON() throws -> DAOInformations?{
        var res : DAOInformations?
        // singleton liste des liens
        let fManager = FileManager.default
        // accés a la partie document du conteneur sécurisé
        let urls = fManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        // ajout de notre chemin a la première url du "document"
        let urlDuJson = urls.first!.appendingPathComponent(
            DAOInformations.storageName
        )
        if FileManager.default.fileExists(atPath: urlDuJson.path){
            res = DAOInformations.loadJSON(urlDuJson)
        }
        return res
    }
    /// (2e etape) obligatoire car peut renvoyer un élément vide ou une erreur
    private static func loadJSON(_ url: URL)->DAOInformations?{
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let tousLesSites = try decoder.decode(
                DAOInformations.self,
                from: data
            )
            return tousLesSites
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    //MARK: getters & setters
    
    public func getConvAutoIncrement()->Int?{
        return self.convAutoIncrement
    }
    
    // //////////
    
    public func setgetConvAutoIncrement(_ convAutoIcr: Int){
        self.convAutoIncrement = convAutoIcr
    }
    
    
}
