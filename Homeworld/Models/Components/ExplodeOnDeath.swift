//
//  ExplodeOnDeath.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 1/5/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

public class ExplodeOnDeath: GKComponent {
    let config: ExplosionConfig
    
    init(config: ExplosionConfig) {
        self.config = config
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
