//
//  EndGamePannel.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 25/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import SpriteKit
import Appodeal

class EndGamePannel: SKSpriteNode {
    func initialize(withScore score: Int, andCombo combo: Int) {
        createEndGamePannel()
        createTextLabel()
        createScoreLabel(withScore: score)
        createComboLabel(withCombo: combo)
        createQuitButton()
        if ReviveGameService.shared.canPlayerBeRevived && Appodeal.isReadyForShow(with: .rewardedVideo) { createReviveButton() }
    }
    
    func createEndGamePannel() {
        self.name = "EndGamePannel"
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = CGPoint(x: 0, y: 0)
        self.size = CGSize(width: 750, height: 1334)
        self.zPosition = ZPositionService.shared.endGame
        self.color = SKColor.black
        self.alpha = 0.9
    }
    
    func createTextLabel() {
        let textLabel = SKLabelNode()
        textLabel.name = "EGPTextLabel"
        textLabel.position = CGPoint(x: 0, y: 450)
        textLabel.text = "Game Over"
        
        textLabel.fontName = "AvenirNext-Regular"
        textLabel.fontSize = 100
        textLabel.fontColor = SKColor.white
        textLabel.alpha = 0.65
        
        self.addChild(textLabel)
        //animation(forTextLabel: textLabel)
    }
    
    func animation(forTextLabel label: SKLabelNode) {
        let part1 = SKAction.run { label.text = "Game"; label.position.x = -128 }
        //let part2 = SKAction.run { label.text = "Over"; label.position.x = 152 }
        let part3 = SKAction.run { label.text = "Game Over"; label.position.x = 0 }
        let part4 = SKAction.run { label.text = "" }
        let wait1 = SKAction.wait(forDuration: TimeInterval(0.5))
        let wait2 = SKAction.wait(forDuration: TimeInterval(0.25))

        let sequence = SKAction.sequence([wait2,part1,wait2,part3,wait2,part1,wait2,part3,wait1,part4,wait2,part3])
        let repeatAction = SKAction.repeatForever(sequence)
        
        label.run(repeatAction)
    }
 
    func createScoreLabel(withScore score: Int) {
        let scoreTextLabel = SKLabelNode()
        scoreTextLabel.name = "EGPScorTextLabel"
        scoreTextLabel.position = CGPoint(x: 0, y: 70)
        scoreTextLabel.text = "Score"
        scoreTextLabel.fontName = "AvenirNext-Regular"
        scoreTextLabel.fontSize = 70
        scoreTextLabel.fontColor = SKColor.white
        scoreTextLabel.horizontalAlignmentMode = .center
        scoreTextLabel.verticalAlignmentMode = .center
        scoreTextLabel.alpha = 1
        
        let scoreLabel = SKLabelNode()
        scoreLabel.name = "EGPScoreLabel"
        scoreLabel.position = CGPoint(x: -150, y: 200)
        scoreLabel.text = "\(score)"
        scoreLabel.fontName = "AvenirNext-DemiBold"
        scoreLabel.fontSize = 100
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.alpha = 0.65
        
        self.addChild(scoreLabel)
        scoreLabel.addChild(scoreTextLabel)
        
        if score >= GameService.shared.getHighscore() { createNewHighscoreTextLabel(forLabel: scoreLabel) }
    }
    
    func createNewHighscoreTextLabel(forLabel scoreLabel: SKLabelNode) {
        let newHighscoreLabel = SKLabelNode()
        newHighscoreLabel.name = "EGPNewHighscoreLabel"
        newHighscoreLabel.position = CGPoint(x: 0, y: -60)
        newHighscoreLabel.text = "Highscore"
        
        newHighscoreLabel.fontName = "AvenirNext-Regular"
        newHighscoreLabel.fontSize = 38
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

        quitButton.fontName = "AvenirNext-Medium"
        quitButton.fontSize = 90
        quitButton.fontColor = SKColor.white
        quitButton.alpha = 0.65
        
        self.addChild(quitButton)
        animation(forQuitButton: quitButton)
    }
    
