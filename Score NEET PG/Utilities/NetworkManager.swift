//
//  NetworkManager.swift
//  Score MLE
//
//  Created by ios on 29/07/22.
//

import UIKit

class NetworkManager: NSObject {
    
    static let shared           = NetworkManager()
    private let cache           = NSCache<NSString, UIImage>()
    
    private override init() {}
    
    
    // MARK: - DOWNLOAD IMAGE
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
    }
    
    // MARK: - GET USER DETAILS
    func getUserDetails(mobileNumber: String, completed: @escaping (Result<UserDetailsResponse, APIError>) -> Void) {
        
        guard let url = URL.getUserDetails() else {
            return completed(.failure(.invalidURL))
        }
        
        let parameters: [String: Any] = [
            "mobileNumber": mobileNumber,
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST

        // add headers for the request
          request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
          request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
          // convert parameters to Data and assign dictionary to httpBody of request
          request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
          print(error.localizedDescription)
          return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(UserDetailsResponse.self, from: data)
                completed(.success(decodedResponse))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    
    
    //MARK: - Updated GET USER DETAILS
    
    func getUser(mobileNumber: String, completed: @escaping (Result<User, APIError>) -> Void) {
        
        guard let url = URL.user(mobileNumber: mobileNumber) else {
            return completed(.failure(.invalidURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
       
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completed(.failure(.unableToComplete))
                return
            }
            
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(.failure(.invalidResponse))
//                return
//            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(User.self, from: data)
                completed(.success(decodedResponse))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    
    //MARK: - Updated GET USER DETAILS
    
    func deleteUser(mobileNumber: String, completed: @escaping (Result<Bool, APIError>) -> Void) {
        
        guard let url = URL.user(mobileNumber: mobileNumber) else {
            return completed(.failure(.invalidURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
       
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 204 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            completed(.success(true))
            
//            guard let data = data else {
//                completed(.failure(.invalidData))
//                return
//            }
            
//            do {
//                let decoder = JSONDecoder()
//                let decodedResponse = try decoder.decode(User.self, from: data)
//                completed(.success(decodedResponse))
//            } catch {
//                completed(.failure(.invalidData))
//            }
        }
        
        task.resume()
    }
    
    
    // MARK: - UPDATE USER DETAILS
    
    func updateUserDetails(parameters: [String : Any], apiType: String? = "POST", completed: @escaping (Result<Bool,Authentication.AuthenticationError>) -> Void) {
        
        guard let url = URL.updateUserDetails() else {
            return completed(.failure(.invalidURL))
        }
        
//        let parameters: [String: Any] = [
//            "mobileNumber": mobileNumber,
//            "userId": "123456",
//            "gcmId" : "123456"
//        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = apiType //set http method as POST

        // add headers for the request
          request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
          request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
          // convert parameters to Data and assign dictionary to httpBody of request
          request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
          print(error.localizedDescription)
          return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(UserDetailsResponse.self, from: data)
                
                DispatchQueue.main.async {
                    let userDetails = decodedResponse.userLst?.first
                    
                    UserSession.userSessionInstance.setUserSession(userId: userDetails?.userID ?? "",
                                                                   image: userDetails?.imageURL ?? "",
                                                                   firstName: userDetails?.name ?? "", lastName: "",
                                                                   mobileNumber: userDetails?.mobileNumber ?? "",
                                                                   subscriptionPurchasedDate: userDetails?.subscriptionExpiration)
                    completed(.success(true))
                }
               
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    
    // MARK: - UPDATE USER DETAILS
    
    func updateUser(mobileNumber: String, parameters: [String : Any], apiType: String? = "POST", completed: @escaping (Result<Bool,Authentication.AuthenticationError>) -> Void) {
        
        guard let url = URL.user(mobileNumber: mobileNumber) else {
            return completed(.failure(.invalidURL))
        }
 
        
        var request = URLRequest(url: url)
        request.httpMethod = apiType //set http method as POST

        // add headers for the request
          request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
          request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
          // convert parameters to Data and assign dictionary to httpBody of request
          request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
          print(error.localizedDescription)
          return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(User.self, from: data)
                
                DispatchQueue.main.async {
                    let userDetails = decodedResponse
                    UserSession.userSessionInstance.setUserSession(userId: userDetails.id?.description ?? "",
                                                                   image: userDetails.photo ?? "",
                                                                   firstName: userDetails.firstName ?? "",
                                                                   lastName: userDetails.lastName ?? "",
                                                                   mobileNumber: mobileNumber,
                                                                   subscriptionPurchasedDate: userDetails.paymentExpiryDate)
                    completed(.success(true))
                }
               
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    
    //MARK: - SESSION
    
    func getSession(completion: @escaping (Result<Int, APIError>) -> Void) {
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        guard let url = URL.getSession(phoneNumber: phoneNumber) else {
            return completion(.failure(.invalidURL))
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ = error {
                return completion(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse,  response.statusCode == 200 else {
                return completion(.failure(.invalidResponse))
            }
            
            guard let data = data else {
                return completion(.failure(.invalidData))
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let server_response = json as? NSDictionary else {
                    return
                }
                
                guard let link = server_response ["session"] as? Int else { return }
                
                completion(.success(link))
                
                //let message = server_response ["link"] as? String
            } catch {
                completion(.failure(.invalidData))
            }
            
        }
        
        task.resume()
        
    }
    
    
    //MARK: - DELETE ALL DATA
    
    func deleteAllData(completion: @escaping (Result<Bool, APIError>) -> Void) {
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        guard let url = URL.deleteAllData(phoneNumber: phoneNumber) else {
            return completion(.failure(.invalidURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE" //set http method as POST
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ = error {
                return completion(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse,  response.statusCode == 200 else {
                return completion(.failure(.invalidResponse))
            }
            
            guard let data = data else {
                return completion(.failure(.invalidData))
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
               
                
                completion(.success(true))
                
                //let message = server_response ["link"] as? String
            } catch {
                completion(.failure(.invalidData))
            }
            
        }
        
        task.resume()
        
    }
    
    
    // MARK: - USER FAV ICON
    
    func getChatBotFavIcon(completion: @escaping (Result<String, APIError>) -> Void) {
        
        guard let url = URL.getChatBotFavIcon() else {
            return completion(.failure(.invalidURL))
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let server_response = json as? NSArray else {
                    return
                }
                
                guard let responseDictionay = server_response[0] as? NSDictionary else {
                    return
                }
                
                guard let link = responseDictionay ["link"] as? String else { return }
                
                completion(.success(link))
                
                //let message = server_response ["link"] as? String
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
        
    }
    
    // MARK: - CHAT BOT MESSEAGES
    
    func getChatBotMessages(parameters: [String : Any], completion: @escaping (Result<ChatBot, APIError>) -> Void) {
        guard let url = URL.getChatBot() else {
            return completion(.failure(.invalidURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // add headers for the request
          request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
          request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
          // convert parameters to Data and assign dictionary to httpBody of request
          request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
          print(error.localizedDescription)
          return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(ChatBot.self, from: data)
                completion(.success(decodedResponse))
            } catch let err{
                print(err.localizedDescription)
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
        
    }
    
    
    // MARK: - GET RIGHT WRONG QUESTIONS
    
    func getrightWrongQuestions(isRightQuestion: Bool, completion: @escaping (Result<RightWrongQuestions, APIError>) -> Void) {
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        guard let url = URL.getRightWrongQuestions(phoneNumber: phoneNumber, isRightQuestion: isRightQuestion) else {
            return completion(.failure(.invalidURL))
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(RightWrongQuestions.self, from: data)
                completion(.success(decodedResponse))
            } catch let err{
                print(err.localizedDescription)
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
        
    }
    
    // MARK: - GET RIGHT SHYF WRONG QUESTIONS
    
    func getShyfRightWrongQuestions(category: String, completion: @escaping (Result<ShyfRightWrongQuestions, APIError>) -> Void) {
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        guard let url = URL.getShyfRightWrongQuestions(phoneNumber: phoneNumber, category: category) else {
            return completion(.failure(.invalidURL))
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(ShyfRightWrongQuestions.self, from: data)
                completion(.success(decodedResponse))
            } catch let err{
                print(err.localizedDescription)
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
        
    }
    
    
    // MARK: - GET MOCK TEST LIST
    
    func getMockTestList(_ completion: @escaping (Result<MockTest, APIError>) -> Void) {
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        guard let url = URL.getMockTestList(phoneNumber: phoneNumber) else {
            return completion(.failure(.invalidURL))
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(MockTest.self, from: data)
                completion(.success(decodedResponse))
            } catch let err{
                print(err.localizedDescription)
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
        
    }
    
    
    // MARK: - GET MOCK TEST QUESTIONS
    
    func getMockQuestions(mockTestID: String, _ completion: @escaping (Result<MockQuestion, APIError>) -> Void) {
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        guard let url = URL.getMockTestQuestions(phoneNumber: phoneNumber, mockTestID: mockTestID) else {
            return completion(.failure(.invalidURL))
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(MockQuestion.self, from: data)
                completion(.success(decodedResponse))
            } catch let err{
                print(err.localizedDescription)
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
        
    }
    
    
    // MARK: - GET SUBJECTS
    
    func getSubjects(_ completion: @escaping (Result<Subject, APIError>) -> Void) {
        
        guard let url = URL.getSubjects() else {
            return completion(.failure(.invalidURL))
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(Subject.self, from: data)
                completion(.success(decodedResponse))
            } catch let err{
                print(err.localizedDescription)
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
        
    }
    
    
    // MARK: - GET SUBJECTS WITH PPT
    
    func getSubjectsWithPPT(_ completion: @escaping (Result<Subject, APIError>) -> Void) {
        
        guard let url = URL.getSubjectsWithPPT() else {
            return completion(.failure(.invalidURL))
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(Subject.self, from: data)
                completion(.success(decodedResponse))
            } catch let err{
                print(err.localizedDescription)
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
        
    }
    
    // MARK: - GET HYF ID
    
    func getHyfVideo(subjectID: String, _ completion: @escaping (Result<Hyf, APIError>) -> Void) {
        
        guard let url = URL.getHyfID(subjectID: subjectID) else {
            return completion(.failure(.invalidURL))
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(Hyf.self, from: data)
                completion(.success(decodedResponse))
            } catch let err{
                print(err.localizedDescription)
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
        
    }
    
    // MARK: - GET QUESTION HYF
    
    func getVideoData(subjectID: String, hyfID: String, _ completion: @escaping (Result<[VideoElement], APIError>) -> Void) {
        
        guard let url = URL.getQuestionHYF(subjectID: subjectID, hyfID: hyfID) else {
            return completion(.failure(.invalidURL))
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode([VideoElement].self, from: data)
                completion(.success(decodedResponse))
            } catch let err{
                print(err.localizedDescription)
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
        
    }
    
    
    // MARK: - GET HYF ID
    
    func getHyfPPTList(subjectID: String, _ completion: @escaping (Result<PPTList, APIError>) -> Void) {
        
        guard let url = URL.getQuestionsWithPPT(subjectID: subjectID) else {
            return completion(.failure(.invalidURL))
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(PPTList.self, from: data)
                completion(.success(decodedResponse))
            } catch let err{
                print(err.localizedDescription)
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
        
    }
    
    
    //MARK: - GET HYF PPT DATA
    
   // getQuestionPPT
    
    func getPPTData(subjectID: String, hyfID: String, _ completion: @escaping (Result<Ppt, APIError>) -> Void) {
        
        guard let url = URL.getQuestionPPT(subjectID: subjectID, id: hyfID) else {
            return completion(.failure(.invalidURL))
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(Ppt.self, from: data)
                completion(.success(decodedResponse))
            } catch let err{
                print(err.localizedDescription)
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
        
    }
    
}



