//
//  LogoutRequest.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 15/11/23.
//

import Foundation
struct LogoutRequest: Codable {
    var token: String
    var clientId: String
    var clientSecret: String
}
