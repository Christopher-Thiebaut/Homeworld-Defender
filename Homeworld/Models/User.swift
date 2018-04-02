//
//  User.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/16/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

class UserData: Codable {
    
    var highScore: Int {
        didSet {
            self.save()
        }
    }
    
    var wantsSoundEffects: Bool = true {
        didSet {
            self.save()
        }
    }
    
    var wantsBackgroundMusic: Bool = true {
        didSet {
            self.save()
        }
    }
    
    var preferredDifficulty: Difficulty.DifficultyLevel = .medium {
        didSet {
            self.save()
        }
    }
    
    static let currentUser = UserData.load()
    
    init(highScore: Int) {
        self.highScore = highScore
    }
    
    private static var savedFileURL: URL {
        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "user_data.json"
        let fileURL = baseURL.appendingPathComponent(fileName)
        return fileURL
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(self)
            try data.write(to: UserData.savedFileURL)
        } catch let error {
            NSLog("Error saving user data to file: \(error.localizedDescription).")
        }
    }
    
    static func load() -> UserData {
        do {
            let data = try Data(contentsOf: savedFileURL)
            let userData = try JSONDecoder().decode(UserData.self, from: data)
            return userData
        } catch let error {
            NSLog("Error loading user data: \(error.localizedDescription)")
            return UserData(highScore: 0)
        }
    }
}
