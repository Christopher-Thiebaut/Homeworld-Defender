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
    
    enum DifficultyLevel {
        case easy
        case medium
        case hard
        case madness
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
        case .madness:
            return 0
        }
    }
    
}
