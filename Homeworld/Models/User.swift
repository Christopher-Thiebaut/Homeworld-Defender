//
//  User.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/16/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

struct UserData: Codable {
    
    var highScore: Int
    
    static let currentUser = UserData()
    
    init() {
        if let savedUser = UserData.load() {
            self = savedUser
        }else{
            self.init(highScore: 0)
        }
    }
    
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
    
    static func load() -> UserData? {
        do {
            let data = try Data(contentsOf: savedFileURL)
            let userData = try JSONDecoder().decode(UserData.self, from: data)
            return userData
        } catch let error {
            NSLog("Error loading user data: \(error.localizedDescription)")
            return nil
        }
    }
}
