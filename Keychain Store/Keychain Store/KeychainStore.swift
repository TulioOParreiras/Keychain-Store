//
//  KeychainStore.swift
//  Keychain Store
//
//  Created by Tulio Parreiras on 30/08/20.
//  Copyright © 2020 Tulio Parreiras. All rights reserved.
//

import Foundation

final class KeychainStore {
    
    typealias Result = Swift.Result<Void, Error>
    typealias LoadResult = Swift.Result<Data, Error>
    
    private init() { }
    
    enum KeychainStoreError: Error {
        case duplicatedItem
        case unexpectedError
    }
    
    private static var serviceName: String {
        Bundle.main.bundleIdentifier ?? "KeychainStore"
    }
    
    static func save(data: Data, forKey key: String, completion: @escaping (Result) -> Void) {
        var query = self.createBaseQueryDicionary(forKey: key)
        query[kSecValueData as String] = data
        
        var result: CFTypeRef?
        let status: OSStatus = SecItemAdd(query as CFDictionary, &result)
        
        if status == errSecSuccess {
            completion(.success(()))
        } else if status == errSecDuplicateItem {
            self.update(data, forKey: key, completion: completion)
        } else if let error = result?.error, let _error = error {
            completion(.failure(_error))
        } else {
            completion(.failure(KeychainStoreError.unexpectedError))
        }
    }
    
    static func loadData(forKey key: String, completion: @escaping (LoadResult) -> Void) {
        var query = self.createBaseQueryDicionary(forKey: key)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var result: CFTypeRef?
        _ = SecItemCopyMatching(query as CFDictionary, &result)
        
        if let data = result as? Data {
            completion(.success(data))
        } else if let error = result?.error, let _error = error {
            completion(.failure(_error))
        } else {
            completion(.failure(KeychainStoreError.unexpectedError))
        }
    }
    
    static func update(_ data: Data, forKey key: String, completion: @escaping (Result) -> Void) {
        let query = self.createBaseQueryDicionary(forKey: key) as CFDictionary
        let updateDictionary = [kSecValueData as String: data] as CFDictionary
        
        let status: OSStatus = SecItemUpdate(query, updateDictionary)
        
        completion(status == errSecSuccess ? .success(()) : .failure(KeychainStoreError.unexpectedError))
    }
    
    static func deleteCache(forKey key: String, completion: @escaping (Result) -> Void) {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.serviceName
        ] as CFDictionary
        
        let status: OSStatus = SecItemDelete(query)
        
        completion(status == errSecSuccess ? .success(()) : .failure(KeychainStoreError.unexpectedError))
    }
    
    private static func createBaseQueryDicionary(forKey key: String) -> [String: Any?] {
        let encodedKey = key.data(using: .utf8)
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.serviceName,
            kSecAttrGeneric as String: encodedKey,
            kSecAttrAccount as String: encodedKey,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
    }
    
}
