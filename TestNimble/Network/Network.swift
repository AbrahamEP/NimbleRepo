//
//  Network.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 05/11/23.
//

import Foundation

enum NetworkError: Error {
    case apiError(String)
}

class Network {
    
    //MARK: - Variables
    private let baseUrlString = "https://survey-api.nimblehq.co/"
    var debugPrint = true
    
    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "survey-api.nimblehq.co"
        
        return components
    }
    
    func postData(with url: URL, bodyData: Data, completion: @escaping (Data?, URLResponse?, String?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if debugPrint {
            print("Request httpBody: \(String(describing: request.httpBody?.prettyPrintedJSONString))")
        }
        
        let task = URLSession.shared.dataTask(with: request) { [debugPrint = self.debugPrint] data, response, error in
            if let error = error {
                let errorString = String(describing: error)
                completion(nil, response, "Error fetching data: \(errorString)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                if debugPrint {
                    print("Error with the response: \(String(describing: response))")
                }
                completion(nil, response, "Error with the response: \(String(describing: response))")
                return
            }
            
            if debugPrint {
                print("API Response: \(httpResponse)")
            }
            
            guard let data = data else {
                completion(nil, httpResponse, "Error obtaining data: \(String(describing: response))")
                return
            }
            if debugPrint {
                print("API Data: \(String(describing: data.prettyPrintedJSONString ?? ""))")
            }
            
            completion(data, httpResponse, nil)
        }

        task.resume()
    }

    
    func fetchData(with url: URLRequest, completion: @escaping (Data?, URLResponse?, String?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { [debugPrint = self.debugPrint] data, response, error in
            if let error = error {
                let errorString = String(describing: error)
                completion(nil, nil, "Error fetching data: \(errorString)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, nil, "Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            
            if debugPrint {
                print("API Response: \(httpResponse)")
            }
            
            guard let data = data else {
                completion(nil, nil, "Error obtaining data: \(String(describing: response))")
                return
            }
            if debugPrint {
                print("API Data: \(String(describing: data.prettyPrintedJSONString ?? ""))")
            }
            
            completion(data, httpResponse, nil)
        }
        
        task.resume()
    }
}
