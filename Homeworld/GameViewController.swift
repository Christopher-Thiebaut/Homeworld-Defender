//
//  GameViewController.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/24/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    //TODO: Adjust scaling so the scene's size is actually wider than the visible area.  Wrapping should be based on a smaller area.  Maybe have some 'mirrored' areas on each side
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        let mainMenu = MainMenuScene(size: CGSize(width: view.frame.width, height: view.frame.height))
        mainMenu.scaleMode = .aspectFill
        skView.presentScene(mainMenu)
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
