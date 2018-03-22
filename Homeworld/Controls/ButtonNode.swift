//
//  ButtonNode.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/27/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonNode: SKNode {
    
    var buttonAction: (() -> ())?
    
    var size: CGSize {
        return self.calculateAccumulatedFrame().size
    }
    
    var repeatActionOnHold: Bool = false
    
    init(texture: SKTexture, size: CGSize, action: @escaping () -> () ){
        buttonAction = action
        super.init()
        let textureNode = SKSpriteNode(texture: texture, color: SKColor.white, size: size)
        self.addChild(textureNode)
        //super.init(texture: texture, color: SKColor.white, size: size)
        isUserInteractionEnabled = true
    }
    
    init(texture: SKTexture, size: CGSize){
        super.init()
        let textureNode = SKSpriteNode(texture: texture, color: SKColor.white, size: size)
        self.addChild(textureNode)
        isUserInteractionEnabled = true
    }
    
    init(label: SKLabelNode, action: @escaping () -> () ){
        super.init()
        self.addChild(label)
        self.buttonAction = action
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let action = buttonAction else {return}
        if repeatActionOnHold {
            run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.05), SKAction.run {
                action()
                }])))
        }else{
            action()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeAllActions()
    }
    
}
