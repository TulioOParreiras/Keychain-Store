//
//  KeychainStore.swift
//  Keychain Store
//
//  Created by Tulio Parreiras on 30/08/20.
//  Copyright © 2020 Tulio Parreiras. All rights reserved.
//

import Foundation

/// The KeychainStore is an object with purpose to save, delete and update Data values on Keychain
final class KeychainStore {
    
    /// Result from operations that does not returns any value on success case
    typealias Result = Swift.Result<Void, Error>
    
    /// Result from operations that returns Data value on success case
    typealias LoadResult = Swift.Result<Data, Error>
    
    /// Private init in order to avoid overriding any
    private init() { }
    
    /// Custom Errors
    enum KeychainStoreError: Error {
        case unexpectedError
    }
    
    /// Extract service name property
    private static var serviceName: String {
        Bundle.main.bundleIdentifier ?? "KeychainStore"
    }
    
    /// Save a Data value for a given key
    /// - Parameters:
    ///   - data: The Data to be saved
    ///   - key: The key used to identify the data on Keychain after being saved
    ///   - completion: The block to execute after the data save operation finishes. This block has no return value on success case and takes no parameters.
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
    
    /// Load Data for a given key
    /// - Parameters:
    ///   - key: The key used to locate the saved data on Keychain
    ///   - completion: The block to execute after the data load operation finishes. This block returns a Data value on success case and takes no parameters.
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
    
    /// Update a  Data value for a given key
    /// - Parameters:
    ///   - data: The Data to be updated
    ///   - key: The key used to identify the data on Keychain after being updated
    ///   - completion: The block to execute after the data update operation finishes. This block has no return value on success case and takes no parameters.
    static func update(_ data: Data, forKey key: String, completion: @escaping (Result) -> Void) {
        let query = self.createBaseQueryDicionary(forKey: key) as CFDictionary
        let updateDictionary = [kSecValueData as String: data] as CFDictionary
        
        let status: OSStatus = SecItemUpdate(query, updateDictionary)
        
        completion(status == errSecSuccess ? .success(()) : .failure(KeychainStoreError.unexpectedError))
    }
    
    /// Delete a cached value for a given key
    /// - Parameters:
    ///   - key: The key used to identify the saved data on Keychain
    ///   - completion: The block to execute after the data delete operation finishes. This block has no return value on success case and takes no parameters.
    static func deleteCache(forKey key: String, completion: @escaping (Result) -> Void) {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.serviceName
        ] as CFDictionary
        
        let status: OSStatus = SecItemDelete(query)
        
        completion(status == errSecSuccess ? .success(()) : .failure(KeychainStoreError.unexpectedError))
    }
    
    /// Generates a base dictionary with the default values for the save, update and delete operations for a given key
    /// - Parameter key: The key used to identifiy the data on Keychain
    /// - Returns: The base dictionary with the default values
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
