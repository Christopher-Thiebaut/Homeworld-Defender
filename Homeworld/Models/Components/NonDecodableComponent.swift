//
//  NonDecodableComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/5/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class NonDecodableComponent: GKComponent {
    override init() {
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
}
