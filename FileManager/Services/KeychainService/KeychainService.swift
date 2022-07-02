//
//  KeychainService.swift
//  FileManager
//
//  Created by Oleshkevich Artem on 25.06.22.
//

import KeychainSwift
import Darwin

class KeychainService {
    static let shared = KeychainService()
    
    private let keychain = KeychainSwift()
    
    private init() { }
    
    func getPassword() -> String? {
        keychain.get(KeychainKey.password.rawValue)
    }
    
    func setPassword(value: String) {
        keychain.set(value, forKey: KeychainKey.password.rawValue)
    }
}

enum KeychainKey: String {
    case password
}
