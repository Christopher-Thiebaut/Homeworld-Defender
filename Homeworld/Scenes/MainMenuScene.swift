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
        
        let highScoreLabel = SKLabelNode(fontNamed: "VT323")
        highScoreLabel.text = "HIGH SCORE: \(UserData.currentUser.highScore)"
        highScoreLabel.fontSize = 20
        highScoreLabel.fontColor = .white
        highScoreLabel.position = CGPoint(x: size.width/2, y: size.height - highScoreLabel.frame.height)
        addChild(highScoreLabel)
        
        let playLabel = SKLabelNode(fontNamed: "VT323")
        playLabel.text = "PLAY"
        playLabel.fontColor = .red
        playLabel.fontSize = 30
        
        let playButtonNode = ButtonNode(label: playLabel) { [weak self] in
            self?.launchNextLevel()
        }
        playButtonNode.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(playButtonNode)
        
        let settingsLabel = SKLabelNode(fontNamed: "VT323")
        settingsLabel.text = "SETTINGS"
        settingsLabel.fontColor = .red
        settingsLabel.fontSize = 30
        
        let settingsButtonNode = ButtonNode(label: settingsLabel, action: {[weak self] in self?.launchSettings()})
        settingsButtonNode.position = CGPoint(x: size.width/2, y: size.height/4)
        addChild(settingsButtonNode)
        
        backgroundColor = .black
    }
    
    //This is a temporary implementation as there is currently only one level.
    func launchNextLevel() {
        guard let view = view else {
            NSLog("There is no SKView available to configure or present the next level. ")
            return
        }
        let aspectRatio = view.bounds.width / view.bounds.height
        let gamePlayAreaSize = CGSize(width: 2000, height: 1200)
        let difficulty = UserData.currentUser.preferredDifficulty
        let scene = GameScene(
            sceneEditorNode: SKNode(fileNamed: "LevelOne"),
            visibleSize: CGSize(width: 640 * aspectRatio, height: 640),
            gamePlayAreaSize: gamePlayAreaSize,
            entityController: EntityControllerImp(difficulty: difficulty),
            levelParser: LevelNodeParserImp(factory: SceneEditorFactoryImp()),
            player: HumanFighter.self
        )
//        view.showsFPS = true
        //skView.showsPhysics = true
//        view.showsNodeCount = true
        view.ignoresSiblingOrder = true
//        view.showsDrawCount = true
        scene.scaleMode = .aspectFill
        view.presentScene(scene)
    }
    
    func launchSettings() {
        guard let view = view else {
            NSLog("There is no SKView available to configure or present the settings scene ")
            return
        }
        let scene = SettingsScene(size: CGSize(width: view.frame.width, height: view.frame.height))
        scene.scaleMode = .aspectFill
        view.presentScene(scene)
    }

}
