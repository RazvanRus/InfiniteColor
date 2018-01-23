//
//  MainMenuScene.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 18/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {

    override func didMove(to view: SKView) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "PlayButton" {
                presentGamePlayScene()
            }
        }
    }
    
    func presentGamePlayScene() {
        if let gameplayScene = GameplayScene(fileNamed: "GameplayScene") {
            gameplayScene.scaleMode = .aspectFill
            self.view?.presentScene(gameplayScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
        }
    }
}
