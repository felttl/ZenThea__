//
//  MessageDAO.swift
//  ZenThea
//
//  Created by felix on 28/01/2025.
//
import Foundation

class MessageDAO: Codable{
    
    private var cid : Int32
    private var mid : Int32
    private var label: String
    private var date : Date
    
    init(cid: Int32, mid: Int32, title: String, date: Date) {
        self.cid = cid
        self.mid = mid
        self.label = title
        self.date = date
    }
    
    //MARK: getters & setters

    public func getCid()->Int32{return self.cid}
    public func getMid()->Int32{return self.mid}
    public func getTitle()->String{return self.label}
    public func getDate()->Date{return self.date}
    
    public func setCid(_ cid: Int32){self.cid = cid}
    public func setMid(_ mid: Int32){self.mid = mid}
    public func setTitle(_ title: String){self.label = title}
    public func setDate(_ date: Date){self.date = date}
    
    // MARK: partie persistance des données
    
    /// doit être unique dans chaque classe DAO
    private static var storageName: String = "msgsDAO.json"
    
    /// sauvegarde les données en persistant
    public static func writeJSON(_ msgs2save: [MessageDAO]){
        let fileUrl : URL = MessageDAO.getURL()
        let urlFic = fileUrl.appendingPathComponent(
            MessageDAO.storageName
        )
        let data2Save = try? JSONEncoder().encode(msgs2save)
        FileManager.default.createFile(
            atPath: urlFic.path,
            contents: data2Save,
            attributes: nil
        )
    }
    
    /// récupère les données enregistrées en persistant
    public static func loadJSON() -> [MessageDAO]{
        var msgsDecoded : [MessageDAO] = []
        do {
            let data = try Data(
                contentsOf: MessageDAO.getURL()
            )
            msgsDecoded = try JSONDecoder().decode(
                [MessageDAO].self,
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
