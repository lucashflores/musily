//
//  NetworkManager.swift
//  Musily
//
//  Created by Lucas Flores on 29/06/23.
//

import Foundation

class NetworkManager {
    public static let shared = NetworkManager()
    
    func askChatGPT(prompt: String, completed: @escaping (Result<String, NetworkError>) -> Void) async {
        let apiKey = "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"
        let model = "gpt-3.5-turbo"
        let temperature = 0.9
        let maxTokens = 150

        let requestBody : [String : Any] = [
            "model": model,
            "messages": [["role": "user", "content": prompt]],
            "temperature": temperature,
            "max_tokens": maxTokens,
        ]

        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody)

        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/chat/completions")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                completed(.failure(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                completed(.failure(.invalidStatusCode))
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(ChatGPTAnswer.self, from: data)
                guard let answer = responseObject.choices.first?.message.content else {
                    completed(.failure(.invalidData))
                    return
                }
                completed(.success(answer))
                return
            } catch {
                completed(.failure(.invalidData))
                return
            }
        }

        task.resume()
        
    }
}
