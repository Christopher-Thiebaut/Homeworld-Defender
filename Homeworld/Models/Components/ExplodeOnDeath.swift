//
//  ExplodeOnDeath.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 1/5/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class ExplodeOnDeath: NonDecodableComponent {
    let config: ExplosionConfig
    
    init(config: ExplosionConfig) {
        self.config = config
        super.init()
    }
}
