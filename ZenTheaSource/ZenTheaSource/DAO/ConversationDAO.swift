//
//  ConversationDAO.swift
//  ZenThea
//
//  Created by felix on 28/01/2025.
//

import Foundation


class ConversationDAO : Codable{
    
    private var cid : Int
    private var title: String
    private var date : Date
    
    private var msgDAOs: [MessageDAO] = []
    
    init(_ cit: Int,_ title: String,_ date: Date) {
        self.cid = cit
        self.title = title
        self.date = date
    }
    
    public func addMessage(_ msgDAOs: MessageDAO){
        self.msgDAOs.append(msgDAOs)
    }
    public func removeMessage(_ mid: Int)->Bool{
        var carry: Bool = false
        

        return carry
    }
    
    //MARK: getters & setters

    public func getCit()->Int{return self.cid}
    public func getTitle()->String{return self.title}
    public func getDate()->Date{return self.date}
    public func getMsgDAOs()->[MessageDAO]{return self.msgDAOs}
    
    public func setCit(_ cit: Int){self.cid = cit}
    public func setTitle(_ title: String){self.title = title}
    public func setDate(_ date: Date){self.date = date}
    public func setMessageDAOs(_ msgDAOs: [MessageDAO]){self.msgDAOs=msgDAOs}
    
    
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
    
    public static func getConversation(_ convDAOs: [ConversationDAO],_ cid: Int)->ConversationDAO?{
        var res : ConversationDAO? = nil
        if convDAOs.count > 1{
            // recherche dichotomique itérative
            var carry : Bool = true
            var i : Int = Int(convDAOs.count/2)
            var mid : Int = i
            while carry{
                if convDAOs[i].cid > cid{
                    mid /= 2
                    i += mid
                } else if convDAOs[i].cid < cid{
                    mid /= 2
                    i -= mid
                } else if mid < 2 {
                    carry = false
                } else {
                    carry = false
                    res = convDAOs[i]
                }
            }
        }
        return res
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
