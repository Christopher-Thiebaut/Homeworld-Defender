//
//  DifficultyLevel.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/20/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class Difficulty {
    
    enum DifficultyLevel: String, Codable {
        case easy
        case medium
        case hard
        case insane
        
        static let allValues = [DifficultyLevel.easy, DifficultyLevel.medium, DifficultyLevel.hard, DifficultyLevel.insane]
    }
    
    let difficulty: DifficultyLevel
    
    init(difficulty: DifficultyLevel){
        self.difficulty = difficulty
    }
    
    /**
        The stormtrooper offset is why sci-fi villians miss an inexplicable amount of the time.  The difficulty is adjusted by providing a different stormtrooper offset at different difficulty levels ranging from almost comically poor accuracy to perfect shots.
    */
    func getStormTrooperOffset() -> Float{
        switch difficulty {
        case .easy:
            return (GKARC4RandomSource.sharedRandom().nextUniform() - 0.5)/2
        case .medium:
            return (GKARC4RandomSource.sharedRandom().nextUniform() - 0.5)/3
        case .hard:
            return (GKARC4RandomSource.sharedRandom().nextUniform() - 0.5)/4
        case .insane:
            return 0
        }
    }
    
    func getEnemyProjectileSpeed() -> CGFloat {
        switch difficulty {
        case .easy:
            return 500
        case .medium:
            return 1000
        case .hard:
            return 1500
        case .insane:
            return 2000
        }
    }
    
    func getEnemyReloadTime() -> TimeInterval {
        switch difficulty {
        case .easy:
            return 2.5
        case .medium:
            return 1.5
        case .hard:
            return 1
        case .insane:
            return 0.5
        }

    }
    
    func getAttackDistance() -> Float {
        switch difficulty {
        case .easy:
            return 200
        case .medium:
            return 250
        case .hard:
            return 275
        case .insane:
            return 300
        }
    }
    
    func getScoreMultiplier() -> Double {
        switch difficulty {
        case .easy:
            return 0.5
        case .medium:
            return 1
        case .hard:
            return 2
        case .insane:
            return 4
        }
    }
    
}
