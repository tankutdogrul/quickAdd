//
//  GameViewController.swift
//  quickAdd iOS
//
//  Created by Tankut Dogrul on 22.01.2025.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDifficultyPopup), name: NSNotification.Name("ShowDifficultyPopup"), object: nil)
               
               // Load the initial scene
               if let scene = GameScene(fileNamed: "GameScene") {
                   let skView = self.view as! SKView
                   skView.presentScene(scene)
                   skView.ignoresSiblingOrder = true
                   skView.showsFPS = true
                   skView.showsNodeCount = true
               }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    @objc func showDifficultyPopup() {
            // Create the alert controller
            let alertController = UIAlertController(title: "Select Difficulty", message: nil, preferredStyle: .alert)
            
            // Add actions for each difficulty
            let easyAction = UIAlertAction(title: "Easy", style: .default) { _ in
                self.setDifficulty("easy")
            }
            let mediumAction = UIAlertAction(title: "Medium", style: .default) { _ in
                self.setDifficulty("medium")
            }
            let hardAction = UIAlertAction(title: "Hard", style: .default) { _ in
                self.setDifficulty("hard")
            }
            
            // Add the actions to the alert controller
            alertController.addAction(easyAction)
            alertController.addAction(mediumAction)
            alertController.addAction(hardAction)
            
            // Present the alert
            present(alertController, animated: true)
        }

        func setDifficulty(_ level: String) {
            if let skView = self.view as? SKView,
               let gameScene = skView.scene as? GameScene {
                gameScene.setDifficulty(level)
            }
        }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}
