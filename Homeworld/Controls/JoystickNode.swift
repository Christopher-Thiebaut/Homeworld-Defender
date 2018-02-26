//
//  ThumbStickNode.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit

class JoystickNode: SKSpriteNode {
    
    //MARK: - Properties
    
    /// The visual representation of the joystick the player can move around.
    var touchPad: SKSpriteNode
    
    /// The center of the joystick
    let center: CGPoint
    
    let trackingDistance: CGFloat
    
    var isPressed: Bool = false
    
    var distanceOffCenter: CGFloat = 0
    
    init(size: CGSize){
        trackingDistance = size.width/2
        
        let touchPadLength = size.width / 2.2
        center = CGPoint(x: size.width/2 - touchPadLength, y: size.height/2 - touchPadLength)
        
        let touchPadTexture = SKTexture(image: #imageLiteral(resourceName: "ControlPad"))
        let touchPadSize = CGSize(width: touchPadLength, height: touchPadLength)
        
        touchPad = SKSpriteNode(texture: touchPadTexture, color: UIColor.black, size: touchPadSize)
        
        super.init(texture: touchPadTexture, color: .clear, size: size)
        
        addChild(touchPad)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIResponder
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isPressed = true
        //TODO: Potentially manipulate apearance so that the user can tell the joystick is selected.
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            var dx = touchLocation.x - center.x
            var dy = touchLocation.y - center.y
            
            let distance = hypot(dx, dy)
            
            if distance > trackingDistance {
                dx = (dx / distance) * trackingDistance
                dy = (dx / distance) * trackingDistance
            }
            
            touchPad.position = CGPoint(x: center.x + dx, y: center.y + dy)
            
            //Normalize the distance between 0 and 1
            let normalizedDistance = min(abs(distance)/trackingDistance, 1)
            distanceOffCenter = normalizedDistance
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard !touches.isEmpty else { return }
        
        reset()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        reset()
    }
    
    func reset(){
        let restoreToCenter = SKAction.move(to: CGPoint.zero, duration: 0.2)
        touchPad.run(restoreToCenter)
        
        isPressed = false
        distanceOffCenter = 0
    }
}

extension JoystickNode : PropulsionControl {
    
    var thrustMagnitude: CGFloat {
        return 2000    }
    
    func shouldApplyThrust() -> Bool {
        return isPressed && distanceOffCenter > 0
    }
    
    func magnitude() -> CGFloat {
        return distanceOffCenter * thrustMagnitude
    }
    
}
