//
//  ConnexionJsonDoc.swift
//  ZenTheaSource
//
//  Created by felix on 04/02/2025.
//

/// singleton de "connexion" permettant de synchroniser les données entre
/// chaque vues (ici 1 seul objet qui est une liste de conversations)
class Mediator{
    
    private static var instance : Mediator? = nil
    
    private var conversations: [Conversation]?
    private var user: User?
    
    private init() {
        self.conversations = try? ConversationDAO.loadJSON()
        self.user = try? UserDAO.loadJSON()
    }
    
    public static func getMediator()->Mediator{
        if(instance == nil){
            Mediator.instance = Mediator()
        }
        return Mediator.instance!
    }
    
    public func save(){
        if self.conversations != nil {
            ConversationDAO.writeJSON(self.conversations!)
        }
        if self.user != nil {
            UserDAO.writeJSON(self.user!)
        }
    }
    
    //MARK: getters & setters
    
    public func getUser()->User?{
        return self.user
    }
    public func setUser(_ user: User){
        self.user=user
    }
    public func getConversations()->[Conversation]{
        return self.conversations ?? []
    }
    public func setConversations(_ convs: [Conversation]){
        self.conversations=convs
    }
    
    
    
    
    
}


