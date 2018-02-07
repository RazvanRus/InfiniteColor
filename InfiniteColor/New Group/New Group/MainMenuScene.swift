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
//        initializeDelegateNotifications()
    }
    
    func initialize() {
        OctogonService.shared.getParts()
        getLabels()
        createPlayButton()
        if GameService.shared.getVibrationStatus() { self.childNode(withName: "VibrationButton")?.alpha = 1 }
        else { self.childNode(withName: "VibrationButton")?.alpha = 0.4 }
        AudioService.shared.turnDownBackgroundSound()
    }
    
    func getLabels() {
        getHighestCombo()
        getHighscore()
        getBonusPoints()
    }
    
    func getHighscore() {
        if let highscoreLabel = self.childNode(withName: "HighscoreLabel") as? SKLabelNode {
            highscoreLabel.text = "\(GameService.shared.getHighscore())"
        }
    }
    
    func getBonusPoints() {
        if let bonusPointsLabel = self.childNode(withName: "BonusPointsLabel") as? SKLabelNode {
            bonusPointsLabel.text = "\(GameService.shared.getBonusPoints())"
        }
    }
    
    func getHighestCombo() {
        if let highestComboLabel = self.childNode(withName: "HighestComboLabel") as? SKLabelNode {
            highestComboLabel.text = "x\(GameService.shared.getHighestCombo())"
        }
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
            if atPoint(location).name == "PlayButton" || atPoint(location).parent?.name == "PlayButton" { presentGameplayScene(); dealocateOctogons() }
            if atPoint(location).name == "SkinsButton" { presentSkinsScene(); dealocateOctogons() }
            if atPoint(location).name == "VibrationButton" {
                if !GameService.shared.getVibrationStatus() {
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    atPoint(location).alpha = 1
                }else { atPoint(location).alpha = 0.4}
                GameService.shared.changeVibrationStatus()
            }
        }
    }
    
    func dealocateOctogons() { appWillResignActive() }
    
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
            if IphoneTypeService.shared.isIphoneX() { skinsScene.scaleMode = .fill }
            else { skinsScene.scaleMode = .aspectFill }
            self.view?.presentScene(skinsScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
        }
    }
}


// MARK: extension for delegate notifications (app state) (NOT USED !!!)
extension MainMenuScene {
    func initializeDelegateNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MainMenuScene.appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainMenuScene.appWillResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc
    func appDidBecomeActive() {}
    @objc
    func appWillResignActive() {}
}
