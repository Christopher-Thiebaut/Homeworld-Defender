//
//  SettingsScene.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/21/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import SpriteKit

class SettingsScene: SKScene {
    
    var selectedDifficulty: Difficulty.DifficultyLevel = .medium {
        didSet {
            UserData.currentUser.preferredDifficulty = selectedDifficulty
            for label in difficultyLabels {
                label.fontColor = .white
            }
            switch selectedDifficulty {
            case .easy:
                easyDifficultyLabel.fontColor = .red
            case .medium:
                mediumDifficultyLabel.fontColor = .red
            case .hard:
                hardDifficultyLabel.fontColor = .red
            case .madness:
                madnessDifficultyLabel.fontColor = .red
            }
        }
    }
    
    let easyDifficultyLabel = SKLabelNode(fontNamed: "VT323")
    let mediumDifficultyLabel = SKLabelNode(fontNamed: "VT323")
    let hardDifficultyLabel = SKLabelNode(fontNamed: "VT323")
    let madnessDifficultyLabel = SKLabelNode(fontNamed: "VT323")
    
    lazy var difficultyLabels: [SKLabelNode] = [easyDifficultyLabel, mediumDifficultyLabel, hardDifficultyLabel, madnessDifficultyLabel]
    
    override func didMove(to view: SKView) {
        
        
        let sceneTitle = SKLabelNode(fontNamed: "VT323")
        sceneTitle.text = "Settings"
        sceneTitle.position = CGPoint(x: size.width/2, y: size.height/1.3)
        sceneTitle.fontSize = 50
        addChild(sceneTitle)
        
        let labelParent = SKNode()
        
        var totalLabelsWidth: CGFloat = 0
        
        easyDifficultyLabel.text = "EASY"
        mediumDifficultyLabel.text = "MEDIUM"
        hardDifficultyLabel.text = "HARD"
        madnessDifficultyLabel.text = "MADNESS"
        
        for label in difficultyLabels {
            label.fontSize = 30
            totalLabelsWidth += label.frame.width
        }
        
        var difficultyButtons: [ButtonNode] = []
        
        let easyButton = ButtonNode(label: easyDifficultyLabel, action: {[weak self] in self?.selectedDifficulty = .easy})
        difficultyButtons.append(easyButton)
        let mediumButton = ButtonNode(label: mediumDifficultyLabel, action: {[weak self] in self?.selectedDifficulty = .medium})
        difficultyButtons.append(mediumButton)
        let hardButton = ButtonNode(label: hardDifficultyLabel, action: {[weak self] in self?.selectedDifficulty = .hard})
        difficultyButtons.append(hardButton)
        let madnessButton = ButtonNode(label: madnessDifficultyLabel, action: {[weak self] in self?.selectedDifficulty = .madness})
        difficultyButtons.append(madnessButton)
        
        var nextButtonLeftEdge = totalLabelsWidth/2
        
        for button in difficultyButtons {
            let buttonFrame = button.calculateAccumulatedFrame()
            button.position.x = nextButtonLeftEdge + buttonFrame.width/2
            nextButtonLeftEdge += buttonFrame.width + 20
            labelParent.addChild(button)
        }
        labelParent.position = CGPoint(x: 0, y: size.height/2)
        addChild(labelParent)
        
        let returnToMenuLabel = SKLabelNode(fontNamed: "VT323")
        returnToMenuLabel.text = "RETURN TO MENU"
        returnToMenuLabel.fontColor = .red
        returnToMenuLabel.fontSize = 30
        
        let returnToMenuButton = ButtonNode(label: returnToMenuLabel, action: {[weak self] in self?.goToMenu()})
        returnToMenuButton.position = CGPoint(x: size.width/2, y: size.height/4)
        addChild(returnToMenuButton)
        
        selectedDifficulty = UserData.currentUser.preferredDifficulty
        
    }
    
    func goToMenu() {
        guard let view = view else {
            return
        }
        let menu = MainMenuScene(size: view.frame.size)
        view.contentMode = .scaleAspectFill
        view.presentScene(menu)
    }
    
}
