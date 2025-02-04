//
//  ConnexionJsonDoc.swift
//  ZenTheaSource
//
//  Created by felix on 04/02/2025.
//

/// singleton de "connexion" permettant de synchroniser les données entre
/// chaque vues (ici 1 seul objet qui est une liste de conversations)
class ConnexionJsonDoc{
    
    private static var instance : ConnexionJsonDoc? = nil
    
    private var conversationDAOs: [ConversationDAO]!
    private var userDAO: UserDAO?
    
    private init() {
        self.conversationDAOs = ConversationDAO.loadJSON()
        self.userDAO = UserDAO.loadJSON()
    }
    
    public static func getConnexion()->ConnexionJsonDoc{
        if(instance == nil){
            ConnexionJsonDoc.instance = ConnexionJsonDoc()
        }
        return ConnexionJsonDoc.instance!
    }
    
    public static func save(){
        if(instance != nil){
            ConversationDAO.writeJSON(
                ConnexionJsonDoc.instance!.conversationDAOs
            )
            if let userDao = ConnexionJsonDoc.instance!.userDAO{
                UserDAO.writeJSON(userDao)
            }
        }
    }
    
    //MARK: getters & setters
    
    public func getUserDAO()->UserDAO?{
        return self.userDAO
    }
    public func setUserDAO(_ userDAO: UserDAO){
        self.userDAO=userDAO
    }
    public func getConversationDAOs()->[ConversationDAO]{
        return self.conversationDAOs
    }
    public func setConversationDAOs(_ convDAO: [ConversationDAO]){
        self.conversationDAOs=convDAO
    }
    
    
    
    
    
}
