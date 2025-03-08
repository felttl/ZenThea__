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
    // fonction appelé pour la sauvegarde en tache de fond
    public func save(){ // thread séparé
        // sauvegarde asynchrone
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
    
    public func addConversation(_ conv: Conversation){
        self.conversations?.append(conv)
        self.save()
    }
    
    public func removeConv(at idx: Int){
        self.conversations?.remove(at: idx)
        self.save()
    }

    
    //MARK: getters & setters
    
    public func getUser()->User{
        return self.user!
    }
    public func getConversations()->[Conversation]{
        return self.conversations ?? []
    }
    public func getConversation(_ index: Int)->Conversation?{
        return self.conversations?[index]
    }
    
    public func setUser(_ user: User){
        self.user=user
        self.save()
    }
    public func setConversation(_ index: Int, _ conv: Conversation){
        self.conversations?[index]=conv
        self.save()
    }
    public func setConversations(_ convs: [Conversation]){
        self.conversations=convs
        self.save()
    }
    
    
    
    
    
}