    func animation(forQuitButton button: SKLabelNode) {
        let part1 = SKAction.run { button.text = "Tap to quit."; button.position.x += 9.5 }
        let part2 = SKAction.run { button.text = "Tap to quit.."; button.position.x += 11.5 }
        let part3 = SKAction.run { button.text = "Tap to quit"; button.position.x = -10 }
        let wait = SKAction.wait(forDuration: TimeInterval(0.4))

        let sequence = SKAction.sequence([wait,part1,wait,part2,wait,part3])
        let repeatAction = SKAction.repeatForever(sequence)
        
        button.run(repeatAction)
    }
    
    func createReviveButton() {
        let reviveHolder = SKSpriteNode(imageNamed: "ffffffCircle")
        reviveHolder.size = CGSize(width: 250, height: 250)
        reviveHolder.position = CGPoint(x: 0, y: -110)
        reviveHolder.name = "EGPReviveButton"
        reviveHolder.colorBlendFactor = 1
        reviveHolder.color = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.75)
//        reviveHolder.color = .lightGray
        reviveHolder.alpha = 0.9
        reviveHolder.zPosition = self.zPosition+1
        
        
        let reviveButtonPart1 = SKLabelNode()
        reviveButtonPart1.name = "EGPReviveButton"
        reviveButtonPart1.position = CGPoint(x: 0, y: 0)
        reviveButtonPart1.text = "Revive"
        
        reviveButtonPart1.fontName = "AvenirNext-Medium"
        reviveButtonPart1.fontSize = 65
        reviveButtonPart1.fontColor = SKColor.black
        reviveButtonPart1.alpha = 1
        reviveButtonPart1.verticalAlignmentMode = .center
        reviveButtonPart1.horizontalAlignmentMode = .center
        reviveButtonPart1.zPosition = self.zPosition+1
        
        reviveHolder.addChild(reviveButtonPart1)
        self.addChild(reviveHolder)
    }
    
    func createComboLabel(withCombo combo: Int) {
        let comboTextLabel = SKLabelNode()
        comboTextLabel.name = "EGPComboTextLabel"
        comboTextLabel.position = CGPoint(x: 0, y: 65)
        comboTextLabel.text = "Combo"
        comboTextLabel.fontName = "AvenirNext-Regular"
        comboTextLabel.fontSize = 53
        comboTextLabel.fontColor = SKColor.white
        comboTextLabel.horizontalAlignmentMode = .center
        comboTextLabel.verticalAlignmentMode = .center
        comboTextLabel.alpha = 1
        
        let comboLabel = SKLabelNode()
        comboLabel.name = "EGPComboLabel"
        comboLabel.position = CGPoint(x: 150, y: 205)
        comboLabel.text = "x\(combo)"
        comboLabel.fontName = "AvenirNext-DemiBold"
        comboLabel.fontSize = 100
        comboLabel.fontColor = SKColor.white
        comboLabel.horizontalAlignmentMode = .center
        comboLabel.verticalAlignmentMode = .center
        comboLabel.alpha = 0.65
        
        self.addChild(comboLabel)
        comboLabel.addChild(comboTextLabel)
        
        if combo >= GameService.shared.getHighestCombo() { createNewHighestComboLabel(forLabel: comboLabel); comboTextLabel.position.y = -60 }
    }
    
    func createNewHighestComboLabel(forLabel comboLabel: SKLabelNode) {
        let newHighestComboLabel = SKLabelNode()
        newHighestComboLabel.name = "EGPNewHighestComboLabel"
        newHighestComboLabel.position = CGPoint(x: 0, y: 60)
        newHighestComboLabel.text = "Highest"
        
        newHighestComboLabel.fontName = "AvenirNext-Regular"
        newHighestComboLabel.fontSize = 50
        newHighestComboLabel.fontColor = SKColor.white
        newHighestComboLabel.horizontalAlignmentMode = .center
        newHighestComboLabel.verticalAlignmentMode = .center
        newHighestComboLabel.alpha = 1
        
        comboLabel.addChild(newHighestComboLabel)
    }
}



