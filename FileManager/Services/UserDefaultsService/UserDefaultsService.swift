//
//  UserDefaultsService.swift
//  FileManager
//
//  Created by Oleshkevich Artem on 25.06.22.
//

import Foundation

class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    private init() {}
    
    func saveDisplayMode(mode: DisplayMode, key: String) {
        UserDefaults.standard.set(mode.rawValue, forKey: key)
    }
    
    func getDisplayMode(key: String) -> String? {
        UserDefaults.standard.string(forKey: key)
    }
}

