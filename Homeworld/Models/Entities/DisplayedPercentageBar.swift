//
//  DisplayedHealthBar.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/16/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class DisplayedPercentageBar: GKEntity {
    
    let quantity: PercentageBarQuantity
    
    init(initialSize: CGSize, color: UIColor, backgroundColor: UIColor, initialPosition: CGPoint, quantityToMonitor: PercentageBarQuantity){
        self.quantity = quantityToMonitor
        
        super.init()
        
        let percentageBarComponent = PercentageBarComponent(initialSize: initialSize, initialPosition: initialPosition, color: color, backgroundColor: backgroundColor, quantityToMonitor: quantity)
        addComponent(percentageBarComponent)
        
        let spriteComponent = SpriteComponent(spriteNode: percentageBarComponent.sprite)
        addComponent(spriteComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
