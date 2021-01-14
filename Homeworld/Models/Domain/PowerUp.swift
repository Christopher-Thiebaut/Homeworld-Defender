//
//  PowerUp.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 1/14/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import Foundation
import CoreGraphics

struct PowerUp {
    enum Effect {
        case heal(amount: Int)
    }
    let effect: Effect
    let upwardSpeed: CGFloat
}
