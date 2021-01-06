//
//  Projectile.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 1/5/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import Foundation
import CoreGraphics

struct FiredProjectile {
    let size: CGSize
    let position: CGPoint
    let velocity: CGVector
    let weaponType: ProjectileType
    
    static func rocket(position: CGPoint, velocity: CGVector) -> FiredProjectile {
        FiredProjectile(
            size: CGSize(width: 12, height: 4),
            position: position,
            velocity: velocity,
            weaponType: .rocket
        )
    }
    
    static func energyPulse(position: CGPoint, velocity: CGVector) -> FiredProjectile {
        FiredProjectile(
            size: CGSize(width: 8, height: 4),
            position: position,
            velocity: velocity,
            weaponType: .energyPulse
        )
    }
}

enum ProjectileType {
    case energyPulse
    case rocket
}
