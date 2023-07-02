//
//  NetworkSession.swift
//  Musily
//
//  Created by Lucas Flores on 02/07/23.
//

import Foundation

class NetworkSession {
    
    func execute<T: Codable>(responseType: T.Type, request: URLRequest, completed: @escaping (Result<T, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {
                completed(.failure(.badServerResponse))
                return
            }
    
            guard (200 ... 299) ~= response.statusCode else {
                completed(.failure(.invalidStatusCode))
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(responseType, from: data)
                completed(.success(responseObject))
                return
            } catch {
                print(error)
                completed(.failure(.invalidData))
                return
            }
        }

        task.resume()
    }
}
