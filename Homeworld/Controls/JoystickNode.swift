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
    var ball: SKSpriteNode
    
    var rod: SKSpriteNode
    
    /// The center of the joystick
    let center: CGPoint
    
    let trackingDistance: CGFloat
    
    var distanceOffCenter: CGFloat = 0
    
    //The angle between the most extreme right (no vertical displacement) position of the joystick and its current position.
    var joystickAngle: CGFloat
    
    init(size: CGSize){
        trackingDistance = size.width/1.5
        
        let ballLength = size.width / 2.2
        center = CGPoint(x: 0, y: 0)
        //center = CGPoint(x: size.width/2 - ballLength, y: size.height/2 - ballLength)
        
        let ballTexture = SKTexture(image: #imageLiteral(resourceName: "red_button"))
        let ballSize = CGSize(width: ballLength, height: ballLength)
        
        
        ball = SKSpriteNode(texture: ballTexture, color: UIColor.black, size: ballSize)
        ball.zPosition = 0.5
        
        joystickAngle = 0
        
        let rodTexture = SKTexture(image: #imageLiteral(resourceName: "joystick_rod"))
        let rodSize = CGSize(width: ballLength/5, height: ballLength/5)
        rod = SKSpriteNode(texture: rodTexture, color: .black, size: rodSize)
        rod.zRotation = joystickAngle
        rod.zPosition = 0.25
        
        let baseTexture = SKTexture(image: #imageLiteral(resourceName: "joystick_base"))
        super.init(texture: baseTexture, color: .clear, size: size)
        
        addChild(ball)
        addChild(rod)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
                dy = (dy / distance) * trackingDistance
            }
            
            ball.position = CGPoint(x: center.x + dx, y: center.y + dy)
            
            
            //Normalize the distance between 0 and 1
            let normalizedDistance = min(abs(distance)/trackingDistance, 1)
            
            //Set the distance off center
            distanceOffCenter = normalizedDistance
            
            //Set the joystickAngle
            joystickAngle = atan2(dy - 0, dx - 0)
            //print(joystickAngle)
            
            rod.position = CGPoint(x: (ball.position.x + center.x)/2, y: (ball.position.y + center.y)/2)
            rod.size.width = min(distance, hypot(ball.position.x - center.x, ball.position.y - center.y))
            rod.zRotation = joystickAngle
        }
    }
}

extension JoystickNode : PropulsionControl {
    
    var thrustMagnitude: CGFloat {
        return 500    }
    
    func shouldApplyThrust() -> Bool {
        return distanceOffCenter > 0
    }
    
    func magnitude() -> CGFloat {
        return distanceOffCenter * thrustMagnitude
    }
    
}

extension JoystickNode : RotationControl {
    func angle() -> CGFloat {
        return joystickAngle
    }
}
