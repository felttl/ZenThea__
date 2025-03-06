//
//  DAOInformations.swift
//  ZenTheaSource
//
//  Created by felix on 06/02/2025.
//

import Foundation

/// sauvegarde les données statiques/(de classe) des classes DAO
class InformationsDAO: Codable{
    
    private static var storageName : String = "daoInfos.json"
    private static let storageNameS : String = InformationsDAO.storageName
    
    private static var instance : InformationsDAO? = nil
    
    private var convAutoIncrement: Int?
    
    private init() {
        let objself : InformationsDAO?
        objself = try? InformationsDAO.loadJSON()
        InformationsDAO.instance = objself
        Conversation.setCid(
            objself?.getConvAutoIncrement() ?? 0
        )
    }
    
    /// charge toutes les données statiques dans les classes concernées
    /// 1 seule fois
    public static func loadInfos()->InformationsDAO{
        if InformationsDAO.instance == nil {
            InformationsDAO.instance = InformationsDAO()
        }
        return InformationsDAO.instance!
    }
    
    private static func getURL()->URL{
        return FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
    }
    
    private static func getFinalPath()->String{
        let url = InformationsDAO.getURL()
        return url.appendingPathComponent(
            InformationsDAO.storageName
        ).path
    }
    
    private static func writeJSON(_ infos: InformationsDAO) {
        let jsonUrl = InformationsDAO.getFinalPath()
        let data2save = try? JSONEncoder().encode(infos)
        FileManager.default.createFile(
            atPath: jsonUrl,
            contents: data2save,
            attributes: nil
        )
    }
    
    /// cherche les données dans les sauvegardes précédentes
    private static func loadJSON() throws -> InformationsDAO?{
        var res : InformationsDAO?
        // singleton liste des liens
        let fManager = FileManager.default
        // accés a la partie document du conteneur sécurisé
        let urls = fManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        // ajout de notre chemin a la première url du "document"
        let urlDuJson = urls.first!.appendingPathComponent(
            InformationsDAO.storageName
        )
        if FileManager.default.fileExists(atPath: urlDuJson.path){
            res = InformationsDAO.loadJSON(urlDuJson)
        }
        return res
    }
    /// (2e etape) obligatoire car peut renvoyer un élément vide ou une erreur
    private static func loadJSON(_ url: URL)->InformationsDAO?{
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let tousLesSites = try decoder.decode(
                InformationsDAO.self,
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
    
    public func setConvAutoIncrement(_ convAutoIcr: Int){
        self.convAutoIncrement = convAutoIcr
    }
    
    
}
