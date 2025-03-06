//
//  User.swift
//  ZenTheaSource
//
//  Created by felix on 04/02/2025.
//
import Foundation

/// classe représentant l'unique utilisateur de l'app
class User: Codable{
        
    private var sexe : Sexe

    public init(_ sexe: Sexe) {
        self.sexe = sexe
    }
    
    //MARK: getters & setters
    
    public func getSexe()->Sexe{return self.sexe}
    
    public func setSexe(_ sexe: Sexe){self.sexe = sexe}
    
    
    
    
}
