//
//  MessageDAO.swift
//  ZenThea
//
//  Created by felix on 28/01/2025.
//
import Foundation

class Message: Codable{
    
    private var cid : Int
    private var mid : Int
    private var label: String
    private var date : Date
    private var isReceived: Bool
    
    init(_ cid: Int,_ mid: Int,_ label: String,_ date: Date,_ isReceived: Bool) {
        self.cid = cid
        self.mid = mid
        self.label = label
        self.date = date
        self.isReceived = isReceived
    }
    
    /// utilise le quickSort pour trier la liste
    public static func sortByDate(_ convs : [Message])->[Message]{
        if convs.count < 2{
            return convs
        }
        let pivot = convs[Int((convs.count-1)/2)].getDate()
        var l:[Message]=[]
        var m:[Message]=[]
        var r:[Message]=[]
        var currentD : Date
        for obj in convs{
            currentD = obj.getDate()
            if currentD > pivot{
                r.append(obj)
            } else if currentD < pivot{
                l.append(obj)
            } else {
                m.append(obj)
            }
        }
        return Message.sortByDate(l)+m+Message.sortByDate(r)
    }
    
    //MARK: getters & setters

    public func getCid()->Int{return self.cid}
    public func getMid()->Int{return self.mid}
    public func getLabel()->String{return self.label}
    public func getDate()->Date{return self.date}
    public func getIsReceived()->Bool{return self.isReceived}
    
    public func setCid(_ cid: Int){self.cid = cid}
    public func setMid(_ mid: Int){self.mid = mid}
    public func setTitle(_ title: String){self.label = title}
    public func setDate(_ date: Date){self.date = date}
    public func setIsReceived(_ isReceived: Bool){self.isReceived=isReceived}
    
    
    
}
