//
//  RAGService.swift
//  ZenTheaSource
//
//  Created by Léa Percheron on 24/02/2025.
//
import Foundation
import Accelerate

class RAGService {
    static let shared = RAGService() //singleton pour éviter d'instancier plusieurs fois la classe

    private var documents: [String] = [] //liste des documents disponibles
    private var embeddings: [[Double]] = [] //liste des embeddings associés aux documents

    init() {
        if let path = Bundle.main.path(forResource: "documents", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    self.documents = json["documents"] as? [String] ?? []
                    print("Documents chargés avec succès : \(documents.count)")
                }
            } catch {
                print("Erreur lors du chargement des documents :", error)
            }
        } else {
            print("Fichier documents.json introuvable")
        }

        // recup embeddings depuis un fichier JSON
        if let path = Bundle.main.path(forResource: "embedding", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    self.embeddings = json["embeddings"] as? [[Double]] ?? []
                    print("Embeddings chargés avec succès : \(embeddings.count)")
                }
            } catch {
                print("Erreur lors du chargement des embeddings :", error)
            }
        } else {
            print("Fichier embedding.json introuvable")
        }
    }

    //Recherche les documents les plus pertinents en utilisant cosineSimilarity
    func rechercherDocuments(question: String) -> [String]? {
        // Vérifie que les données sont bien chargées avant de faire la recherche
        guard !documents.isEmpty, !embeddings.isEmpty else {
            print("Aucune donnée chargée.")
            return nil
        }

        //génère un embedding factice pour la question (dans un cas réel, on utiliserait un modèle d'IA)
        let questionEmbedding = Array(repeating: Double.random(in: -1...1), count: embeddings.first?.count ?? 384)

        //Calcule la similarité entre l'embedding de la question et chaque embedding de document
        let scores = embeddings.map { cosineSimilarity($0, questionEmbedding) }

        //recup les indices des 3 documents les plus pertinents
        let topIndices = scores.enumerated()
            .sorted { $0.element > $1.element }
            .prefix(3)
            .map { $0.offset }

        //extrait les documents correspondants
        let results = topIndices.map { documents[$0] }
        
        print("Top 3 documents sélectionnés :")
        for (i, idx) in topIndices.enumerated() {
            print("Score \(i+1) : \(scores[idx]) → \(documents[idx].prefix(200))...")
        }

        return results.isEmpty ? nil : results
    }

    //similarité cosinus entre deux vecteurs
    private func cosineSimilarity(_ vectorA: [Double], _ vectorB: [Double]) -> Double {
        let dotProduct = zip(vectorA, vectorB).map(*).reduce(0, +)
        let magnitudeA = sqrt(vectorA.map { $0 * $0 }.reduce(0, +))
        let magnitudeB = sqrt(vectorB.map { $0 * $0 }.reduce(0, +))
        return magnitudeA == 0 || magnitudeB == 0 ? 0 : dotProduct / (magnitudeA * magnitudeB)
    }
    
    //liste complète des documents
    func obtenirTousLesDocuments() -> [String] {
        return documents
    }
}
