//
//  HealthBarComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/16/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

protocol PercentageBarQuantity {
    var quantityRemaining: CGFloat { get }
    var maximumQuantity: CGFloat { get }
}

class PercentageBarComponent: GKComponent {
    
    let quantityToMonitor: PercentageBarQuantity
    let bar: SKSpriteNode
    let fullSize: CGSize
    
    init(initialSize: CGSize, initialPosition: CGPoint, color: UIColor, quantityToMonitor: PercentageBarQuantity) {
        self.quantityToMonitor = quantityToMonitor
        
        let sprite = SKSpriteNode(color: color, size: initialSize)
        sprite.position = initialPosition
        self.bar = sprite
        self.fullSize = initialSize
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        let barLeadingEdge = bar.position.x - bar.size.width/2
        
        let newWidth = ceil(quantityToMonitor.quantityRemaining/quantityToMonitor.maximumQuantity * fullSize.width)
        bar.size.width = newWidth > 0 ? newWidth : 0
        bar.position.x = barLeadingEdge + newWidth/2
    }
    
}
