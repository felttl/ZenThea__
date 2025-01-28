//
//  Conversation.swift
//  ZenThea
//
//  Created by felix on 28/01/2025.
//

import Foundation

class Conversation {
    
    private var title: String
    private var subTitle: String
    private var creationDate: Date
    private var id: Int32
    
    init(_ titre: String,_ sousTitre: String, _ id: Int32,_ dateCree : Date?=Date()) {
        self.title = titre
        self.subTitle = sousTitre
        self.id = id
        self.creationDate = dateCree!
    }
    
    // MARK: getters & setters

    public func getTitle()->String{return self.title}    
    public func getSubTitle()->String{return self.subTitle}    
    public func getCreationDate()->Date{return self.creationDate}    
    public func getId()->Int32{return self.id}

    public func setTitle(_ title: String){self.title = title}
    public func setSubTitle(_ subTitle: String){self.subTitle = subTitle}
    public func setCreationDate(_ creationDate : Date){self.creationDate = creationDate}
    public func setId(_ id : Int32){self.id = id}


}
