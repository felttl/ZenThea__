//
//  ConnexionJsonDoc.swift
//  ZenTheaSource
//
//  Created by felix on 04/02/2025.
//
import Dispatch

/// singleton de "connexion" permettant de synchroniser les données entre
/// chaque vues (ici 1 seul objet qui est une liste de conversations)
class Mediator{
    
    private static var instance : Mediator? = nil
    
    private var staticInfos : InformationsDAO?
    private var conversations: [Conversation]?
    private var user: User?
    
    private init() {
        self.conversations = try? ConversationDAO.loadJSON()
        self.user = try? UserDAO.loadJSON() ?? User(Sexe.homme)
        self.staticInfos = InformationsDAO.loadInfos()
    }
    
    public static func getMediator()->Mediator{
        if(instance == nil){
            Mediator.instance = Mediator()
        }
        return Mediator.instance!
    }
    // fonction appelé pour la savegarde en tache de fond
    public func save(){ // thread séparé
        // sauvearde asynchrone
        DispatchQueue.global(qos: .background).async {
            if self.conversations != nil {
                ConversationDAO.writeJSON(self.conversations!)
            }
            if self.user != nil {
                UserDAO.writeJSON(self.user!)
            }
            self.staticInfos!.setConvAutoIncrement(
                Conversation.getCid()
            )
        }
    }
    
    //MARK: getters & setters
    
    public func getUser()->User{
        return self.user!
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


