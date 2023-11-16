//
//  APINimbleService.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 05/11/23.
//

import Foundation
import UIKit.UIImage

class APINimbleService {
    private var network: Network = Network()
    
    func login(with email: String, password: String, completion: @escaping (Result<LoginResponse, NetworkError>) -> Void) {
        
        let loginRequest = LoginRequest(
            grantType: .password,
            email: email,
            password: password,
            clientId: "6GbE8dhoz519l2N_F99StqoOs6Tcmm1rXgda4q__rIw",
            clientSecret: "_ayfIm7BeUAhx2W1OUqi20fwO3uNxfo1QstyKlFCgHw"
        )
        
        var urlComponents = self.network.urlComponents
        urlComponents.path = "/api/v1/oauth/token"
        
        guard let url = urlComponents.url else {
            completion(.failure(.apiError("Error with url")))
            return
        }
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(loginRequest) else {
            completion(.failure(.apiError("Error encoding data")))
            return
        }
        
        if self.network.debugPrint {
            print("Request Data: \(String(describing: data.prettyPrintedJSONString))")
        }
        
        self.network.postData(with: url, bodyData: data) { data, response, errorString in
            
            guard let data = data else {
                completion(.failure(.apiError("Error in data. Response: \(String(describing: response))")))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let responseData = try decoder.decode(LoginResponseData.self, from: data)
                completion(.success(responseData.data))
            } catch let err {
                completion(.failure(.apiError("Error decoding data: \(err)")))
            }
        }
    }
    
    func getSurveyList(completion: @escaping (Result<[SurveyListResponse], NetworkError>, _ images: [UIImage]) -> Void) {
        var urlComponents = network.urlComponents
        urlComponents.path = "/api/v1/surveys"
        urlComponents.queryItems = [
            URLQueryItem(name: "page[number]", value: "1"),
            URLQueryItem(name: "page[size]", value: "3")
        ]
        guard let url = urlComponents.url else {
            completion(.failure(.apiError("- getSurveyList method. Error creating url")), [])
            return
        }
        
        let keychain = KeychainManager()
        guard let token = keychain.getToken() else {
            completion(.failure(.apiError("Error obtaining token from Keychain")), [])
            return
        }
        
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        network.fetchData(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.apiError(error ?? "Error Unknow - getSurveyList response: \(String(describing: response as? HTTPURLResponse))")), [])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let surveyListResponseData = try decoder.decode(SurveyListResponseData.self, from: data)
                let surveys = surveyListResponseData.data
                
                guard !surveys.isEmpty else {
                    completion(.success(surveys), [])
                    return
                }
                
                var images: [UIImage] = []
                let downloader = ImageDownloader()
                let dispatchGroup = DispatchGroup()
                
                for item in surveys {
                    dispatchGroup.enter()
                    
                    guard let coverImageUrlString = item.attributes.coverImageUrl else {
                        // No image URL founded.
                        dispatchGroup.leave()
                        continue
                    }
                    
                    downloader.downloadImage(from: URL(string: coverImageUrlString)!) { image in
                        
                        guard let image = image else { return }
                        images.append(image)
                        
                        dispatchGroup.leave()
                    }
                } //END for in
                
                dispatchGroup.notify(queue: .main) {
                    // All images downloaded, notify the ViewController
                    completion(.success(surveyListResponseData.data), images)
                }
            } catch let decoderError {
                completion(.failure(.apiError("Error decoding SurveyListResponseData: \(decoderError)")), [])
            }
            
        }
    }
    
    func logout(completion: @escaping (Result<HTTPURLResponse, NetworkError>) -> Void) {
        
        guard let token = KeychainManager().getToken() else {
            return
        }
        let logoutRequest = LogoutRequest(token: token,
                                          clientId: "6GbE8dhoz519l2N_F99StqoOs6Tcmm1rXgda4q__rIw",
                                          clientSecret: "_ayfIm7BeUAhx2W1OUqi20fwO3uNxfo1QstyKlFCgHw")
        
        var urlComponents = network.urlComponents
        urlComponents.path = "/api/v1/oauth/revoke"
        
        guard let url = urlComponents.url else {
            completion(.failure(.apiError("Error with url")))
            return
        }
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        var encodedDataRequest: Data?
        do {
            encodedDataRequest = try encoder.encode(logoutRequest)
            
        } catch let error {
            completion(.failure(.apiError("Error encoding data: \(error)")))
        }
        
        guard let encodedDataRequest = encodedDataRequest else {
            completion(.failure(.apiError("Error encoding data")))
            return
        }
        
        self.network.postData(with: url, bodyData: encodedDataRequest) { data, response, errorString in
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.apiError(errorString ?? "Unknow")))
                return
            }
            completion(.success(response))
        }
            
    }
}
