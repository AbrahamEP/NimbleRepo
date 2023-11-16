//
//  KeychainManager.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 06/11/23.
//

import Foundation
import Security

class KeychainManager {
    
    private let service: String = {
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            let keychainService = bundleIdentifier + ".tokens"
            return keychainService
        } else {
            fatalError("bundle identifier not founded")
        }
    }()

    
    func saveToken(_ token: String) -> Bool {
        guard let data = token.data(using: .utf8) else {
                return false
            }
            
            let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecValueData: data
            ]
            
            let status = SecItemAdd(query as CFDictionary, nil)
            
            return status == errSecSuccess
    }
    
    func getToken() -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var tokenData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &tokenData)
        
        if status == errSecSuccess, let data = tokenData as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        }
        
        return nil
    }
    
    func deleteToken() -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        return status == errSecSuccess
    }
}
