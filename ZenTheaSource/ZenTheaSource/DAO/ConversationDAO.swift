//
//  ConversationDAO.swift
//  ZenThea
//
//  Created by felix on 28/01/2025.
//

import Foundation


class ConversationDAO : Codable{
    
    private var cid : Int32
    private var title: String
    private var date : Date
    
    private var msgDAO: [MessageDAO] = []
    
    init(cit: Int32, title: String, date: Date) {
        self.cid = cit
        self.title = title
        self.date = date
    }
    
    public func addMessage(_ msgDAO: MessageDAO){
        self.msgDAO.append(msgDAO)
    }
    public func removeMessage(_ mid: Int32)->Bool{
        var carry : Bool = false
        if(self.msgDAO[mid].remove(at: mid)){
            
        }
        return carry
    }
    
    //MARK: getters & setters

    public func getCit()->Int32{return self.cid}
    public func getTitle()->String{return self.title}
    public func getDate()->Date{return self.date}
    
    public func setCit(_ cit: Int32){self.cid = cit}
    public func setTitle(_ title: String){self.title = title}
    public func setDate(_ date: Date){self.date = date}
    
    
    // MARK: partie persistance des données
    
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
    
    /// sauvegarde les données en persistant
    public static func writeJSON(_ msgs2save: [ConversationDAO]){
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
    public static func loadJSON() -> [ConversationDAO]{
        var msgsDecoded : [ConversationDAO] = []
        do {
            let data = try Data(
                contentsOf: ConversationDAO.getURL()
            )
            msgsDecoded = try JSONDecoder().decode(
                [ConversationDAO].self,
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
