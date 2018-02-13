//
//  MainMenuScene.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 18/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import SpriteKit
import AudioToolbox


class MainMenuScene: SKScene {
    var octogons: [Octogon] = []
    
    override func didMove(to view: SKView) {
        initialize()
    }
    
    func initialize() {
//        GameService.shared.set(bonusPoints: 654)
        OctogonService.shared.getParts()
        getMode()
        getLabels()
        createPlayButton()
        if GameService.shared.getVibrationStatus() { self.childNode(withName: "VibrationButton")?.alpha = 1 }
        else { self.childNode(withName: "VibrationButton")?.alpha = 0.4 }
        AudioService.shared.turnDownBackgroundSound()
        }
    
    func getMode() {
        GameService.shared.gameMode = .normal
        OctogonService.shared.currentParts = OctogonService.shared.normalModeParts
    }

    
    func getLabels() {
        getHighestCombo()
        getHighscore()
        getBonusPoints()
    }
    
    func getHighscore() {
        let highscoreLabel = ScoreLabel()
        highscoreLabel.initialize(withScore: "\(GameService.shared.getHighscore())", description: "Highscore", fontSize: 70)
        highscoreLabel.set(position: CGPoint(x: 0, y: 215))
        self.addChild(highscoreLabel)
        highscoreLabel.setScale(1.2)
    }
    
    func getBonusPoints() {
        let bonusPointsLabel = ScoreLabel()
        bonusPointsLabel.initialize(withScore: "\(GameService.shared.getBonusPoints())", description: "Bonus", fontSize: 48)
        bonusPointsLabel.set(position: CGPoint(x: -250, y: 0))
        bonusPointsLabel.createExtraDescriptionLabel(withText: "Points")
        self.addChild(bonusPointsLabel)
    }
    
    func getHighestCombo() {
        let highestComboLabel = ScoreLabel()
        highestComboLabel.initialize(withScore: "x\(GameService.shared.getHighestCombo())", description: "Highest", fontSize: 50)
        highestComboLabel.set(position: CGPoint(x: 260, y: 0))
        highestComboLabel.createExtraDescriptionLabel(withText: "Combo")
        self.addChild(highestComboLabel)
    }
    
    func createPlayButton() {
        let octogon = Octogon()
        octogon.setPosition(CGPoint(x: 0, y: 0))
        octogon.setSize(CGSize(width: 230, height: 230))
        octogon.initialize(spinningFactor: 1)
        octogon.instantColorize()
        octogon.name = "PlayButton"
        self.addChild(octogon)
        octogons.append(octogon)
        
        let octogon2 = Octogon()
        octogon2.setPosition(CGPoint(x: 0, y: 0))
        octogon2.setSize(CGSize(width: 150, height: 150))
        octogon2.initialize(spinningFactor: -1)
        octogon2.name = "PlayButton"
        self.addChild(octogon2)
        octogons.append(octogon2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "NoAdsButton" || atPoint(location).name == "InformationButton" {
                self.childNode(withName: "NotAvailablePanel")?.removeFromParent()
                let notAvailablePanel = NotAvailablePanel()
                notAvailablePanel.initialize()
                notAvailablePanel.animate()
                self.addChild(notAvailablePanel)
            }
            if atPoint(location).name == "PlayButton" || atPoint(location).parent?.name == "PlayButton" { presentGameplayScene() }
            if atPoint(location).name == "SkinsButton" { OctogonService.shared.currentParts = OctogonService.shared.normalModeParts; presentSkinsScene() }
            if atPoint(location).name == "VibrationButton" {
                if !GameService.shared.getVibrationStatus() {
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    atPoint(location).alpha = 0.9
                }else { atPoint(location).alpha = 0.4}
                GameService.shared.changeVibrationStatus()
            }
        }
    }
    
    
    func presentGameplayScene() {
        if let gameplayScene = GameplayScene(fileNamed: "GameplayScene") {
            if IphoneTypeService.shared.isIphoneX() { gameplayScene.scaleMode = .aspectFill }
            else { gameplayScene.scaleMode = .aspectFill }
            if let actualOct = octogons.first {  gameplayScene.actualOctogon = actualOct }
            if let lastOct = octogons.last { gameplayScene.lastOctogon = lastOct }
            self.view?.presentScene(gameplayScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0)))
        }
    }
    
    func presentSkinsScene() {
        if let skinsScene = SkinsScene(fileNamed: "SkinsScene") {
            if IphoneTypeService.shared.isIphoneX() { skinsScene.scaleMode = .fill     }
            else { skinsScene.scaleMode = .aspectFill }
            self.view?.presentScene(skinsScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
        }
    }
}


