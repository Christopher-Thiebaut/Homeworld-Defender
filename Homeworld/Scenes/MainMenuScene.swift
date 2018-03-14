//
//  MainMenuScene.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/14/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        let titleNode = SKLabelNode(fontNamed: "VT323")
        titleNode.text = "HOMEWORLD DEFENDER"
        titleNode.position = CGPoint(x: size.width/2, y: size.height/1.3)
        titleNode.fontSize = 50
        addChild(titleNode)
        
        //launchNextLevel()
        let playLabel = SKLabelNode(fontNamed: "VT323")
        playLabel.text = "PLAY"
        playLabel.fontColor = UIColor.red
        playLabel.fontSize = 30
        
        let playButtonNode = ButtonNode(label: playLabel) { [weak self] in
            self?.launchNextLevel()
        }
        playButtonNode.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(playButtonNode)
    }
    
    //TODO: This is a temporary implementation as there is currently only one level.
    func launchNextLevel() {
        guard let view = view else {
            NSLog("There is no SKView available to configure or present the next level. ")
            return
        }
        let aspectRatio = view.bounds.width / view.bounds.height
        let gamePlayAreaSize = CGSize(width: 2000, height: 800)
        let scene = GameScene(fileNamed: "LevelOne", visibleSize: CGSize(width: 640 * aspectRatio, height: 640), gamePlayAreaSize: gamePlayAreaSize, player: HumanFighter.self)
        view.showsFPS = true
        //skView.showsPhysics = true
        view.showsNodeCount = true
        view.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        view.presentScene(scene)
    }

}
