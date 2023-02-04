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
            } catch let err {
                debugPrint(err)
                completionHandler(.failure(.invalidData))
            }
            
        }.resume()
        
    }
}
