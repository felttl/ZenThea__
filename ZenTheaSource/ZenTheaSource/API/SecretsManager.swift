//
//  SecretsManager.swift
//  ZenTheaSource
//
//  Created by Léa Percheron on 08/03/2025.
//

import Foundation

class SecretsManager {
    static let shared = SecretsManager()

    private var secrets: [String: Any]?

    private init() {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let xml = FileManager.default.contents(atPath: path),
           let dict = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainers, format: nil) as? [String: Any] {
            self.secrets = dict
        }
    }

    func getAPIKey() -> String? {
        return secrets?["MISTRAL_API_KEY"] as? String
    }
}
