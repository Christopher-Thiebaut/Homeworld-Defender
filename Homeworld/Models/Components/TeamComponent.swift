//
//  TeamComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/1/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class TeamComponent: GKComponent {
    
    enum Team {
        case human
        case alien
    }
    
    let team: Team
    
    init(team: Team){
        self.team = team
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
