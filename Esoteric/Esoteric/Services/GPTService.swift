//
//  GPTService.swift
//  AIPlaner
//
//  Created by Denis Kotelnikov on 09.07.2023.
//

import Foundation


class GPTService {
    
    struct Message: Codable {
                
        enum Role: String {
            case user = "user"
            case system = "system"
            case assistant = "assistant"
        }
        
        init(_ role: Role, _ content: String) {
            self.role = role.rawValue
            self.content = content
        }
        
        let role: String
        let content: String
        
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
    
    func ask(messages: [Message], completion: @escaping (Result<[String : Any], Error>) -> ()) {
        var components = baseComponent()
        components.queryItems = query(with: messages)
        task(components, completion)
    }
    
    
    func ask(promt: String, format: String, completion: @escaping (Result<[String : Any], Error>) -> ()) {
        var components = baseComponent()
        components.queryItems = query(with: [Message.json(format: format),
                                             Message.lang(User.language),
                                             Message(.user, promt)])
        
        task(components, completion)
    }

    private func task(_ components: URLComponents,_ completion: @escaping (Result<[String : Any], Error>) -> ()) {
        
        guard let url = components.url else {
            completion(.failure(GPTErrorType.error("url error components")))
            return
        }
        
        Task {
            do {
                let request = URLRequest(url: url)
                let (data, resp) = try await URLSession.shared.data(for: request)
                
#if DEBUG
                print("absoluteString:", url.absoluteString)
                print(data.prettyPrintedJSONString ?? "not json")
#endif
                
                let fetchedData = try JSONDecoder().decode(Message.self, from: data)
                
                do {
                    if let dict = try JSONSerialization.jsonObject(with: Data(fetchedData.content.utf8), options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            completion(.success(dict))
                        }
                    }
                } catch let error as NSError {
                    completion(.failure(GPTErrorType.error(error.localizedDescription)))
                    print("Failed to load: \(error.localizedDescription)")
                }
             
            } catch (let error) {
                completion(.failure(GPTErrorType.error(error.localizedDescription)))
            }
        }
    }
    
    private func query(with items: [Message]) -> [URLQueryItem] {
        let value = "messages[]"
        var res: [URLQueryItem] = items.map({
            URLQueryItem(name: value, value: $0.json())
        })
        return res
    }
    
    private func baseComponent() -> URLComponents {
        
        var components = URLComponents()
#if DEBUG
        components.scheme = "http"
        components.host   = "localhost"
#else
        components.scheme = "https"
        components.host   = "gpterica.space"
#endif
        
        components.path = "/v2/ask/"
        return components
    }
    
}


extension GPTService.Message {
    // templates
    static func json(format: String) -> GPTService.Message {
        GPTService.Message(.system, "Responce in JSON. Format: \(format)")
    }
    static func lang(_ code: String) -> GPTService.Message {
        GPTService.Message(.system, "Use \(code) Language for values")
    }
}
