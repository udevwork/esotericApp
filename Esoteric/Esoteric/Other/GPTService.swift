//
//  GPTService.swift
//  AIPlaner
//
//  Created by Denis Kotelnikov on 09.07.2023.
//

import OpenAI


class GPTService {

    private let key = "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"
    private var openAI: OpenAI? = nil
    
    init() {
        config()
    }
    
    func test(promt: String, completion: @escaping (String)-> ()) {
        guard let openAI = openAI else { return }
        
        let query = getQuery(with: promt)
        
        Task {
            let result = try await openAI.chats(query: query)
            
            result.choices.forEach { choice in
                completion(choice.message.content ?? "// Будущее туманно...")
            }
            
        }
    }
    
    private func getQuery(with promt: String) -> ChatQuery {
        
        let messages: [Chat] = [
            Chat(role: .user, content: "Мне нужен максимально креативный и загадочный ответ."),
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
