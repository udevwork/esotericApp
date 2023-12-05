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
    
    func test(completion: @escaping (Result<String, Error>) -> ()) {
        Task {
            do {
                let url = URL(string: "https://gpterica.space/")
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
    
    func ask(promt: String, completion: @escaping (Result<String, Error>) -> ()) {
        Task {
            do {
                guard let urlString = "https://gpterica.space/ask/?promt=\(promt)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                      let url = URL(string: urlString) else {
                    completion(.failure(GPTErrorType.error("Invalid URL")))
                    return
                }
                let request = URLRequest(url: url)
                let (data, _) = try await URLSession.shared.data(for: request)
                let fetchedData = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(fetchedData.message))
            } catch {
                completion(.failure(GPTErrorType.error(error.localizedDescription)))
            }
        }
    }

}
