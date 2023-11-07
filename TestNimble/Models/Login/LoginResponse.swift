//
//  LoginResponse.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 05/11/23.
//

import Foundation
//
//{
//  "data": {
//    "id": "10",
//    "type": "token",
//    "attributes": {
//      "access_token": "lbxD2K2BjbYtNzz8xjvh2FvSKx838KBCf79q773kq2c",
//      "token_type": "Bearer",
//      "expires_in": 7200,
//      "refresh_token": "3zJz2oW0njxlj_I3ghyUBF7ZfdQKYXd2n0ODlMkAjHc",
//      "created_at": 1597169495
//    }
//  }
//}

enum ServiceType: String, Codable {
    case token, survey
}

enum TokenType: String, Codable {
    case Bearer
}

struct LoginResponseData: Codable {
    var data: DataResponseModel<LoginResponse>
}

struct LoginResponse: Codable {
    var id: Int
    var type: ServiceType
    var attributes: LoginResponseAttributes
}

struct LoginResponseAttributes: Codable {
    var accessToken: String
    var tokenType: TokenType
    var expiresIn: Int
    var refreshToken: String
    var createdAtTimestamp: Double
    var createAtDate: Date
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.tokenType = try container.decode(TokenType.self, forKey: .tokenType)
        self.expiresIn = try container.decode(Int.self, forKey: .expiresIn)
        self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
        self.createdAtTimestamp = try container.decode(Double.self, forKey: .createdAtTimestamp)
        
        // Check if the timestamp is in seconds or milliseconds
        if createdAtTimestamp > 9999999999 {
            // If the timestamp is in milliseconds, convert it to seconds
            createAtDate = Date(timeIntervalSince1970: createdAtTimestamp / 1000)
        } else {
            // If the timestamp is in seconds, convert it directly
            createAtDate = Date(timeIntervalSince1970: createdAtTimestamp)
        }
    }
}
