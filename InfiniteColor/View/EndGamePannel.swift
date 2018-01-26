//
//  EndGamePannel.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 25/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import SpriteKit

class EndGamePannel: SKSpriteNode {
    func initialize(withScore score: Int) {
        createPannel()
        createTextLabel()
        createScoreLabel(withScore: score)
        createQuitLabel()
    }
    
    func createPannel() {
        self.name = "EndGamePannel"
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = CGPoint(x: 0, y: 0)
        self.size = CGSize(width: 750, height: 1334)
        self.zPosition = ZPositionService.shared.endGame
        self.color = SKColor.black
        self.alpha = 0.8
    }
    
    func createTextLabel() {
        let endGameLabel = SKLabelNode()
        endGameLabel.name = "EGPTextLabel"
        endGameLabel.position = CGPoint(x: 0, y: 50)
        endGameLabel.fontSize = 120
        endGameLabel.fontColor = SKColor.white
        endGameLabel.alpha = 0.8
        endGameLabel.text = "Game Over"
        self.addChild(endGameLabel)
    }
    
    func createScoreLabel(withScore score: Int) {
        let endGameScoreLabel = SKLabelNode()
        endGameScoreLabel.name = "EGPScoreLabel"
        endGameScoreLabel.position = CGPoint(x: 0, y: 300)
        endGameScoreLabel.fontSize = 120
        endGameScoreLabel.fontColor = SKColor.white
        endGameScoreLabel.alpha = 0.8
        endGameScoreLabel.text = "\(score)"
        self.addChild(endGameScoreLabel)
    }
    
    func createQuitLabel() {
        let endGameQuitLabel = SKLabelNode()
        endGameQuitLabel.name = "EGPQuitLabel"
        endGameQuitLabel.position = CGPoint(x: 0, y: -200)
        endGameQuitLabel.fontSize = 90
        endGameQuitLabel.fontColor = SKColor.white
        endGameQuitLabel.alpha = 0.6
        endGameQuitLabel.text = "Tap to quit"
        self.addChild(endGameQuitLabel)
    }
}

