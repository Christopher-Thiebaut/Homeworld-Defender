//
//  TeamComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/1/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class TeamComponent: NonDecodableComponent {
    
    enum Team {
        case human
        case alien
        case environment
    }
    
    let team: Team
    
    init(team: Team){
        self.team = team
        super.init()
    }
}
