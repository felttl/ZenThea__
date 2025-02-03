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
    private var isReceiver: Bool
    
    init(_ cid: Int32,_ mid: Int32,_ label: String,_ date: Date,_ isReceiver: Bool) {
        self.cid = cid
        self.mid = mid
        self.label = label
        self.date = date
        self.isReceiver = isReceiver
    }
    
    //MARK: getters & setters

    public func getCid()->Int32{return self.cid}
    public func getMid()->Int32{return self.mid}
    public func getLabel()->String{return self.label}
    public func getDate()->Date{return self.date}
    
    public func setCid(_ cid: Int32){self.cid = cid}
    public func setMid(_ mid: Int32){self.mid = mid}
    public func setTitle(_ title: String){self.label = title}
    public func setDate(_ date: Date){self.date = date}
    
}
