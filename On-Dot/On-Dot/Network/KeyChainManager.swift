//
//  KeyChainManager.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/15/25.
//

import Security
import Foundation

final class KeychainManager {
    static let shared = KeychainManager()
    
    private init() {}
    
    func saveToken(_ value: String, for key: String) {
        guard let data = value.data(using: .utf8) else {
            print("KeychainManager: Failed to convert token to data")
            return
        }
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary
        
        let deleteStatus = SecItemDelete(query)
        let addStatus = SecItemAdd(query, nil)
        
        if addStatus != errSecSuccess {
            print("KeychainManager: Failed to save token to Keychain: \(addStatus)")
        }
    }
    
    func readToken(for key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        guard status == errSecSuccess, let data = dataTypeRef as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func deleteToken(for key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        SecItemDelete(query)
    }
}
