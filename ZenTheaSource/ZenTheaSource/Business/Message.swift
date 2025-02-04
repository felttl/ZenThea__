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
