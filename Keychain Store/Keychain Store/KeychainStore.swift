//
//  KeychainStore.swift
//  Keychain Store
//
//  Created by Tulio Parreiras on 30/08/20.
//  Copyright © 2020 Tulio Parreiras. All rights reserved.
//

import Foundation

final class KeychainStore {
    
    private init() { }
    
    enum KeychainStoreError: Error {
        case duplicatedItem
        case unexpectedError
    }
    
    static func save(data: Data, forKey key: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let encodedKey = key.data(using: .utf8)
        let serviceName = Bundle.main.bundleIdentifier ?? "KeychainStore"
        let query: [String: Any?] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrGeneric as String: encodedKey,
            kSecAttrAccount as String: encodedKey,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        var result: CFTypeRef?
        let status: OSStatus = SecItemAdd(query as CFDictionary, &result)
        
        if status == errSecSuccess {
            completion(.success(()))
        } else if status == errSecDuplicateItem {
            completion(.failure(KeychainStoreError.duplicatedItem))
        } else if let error = result?.error, let _error = error {
            completion(.failure(_error))
        } else {
            completion(.failure(KeychainStoreError.unexpectedError))
        }
    }
    
}
