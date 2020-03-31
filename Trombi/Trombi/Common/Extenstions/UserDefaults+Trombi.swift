//
//  UserDefaults+Trombi.swift
//  Trombi
//
//  Created by Chris Rusin on 12/15/19.
//  Copyright © 2019 Christian Rusin . All rights reserved.
//

import Foundation

extension UserDefaults {

    private struct Keys {
        static let lastSearches = "lastSearches"
        static let baseUrl = "baseUrl"
    }

    // MARK: - Last searches

    class var lastSearches: [String] {
        let storedValue = UserDefaults.standard.array(forKey: UserDefaults.Keys.lastSearches)
        return storedValue as? [String] ?? []
    }

    class func set(lastSearches: [String]) {
        UserDefaults.standard.set(lastSearches, forKey: UserDefaults.Keys.lastSearches)
    }
    
    // MARK: - Base url
    
    class var baseUrl: String? {
        let storedValue = UserDefaults.standard.string(forKey: UserDefaults.Keys.baseUrl)
        return storedValue
    }
    
    class func set(baseUrl: String?) {
        UserDefaults.standard.set(baseUrl, forKey: UserDefaults.Keys.baseUrl)
    }
}
