//
//  HttpUtility.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import Foundation
import SwiftUI

final class HttpUtility {
    
    static let shared  = HttpUtility()
    
    private init(){}
    
    func postData<T: Decodable>(request: URLRequest, resultType: T.Type, completionHandler: @escaping (Result<T?, APIError>) -> Void) {
        
         URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ = error {
                completionHandler(.failure(.unableToComplete))
                return
            }
            
             guard let response = response as? HTTPURLResponse, response.statusCode == 200 || response.statusCode == 201 else {
                completionHandler(.failure(.invalidResponse))
                 print(error?.localizedDescription)
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                print(error?.localizedDescription)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(resultType.self, from: data)
                completionHandler(.success(response))
            } catch let err as DecodingError {
                debugPrint(err.localizedDescription)
                //completionHandler(.failure(.invalidData))
                switch err {
                case .keyNotFound(let key, let context):
                    let errorMessage = "Key '\(key)' not found: \(context.debugDescription)"
                    completionHandler(.failure(.decodingError(message: errorMessage)))
                case .typeMismatch(let type, let context):
                    let errorMessage = "Type '\(type)' mismatch: \(context.debugDescription)"
                    completionHandler(.failure(.decodingError(message: errorMessage)))
                case .valueNotFound(let type, let context):
                    let errorMessage = "Value not found for type '\(type)': \(context.debugDescription)"
                    completionHandler(.failure(.decodingError(message: errorMessage)))
                default:
                    completionHandler(.failure(.decodingError(message: "Unknown error")))
                }
            } catch {
                completionHandler(.failure(.customMessage(message: "Something went wrong")))
            }
            
        }.resume()
        
    }
}
