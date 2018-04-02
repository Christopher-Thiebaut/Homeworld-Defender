//
//  SpriteComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class SpriteComponent: GKComponent {
    
    let node: SKSpriteNode
    
    init(texture: SKTexture, color: UIColor = .white, size: CGSize) {
        node = SKSpriteNode(texture: texture, color: color, size: size)
        super.init()
    }
    
    init(spriteNode: SKSpriteNode, color: UIColor = .white) {
        node = spriteNode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///Returns true if this SpriteComponents node is the provided node or if the provided node is in its node's child tree.
    func hasSprite(node: SKSpriteNode) -> Bool {
        return nodeHasNode(node1: self.node, node2: node)
    }
    
    //Traverses node1's child tree in search of node2. Returns true if it finds it, false otherwise.
    private func nodeHasNode(node1: SKSpriteNode, node2: SKSpriteNode) -> Bool {

        if node1.isEqual(to: node2) {
            return true
        }
        for node in node1.children.filter({$0 is SKSpriteNode}) {
            if nodeHasNode(node1: node as! SKSpriteNode, node2: node2){ return true }
        }
        return false
        
    }
}
