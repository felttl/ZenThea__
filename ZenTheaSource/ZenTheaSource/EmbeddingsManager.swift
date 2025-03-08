//
//  EmbeddingsManager.swift
//  ZenTheaSource
//
//  Created by Léa Percheron on 24/02/2025.
//

import Foundation

//classe pour gérer les embeddings des documents et permettre la recherche de documents similaires
class EmbeddingsManager {
    static let shared = EmbeddingsManager()
    //singleton pour éviter d'instancier plusieurs fois la classe
    
    private var documents: [String] = []//liste des documents disponibles
    private var embeddings: [[Double]] = []//liste des embeddings associés aux documents

    init() {
        chargerEmbeddings()
        print("Nombre de documents chargés : \(documents.count)")
        print("Nombre d'embeddings chargés : \(embeddings.count)")
    }
    
    //fnction qui charge les embeddings et les documents depuis un fichier JSON
    private func chargerEmbeddings() {
        guard let path = Bundle.main.path(forResource: "embeddings", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let docArray = json["documents"] as? [String],
              let embArray = json["embeddings"] as? [[Double]] else {
            print("Erreur lors du chargement des embeddings")
            return
        }

        self.documents = docArray
        self.embeddings = embArray
        print("Embeddings chargés avec succès")
    }
    
    //fonction qui cherche les documents les plus pertinents par rapport à une question
    func rechercherDocuments(question: String) -> [String] {
        // Génère l'embedding de la question (vecteur numérique représentant son sens)
        guard let questionEmbedding = genererEmbedding(pour: question) else {
            print("Impossible de générer l'embedding de la question")
            return []
        }

        print("Question : \(question)")
        print("Nombre de documents à comparer : \(documents.count)")

        var results: [(String, Double)] = [] //liste des résultats sous forme (document, score)
        
        //compare la question avec chaque document pour voir lesquels sont pertinents
        for (index, embedding) in embeddings.enumerated() {
            let score = similaritéCosine(vec1: questionEmbedding, vec2: embedding)
            print("Score avec \(documents[index]): \(score)")
            
            if score > 0.75 {  //si le score de similarité est assez élevé, on garde ce document
                results.append((documents[index], score))
            }
        }
        
        //trie les résultats du plus pertinent au moins pertinent
        let sortedResults = results.sorted { $0.1 > $1.1 }
        
        //A&fficher les 5 meilleurs résultats pour débug
        for (doc, score) in sortedResults.prefix(5) {
            print("Résultat : \(doc) | Score : \(score)")
        }

        return sortedResults.map { $0.0 }
    }
    
    //fonction pour générer un embedding (vecteur numérique) à partir d'un texte
    private func genererEmbedding(pour texte: String) -> [Double]? {
        // En attendant, on retourne un vecteur bidon (rempli de 0.5) juste pour que ça fonctionne
        return Array(repeating: 0.5, count: 384)
    }
    
    private func similaritéCosine(vec1: [Double], vec2: [Double]) -> Double {
        let dotProduct = zip(vec1, vec2).map(*).reduce(0, +)
        let magnitude1 = sqrt(vec1.map { $0 * $0 }.reduce(0, +))
        let magnitude2 = sqrt(vec2.map { $0 * $0 }.reduce(0, +))
        return dotProduct / (magnitude1 * magnitude2)
    }
}
