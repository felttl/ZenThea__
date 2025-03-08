//
//  Conversation.swift
//  ZenThea
//
//  Created by felix on 28/01/2025.
//

import Foundation

class Conversation: Codable {
    
    private static var cid : Int = 0
    
    private var cid : Int
    private var title: String
    private var date : Date
    // gérer les id des messages
    private var mid: Int = 0
    
    private var msgs: [Message] = []
        
    init(_ title: String,_ date: Date) {
        self.cid = Conversation.cid
        Conversation.cid += 1
        self.title = title
        self.date = date
    }
    
    public func addMessageDAO(_ msg: Message){
        self.msgs.append(msg)
        self.mid += 1
    }
    /// supprime un message et renvoie s'il a été trouvé avec son identifian
    public func removeMessageMid(_ mid: Int)->Bool{
        var found: Bool = false
        if let id = Conversation.getMessageIdx(self.msgs,mid){
            self.msgs.remove(at: id)
            found = true
        }
        return found
    }
    
    /// supprime un élément avec un index
    public func removeMessageIdx(_ idx: Int){
        self.msgs.remove(at: idx)
    }
    
    // MARK: getters & setters

    public func getCid()->Int{return self.cid}
    public func getMid()->Int{return self.mid}
    public func getTitle()->String{return self.title}
    public func getDate()->Date{return self.date}
    public func getMsgs()->[Message]{return self.msgs}
    
    public static func getCid()->Int{return Conversation.cid}
    
    public func setCid(_ cid: Int){self.cid = cid}
    public func setTitle(_ title: String){self.title = title}
    public func setDate(_ date: Date){self.date = date}
    public func setMsgs(_ msgs: [Message]){self.msgs=msgs}
    
    public static func setCid(_ cid : Int){Conversation.cid=cid}
    
    
    
    /// renvoie un index en cherchant une cid de conversation
    /// dans une liste de conversations
    /// avec recherche dichotomique non réccursive
    public static func getConversationIdx(_ convDAOs: [Conversation], _ cid: Int) -> Int? {
        var res : Int? = nil
        if !convDAOs.isEmpty{
            var i = 0
            var carry : Bool = true
            while i < convDAOs.count && carry{
                if(convDAOs[i].getCid() == cid){
                    res = i
                    carry = false
                }
                i+=1
            }
        }
        return res
    }    /// renvoie un index en cherchant une mid de message
    /// dans une liste de conversations
    /// avec recherche dichotomique non réccursive
    public static func getMessageIdx(_ msgs: [Message], _ mid: Int) -> Int? {
        var res : Int? = nil
        if !msgs.isEmpty{
            var left = 0
            var right = msgs.count - 1
            var carry : Bool = true
            while left <= right && carry{
                let mid = left + (right - left) / 2
                if msgs[mid].getMid() == mid {
                    res = mid
                    carry = false
                } else if msgs[mid].getMid() < mid {
                    left = mid + 1
                } else {
                    right = mid - 1
                }
            }
        }
        return res
    }
    
    /// utilise le quickSort pour trier la liste
    public static func quickSort(_ convs : inout [Conversation])->[Conversation]{
        if convs.count < 2{
            return convs
        }
        let pivot = convs[Int(convs.count)].getCid()
        var l:[Conversation]=[]
        var m:[Conversation]=[]
        var r:[Conversation]=[]
        for obj in convs{
            if obj.getCid() < pivot{
                l.append(obj)
            } else if obj.getCid() > pivot{
                r.append(obj)
            } else {
                m.append(obj)
            }
        }
        return Conversation.quickSort(&l)+m+Conversation.quickSort(&r)
    }
    
    


}
