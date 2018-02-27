//
//  ButtonNode.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/27/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonNode: SKSpriteNode {
    
    let buttonAction: () -> ()
    
    init(texture: SKTexture, size: CGSize, action: @escaping () -> ()){
        buttonAction = action
        super.init(texture: texture, color: SKColor.white, size: size)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonAction()
    }
    
}
