//
//  GKComponentSystem+Default.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 10/5/20.
//  Copyright © 2020 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

extension Array where Element: GKComponentSystem<GKComponent> {
    static var productionConfigurtion: [GKComponentSystem<GKComponent>] {
                let airfoilSystem = GKComponentSystem(componentClass: AirfoilComponent.self)
                let firingSystem = GKComponentSystem(componentClass: FireProjectileComponent.self)
                let manualRotationSystem = GKComponentSystem(componentClass: ManualRotationComponent.self)
                let animatedSystem = GKComponentSystem(componentClass: AnimatedComponent.self)
                let propulsionSystem = GKComponentSystem(componentClass: PropulsionComponent.self)
                let passiveAgentSystem = GKComponentSystem(componentClass: PassiveAgent.self)
                let raiderAgentSystem = GKComponentSystem(componentClass: RaiderAgent.self)
                let contactDamageComponent = GKComponentSystem(componentClass: ContactHealthModifier.self)
                let healthSystem = GKComponentSystem(componentClass: HealthComponent.self)
                let expirationSystem = GKComponentSystem(componentClass: LifespanComponent.self)
                let rocketEffectSystem = GKComponentSystem(componentClass: RocketEffectComponent.self)
                let displayedStatusBarsSystem = GKComponentSystem(componentClass: PercentageBarComponent.self)
                let constantAnimationSystem = GKComponentSystem(componentClass: ConstantAnimationComponent.self)
                let healthSpawningSystem = GKComponentSystem(componentClass: HealthSpawner.self)
                return [airfoilSystem, firingSystem, manualRotationSystem, animatedSystem, propulsionSystem, passiveAgentSystem, healthSystem, expirationSystem, contactDamageComponent, rocketEffectSystem, raiderAgentSystem, displayedStatusBarsSystem, constantAnimationSystem, healthSpawningSystem]
    }
}
