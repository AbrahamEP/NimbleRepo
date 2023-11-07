//
//  APINimbleService.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 05/11/23.
//

import Foundation

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
        print("URL Request url:\(url)")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(loginRequest) else {
            completion(.failure(.apiError("Error encoding data")))
            return
        }
        
        print("Request Data: \(String(describing: data.prettyPrintedJSONString))")
        
        self.network.postData(with: url, bodyData: data) { data, response, errorString in
            
            guard let data = data else {
                completion(.failure(.apiError("Error in data. Response: \(String(describing: response))")))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let loginResponseData = try? decoder.decode(LoginResponseData.self, from: data) else {
                
                completion(.failure(.apiError("Error decoding data")))
                return
            }
            
            completion(.success(loginResponseData.data.data))
        }
        
    }
}
