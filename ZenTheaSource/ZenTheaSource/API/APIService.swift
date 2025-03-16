//
//  APIService.swift
//  ZenTheaSource
//
//  Created by Léa Percheron on 07/02/2025.
//

import Foundation

// Structure pour stocker la réponse de l'API Mistral
struct APIResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }

    let choices: [Choice]

    //extrait la réponse principale du premier choix (ou affiche un message par défaut si vide)
    var reponseMistral: String {
        return choices.first?.message.content ?? "Aucune réponse reçue"
    }
}

class APIService {
    
    static let shared = APIService() //singleton pour éviter de réinstancier plusieurs fois cette classe
    
    private let baseURL = "https://api.mistral.ai/v1/chat/completions" // URL de l'API Mistral
    
    func envoyerMessage(userId: String, question: String, documents: [String], conversation: Conversation, sexe: Sexe, completion: @escaping (APIResponse?) -> Void) {
        guard let url = URL(string: baseURL) else {
            print("URL invalide")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // Récupérer la clé API de Secrets.plist
            if let mistralAPIKey = SecretsManager.shared.getAPIKey() {
                request.setValue("Bearer \(mistralAPIKey)", forHTTPHeaderField: "Authorization")
            } else {
                print("Erreur : clé API introuvable dans Secrets.plist") //ajout du jeton d'authentification
                completion(nil)
                return
        }

        //fusionne les documents en un seul texte pour donner du contexte à l'IA
        let context = documents.joined(separator: "\n\n")

        //récupère les 15 derniers messages
        let dernierMessages = conversation.getMsgs().suffix(15).map { msg in
            ["role": msg.getIsReceived() ? "assistant" : "user", "content": msg.getLabel()]
        }

        //différents de styles de réponses pour varier les réponses du LLm pour le rendre plus humain
        let variations = [
            "simple": "Réponds de manière naturelle et détendue, comme si tu discutais avec un ami. Sois bref, engageant et évite les explications trop longues.",
            "citation": "Réponds avec une citation inspirante et ajoute un commentaire personnel comme si tu discutais avec un ami.",
            "curiosité": "Donne une réponse courte et engageante, puis relance avec une question ouverte pour continuer la conversation.",
            "histoire": "Réponds de manière légère avec une petite anecdote, sans trop détailler, et demande à l'utilisateur ce qu'il en pense.",
            "méditatif": "Réponds avec un ton calme et bienveillant, comme un ami qui donne un conseil sincère."
        ]


        let variationKey = variations.keys.randomElement()!
        let selectedPrompt = variations[variationKey] ?? variations["simple"]!

        //la construction du corps de la requête JSON avec le contexte et l'historique
        var json: [String: Any] = [
            "model": "mistral-small-latest",
            "max_tokens": 200,
            "temperature": 0.8,
            "messages": [
                ["role": "system", "content": "Tu es un assistant bienveillant et empathique. \(selectedPrompt)"],
                ["role": "system", "content": "Voici des informations utiles extraites de documents :\n\n" + context],
                ["role": "system", "content": "L'utilisateur est \(sexe) et tu dois adapter tes accords grammaticaux en conséquence, adapte tes accords en fonction du sexe de l'utilisateur dans toutes tes réponses."]
            ] + dernierMessages + [
                ["role": "user", "content": question]
            ]
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            print("Erreur de sérialisation JSON")
            completion(nil)
            return
        }

        request.httpBody = jsonData

        print("Style de réponse sélectionné : \(variationKey)")
        print("Contenu du prompt : \(selectedPrompt)")
        print("Requête envoyée : \(String(data: jsonData, encoding: .utf8) ?? "Erreur JSON")")

        //exécution de la requête asynchrone vers l'API Mistral
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur réseau : \(error.localizedDescription)")
                completion(nil)
                return
            }

            //vérifie que des données ont bien été reçues
            guard let data = data else {
                print("Aucune donnée reçue")
                completion(nil)
                return
            }

            //affiche la réponse brute reçue pour le debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Réponse brute reçue : \(jsonString)")
            }

            do {
                let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                let reponseMistral = decodedResponse.reponseMistral
                print("Réponse Mistral : \(reponseMistral)")
                completion(decodedResponse)
            } catch {
                print("Erreur lors du décodage JSON : \(error)")
                completion(nil)
            }
        }.resume()
        //lance la requête
    }
}
