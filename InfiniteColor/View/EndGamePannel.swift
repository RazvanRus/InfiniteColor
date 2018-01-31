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
        self.name = "EndGamePannel"
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = CGPoint(x: 0, y: 0)
        self.size = CGSize(width: 750, height: 1334)
        self.zPosition = 10
        self.color = SKColor.black
        self.alpha = 0.8
        
        
        let endGameLabel = SKLabelNode()
        endGameLabel.name = "EndGamePannelLabel"
        endGameLabel.position = CGPoint(x: 0, y: 150)
        endGameLabel.fontSize = 120
        endGameLabel.fontColor = SKColor.white
        endGameLabel.alpha = 0.8
        endGameLabel.text = "Game Over"
        self.addChild(endGameLabel)
        
        let endGameScoreLabel = SKLabelNode()
        endGameScoreLabel.name = "EndGameScoreLabel"
        endGameScoreLabel.position = CGPoint(x: 0, y: 400)
        endGameScoreLabel.fontSize = 120
        endGameScoreLabel.fontColor = SKColor.white
        endGameScoreLabel.alpha = 0.8
        endGameScoreLabel.text = "\(score)"
        self.addChild(endGameScoreLabel)
        
        let endGameQuitLabel = SKLabelNode()
        endGameQuitLabel.name = "EndGamePannelQuitLabel"
        endGameQuitLabel.position = CGPoint(x: 0, y: -350)
        endGameQuitLabel.fontSize = 90
        endGameQuitLabel.fontColor = SKColor.white
        endGameQuitLabel.alpha = 0
        endGameQuitLabel.text = "Tap to quit"
        self.addChild(endGameQuitLabel)
        
        let initialFadeIn = SKAction.fadeAlpha(to: 0.6, duration: 0.5)
        
        let fadeIn = SKAction.fadeAlpha(to: 0.6, duration: 1)
        let fadeOut = SKAction.fadeAlpha(to: 0.2, duration: 1)
        
        let sequence = SKAction.sequence([fadeOut,fadeIn])
        let repeatFade = SKAction.repeatForever(sequence)
        
        endGameQuitLabel.run(SKAction.sequence([initialFadeIn,repeatFade]), withKey: "FadeAction")
        
        let endGameReviveLabel = SKLabelNode()
        endGameReviveLabel.name = "EndGameReviveLabel"
        endGameReviveLabel.position = CGPoint(x: 0, y: -50)
        endGameReviveLabel.fontSize = 90
        endGameReviveLabel.fontColor = SKColor.white
        endGameReviveLabel.alpha = 0.6
        endGameReviveLabel.text = "Tap to revive"
        
        if ReviveGameService.shared.canPlayerBeRevived {
            self.addChild(endGameReviveLabel)
        }
    }
}


