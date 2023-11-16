//
//  LoginRequest.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 05/11/23.
//

import Foundation

//--data-raw '{
//    "grant_type": "password",
//    "email": "your_email@example.com",
//    "password": "12345678",
//    "client_id": "H701y6E76KGmIaWC1C-ZgSGLsBbyA0ubCIRr1xk1Ckg",
//    "client_secret": "X3ewlaFw5a4r0nKbpyXxP6ofMlZ9y8aRSu_FL1smyxg"
//}'

enum GrantType: String, Codable {
    case password, token
}

struct LoginRequest: Codable {
    var grantType: GrantType
    var email: String
    var password: String
    var clientId: String
    var clientSecret: String
}
