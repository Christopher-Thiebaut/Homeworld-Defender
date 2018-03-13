//
//  RotationAnimationComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/12/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class AnimatedComponent: GKComponent {
    
    let spriteAtlas: SKTextureAtlas
    var frames: [SKTexture] = []
    private let upperHalf: [Range<CGFloat>]
    
    init(spriteAtlas: SKTextureAtlas){
        self.spriteAtlas = spriteAtlas
        for index in 0..<spriteAtlas.textureNames.count{
            frames.append(spriteAtlas.textureNamed("\(index + 1)"))
        }
        upperHalf = AnimatedComponent.assignRotationFrames(numberOfFrames: frames.count)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static func assignRotationFrames(numberOfFrames: Int) -> [Range<CGFloat>] {
        let frameSpace = CGFloat.pi / CGFloat(numberOfFrames)
        
        var frameRanges: [Range<CGFloat>] = []
        
        var lastFrameEnd = -frameSpace/2
        
        while frameRanges.count < numberOfFrames {
            frameRanges.append(lastFrameEnd..<lastFrameEnd+frameSpace)
            lastFrameEnd += frameSpace
        }
        return frameRanges
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        guard let spriteNode = entity?.component(ofType: SpriteComponent.self)?.node else {
            NSLog("Cannot animate rotation for node with no sprite component.")
            return
        }
        
        var xScale: CGFloat
        var yScale: CGFloat
        
        if let texture = spriteNode.texture {
            xScale = spriteNode.size.width/texture.size().width
            yScale = spriteNode.size.height/texture.size().height
        }else{
            xScale = 1
            yScale = 1
        }
        
        let rotation = spriteNode.zRotation
        
        if rotation >= 0 {
            for index in 0..<upperHalf.count {
                if upperHalf[index].contains(rotation){
                    spriteNode.texture = frames[index]
                }
            }
        }else{
            for index in 0..<upperHalf.count {
                if upperHalf[index].contains(rotation + CGFloat.pi) {
                    spriteNode.texture = frames[frames.count - 1 - index]
                }
            }
        }
        
        if let texture = spriteNode.texture {
            spriteNode.size = CGSize.init(width: texture.size().width * xScale, height: texture.size().height * yScale)
        }
    }
    
}
