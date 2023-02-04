//
//  VimeoManager.swift
//  Score MLE
//
//  Created by Manoj kumar on 02/08/22.
//

import Foundation

class VimeoManager {
    
    static let shared = VimeoManager()
    
    func getVideoURL(vimeoId: String, completion: @escaping (Result<String, APIError>) -> Void) {
        
        guard let url = URL.getVimeoVideoLink(vimeoId: vimeoId) else {
            return completion(.failure(.invalidURL))
        }
        
        var request = URLRequest(url: url)
        
        request.setValue("Bearer 12966dd7433de9edd802217930a7619b", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                return completion(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return completion(.failure(.invalidResponse))
            }
            
            guard let data = data else {
                return completion(.failure(.invalidData))
            }
            
            do {
                let someDictionaryFromJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                let vimeoData = VimeoModel(dictionary: someDictionaryFromJSON as NSDictionary)
                
                if let videoURL = vimeoData?.files?.first?.link {
                    completion(.success(videoURL))
                }
                
            } catch {
                print("Error Occured")
            }
        }
        
        task.resume()
    }
    
}


