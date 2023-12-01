//
//  GPTService.swift
//  AIPlaner
//
//  Created by Denis Kotelnikov on 09.07.2023.
//

import Foundation

class GPTService {

    struct Response: Codable {
        let message: String
    }
    
    struct ResponseError: Codable {
        let error: String
    }
    
    init() {
      
    }
    
    enum GPTErrorType: Error {
        case networkError
        case serverError
        case parsingError
        case error(String)
    }

    // Пример использования:
    func test(promt: String, completion: @escaping (Result<String, Error>) -> ()) {
        Task {
            do {
                let url = URL(string: "http://134.209.36.254:8080/?promt=\(promt)")
                let request = URLRequest(url: url!)
                let data = try await URLSession.shared.data(for: request).0
                let fetchedData = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(fetchedData.message))
            } catch let err {
                completion(.failure(GPTErrorType.error(err.localizedDescription) ))
                return
            }
        }
    }
}
