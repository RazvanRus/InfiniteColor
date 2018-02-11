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
        createEndGamePannel()
        createTextLabel()
        createScoreLabel(withScore: score)
        createQuitButton()
 //       if ReviveGameService.shared.canPlayerBeRevived { createReviveButton() }
    }
    
    func createEndGamePannel() {
        self.name = "EndGamePannel"
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = CGPoint(x: 0, y: 0)
        self.size = CGSize(width: 750, height: 1334)
        self.zPosition = 10
        self.color = SKColor.black
        self.alpha = 0.85
    }
    
    func createTextLabel() {
        let textLabel = SKLabelNode()
        textLabel.name = "EGPTextLabel"
        textLabel.position = CGPoint(x: 0, y: 400)
        textLabel.text = "Game Over"
        
        textLabel.fontName = "AvenirNext-Regular"
        textLabel.fontSize = 100
        textLabel.fontColor = SKColor.white
        textLabel.alpha = 0.65
        
        self.addChild(textLabel)
    }
    
    func createScoreLabel(withScore score: Int) {
        let scoreTextLabel = SKLabelNode()
        scoreTextLabel.name = "EGPScorTextLabel"
        scoreTextLabel.position = CGPoint(x: 0, y: 75)
        scoreTextLabel.text = "Score"
        scoreTextLabel.fontName = "AvenirNext-Regular"
        scoreTextLabel.fontSize = 70
        scoreTextLabel.fontColor = SKColor.white
        scoreTextLabel.horizontalAlignmentMode = .center
        scoreTextLabel.verticalAlignmentMode = .center
        scoreTextLabel.alpha = 1
        
        let scoreLabel = SKLabelNode()
        scoreLabel.name = "EGPScoreLabel"
        scoreLabel.position = CGPoint(x: 0, y: 150)
        scoreLabel.text = "\(score)"
        scoreLabel.fontName = "AvenirNext-DemiBold"
        scoreLabel.fontSize = 100
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.alpha = 0.65
        
        self.addChild(scoreLabel)
        scoreLabel.addChild(scoreTextLabel)
        
        if score >= GameService.shared.getHighscore() { createNewHighscoreTextLabel(forLabel: scoreLabel)}
    }
    
    func createNewHighscoreTextLabel(forLabel scoreLabel: SKLabelNode) {
        let newHighscoreLabel = SKLabelNode()
        newHighscoreLabel.name = "EGPNewHighscoreLabel"
        newHighscoreLabel.position = CGPoint(x: 0, y: -60)
        newHighscoreLabel.text = "Highscore"
        
        newHighscoreLabel.fontName = "AvenirNext-Regular"
        newHighscoreLabel.fontSize = 35
        newHighscoreLabel.fontColor = SKColor.white
        newHighscoreLabel.horizontalAlignmentMode = .center
        newHighscoreLabel.verticalAlignmentMode = .center
        newHighscoreLabel.alpha = 1
        
        scoreLabel.addChild(newHighscoreLabel)
    }
    
    func createQuitButton() {
        let quitButton = SKLabelNode()
        quitButton.name = "EGPQuitButton"
        quitButton.position = CGPoint(x: -10, y: -400)
        quitButton.text = "Tap to quit"

        quitButton.fontName = "AvenirNext-Regular"
        quitButton.fontSize = 90
        quitButton.fontColor = SKColor.white
        quitButton.alpha = 0.65
        
        self.addChild(quitButton)
        animation(quitButton)
    }
    
    func animation(_ button: SKLabelNode) {
        let part1 = SKAction.run { button.text = "Tap to quit."; button.position.x += 9.5 }
        let wait1 = SKAction.wait(forDuration: TimeInterval(0.4))
        let part2 = SKAction.run { button.text = "Tap to quit.."; button.position.x += 11.5 }
        let wait2 = SKAction.wait(forDuration: TimeInterval(0.4))
        let part3 = SKAction.run { button.text = "Tap to quit"; button.position.x = -10 }
        let wait3 = SKAction.wait(forDuration: TimeInterval(0.4))

        let sequence = SKAction.sequence([wait1,part1,wait2,part2,wait3,part3])
        let repeatAction = SKAction.repeatForever(sequence)
        
        button.run(repeatAction)
    }
    
    func createReviveButton() {
        let reviveButtonPart1 = SKLabelNode()
        reviveButtonPart1.name = "EGPReviveButton"
        reviveButtonPart1.position = CGPoint(x: 0, y: -165)
        reviveButtonPart1.text = "Tap to"
        
        reviveButtonPart1.fontName = "AvenirNext-Regular"
        reviveButtonPart1.fontSize = 90
        reviveButtonPart1.fontColor = SKColor.white
        reviveButtonPart1.alpha = 0.65
        
        self.addChild(reviveButtonPart1)
        
        let reviveButtonPart2 = SKLabelNode()
        reviveButtonPart2.name = "EGPReviveButton"
        reviveButtonPart2.position = CGPoint(x: 0, y: -70)
        reviveButtonPart2.text = "revive"
        
        reviveButtonPart2.fontName = "AvenirNext-Regular"
        reviveButtonPart2.fontSize = 90
        reviveButtonPart2.fontColor = SKColor.white
        reviveButtonPart2.alpha = 1
        
        reviveButtonPart1.addChild(reviveButtonPart2)
    }
    
    
    
    
    
    // MARK: NOT USED!!
    func createNewHigherComboLabel(withCombo combo: Int) {
        let highestComboLabel = SKLabelNode()
        highestComboLabel.name = "EGPHighestComboLabel"
        highestComboLabel.position = CGPoint(x: 0, y: 300)
        highestComboLabel.text = "x\(combo)"
        
        highestComboLabel.fontName = "AvenirNext-DemiBold"
        highestComboLabel.fontSize = 100
        highestComboLabel.fontColor = SKColor.white
        highestComboLabel.alpha = 0.65
        
        self.addChild(highestComboLabel)
        
        let newHighestComboLabel = SKLabelNode()
        newHighestComboLabel.name = "EGPNewHighestComboLabel"
        newHighestComboLabel.position = CGPoint(x: 0, y: 250)
        newHighestComboLabel.text = "New Highest Combo"
        
        newHighestComboLabel.fontName = "AvenirNext-Regular"
        newHighestComboLabel.fontSize = 70
        newHighestComboLabel.fontColor = SKColor.white
        newHighestComboLabel.alpha = 0.65
        
        self.addChild(newHighestComboLabel)
    }
}


