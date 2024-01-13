//
//  Codable+EXT.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 09.01.2024.
//

import Foundation

extension Encodable {
    func json() -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601 // Use ISO 8601 date format
        do {
            let jsonData = try encoder.encode(self)
            // jsonData now contains the JSON data for the article
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString) // Prints the JSON string
                return jsonString
            }
        } catch {
            print("Error encoding article: \(error)")
        }
        return ""
    }
}
