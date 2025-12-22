//
//  UserDefaultsService.swift
//  Tracker
//
//  Created by Андрей Пермяков on 22.12.2025.
//

import Foundation

final class UserDefaultsService {

    static let shared = UserDefaultsService()

    private let storage = UserDefaults.standard

    private enum Keys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }

    private init() {}

    var hasSeenOnboarding: Bool {
        get {
            storage.bool(forKey: Keys.hasSeenOnboarding)
        }
        set {
            storage.set(newValue, forKey: Keys.hasSeenOnboarding)
        }
    }
}

