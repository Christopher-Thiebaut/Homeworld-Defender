//
//  FieryDeath.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/19/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class FieryDeathComponent: GKComponent {
    
    let entityController: EntityController
    
    init(entityController: EntityController){
        self.entityController = entityController
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func entityDied(){
        guard let position = entity?.component(ofType: SpriteComponent.self)?.node.position else { return }
        
        let explosion = Explosion(scale: 0.5, textureAtlas: SKTextureAtlas.init(named: "explosion"), damage: 100, duration: 30, entityController: entityController)
        explosion.component(ofType: SpriteComponent.self)?.node.position = position
        
        //entityController.add(explosion)
    }
    
}
