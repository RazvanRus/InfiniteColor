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
        getHighscore()
        AudioService.shared.turnDownBackgroundSound()
    }
    
    func getHighscore() {
        let highscoreLabel = self.childNode(withName: "HighscoreLabel") as? SKLabelNode
        highscoreLabel?.text = "\(GameService.shared.getHighscore())"
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
            if IphoneTypeService.shared.isIphoneX() { gameplayScene.scaleMode = .aspectFill }
            else { gameplayScene.scaleMode = .aspectFill }
            self.view?.presentScene(gameplayScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
        }
    }
}
