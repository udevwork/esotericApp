//
//  GPTService.swift
//  AIPlaner
//
//  Created by Denis Kotelnikov on 09.07.2023.
//

import OpenAI


class GPTService {

    private let key = "gpt_api_key".remote()
    private var openAI: OpenAI? = nil
    
    init() {
        config()
    }
    
    enum GPTErrorType: Error {
        case networkError
        case serverError
        case parsingError
        case error(String)
    }

    // Пример использования:
    func test(promt: String, completion: @escaping (Result<String, Error>) -> ()) {
        guard let openAI = openAI else {
            completion(.failure(GPTErrorType.networkError))
            return
        }
        let query = getQuery(with: promt)
        Task {
            do {
                let result = try await openAI.chats(query: query)
                guard let content = result.choices.first?.message.content else {
                    completion(.failure(GPTErrorType.serverError))
                    return
                }
                completion(.success(content))
                return
            } catch let err {
                completion(.failure(GPTErrorType.error(err.localizedDescription) ))
                return
            }
        }
    }


    
    private func getQuery(with promt: String) -> ChatQuery {
        
        let messages: [Chat] = [
            Chat(role: .user, content: "Я гадаю на картах таро. Уложись в 2-3 абзаца. Мне нужен максимально креативный и загадочный ответ в первом абзаце, а потом серьезно отвечай. "),
            Chat(role: .user, content: promt)
        ]
        
        return ChatQuery(model: .gpt3_5Turbo,
                         messages: messages,
                         functions: nil,        // [ChatFunctionDeclaration]
                         functionCall: nil,     // ChatQuery.FunctionCall?
                         temperature: 1,        // Double
                         topP: nil,             // Double
                         n: nil,                // Int
                         stop: nil,             // [String]
                         maxTokens: nil,        // Int
                         presencePenalty: nil,  // Double
                         frequencyPenalty: nil, // Double
                         logitBias: nil,        // [String : Int]
                         user: nil,             // String
                         stream: false)
    }
    
    private func config(){
        let configuration = OpenAI.Configuration(token: self.key, timeoutInterval: 20.0)
        self.openAI = OpenAI(configuration: configuration)
    }
    
}
