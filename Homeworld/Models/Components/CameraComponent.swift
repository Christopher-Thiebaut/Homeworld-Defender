//
//  CameraComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/27/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class CameraComponent: GKComponent {
    
    let camera: SKCameraNode
    let scene: SKScene
    let spriteNode: SKSpriteNode
    
    init(spriteNodeToFollow: SKSpriteNode, scene: SKScene){
        self.camera = SKCameraNode()
        self.scene = scene
        self.spriteNode = spriteNodeToFollow
        scene.camera = camera
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
//    deinit {
//        //If the scene's camera is this component's camera, put a new camera back in the middle of the scene when this one's camera
//        if scene.camera == camera {
//            scene.camera = SKCameraNode()
//            scene.camera?.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
//        }
//    }
    
    override func update(deltaTime seconds: TimeInterval) {
        camera.position = spriteNode.position
    }
    
}
