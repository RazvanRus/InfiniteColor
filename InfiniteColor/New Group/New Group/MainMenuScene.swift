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
    // adds delegate
    var appodealAdsDelegate: AppodealAdsDelegate!
    
    var octogons: [Octogon] = []
    var informationDisplayed = false
    
    override func didMove(to view: SKView) {
        initialize()
        initializeDelegateNotifications()
        if IphoneTypeService.shared.isIphoneX() { initializeForIPhoneX() }
    }
    
    func initialize() {
        OctogonService.shared.getParts()
        getGameMode()
        getLabels()
        createPlayButton()
        if GameService.shared.getVibrationStatus() { self.childNode(withName: "VibrationButton")?.alpha = 1 }
        else { self.childNode(withName: "VibrationButton")?.alpha = 0.4 }
        AudioService.shared.turnDownBackgroundSound()
    }
    
    func getGameMode() {
        GameService.shared.gameMode = GameService.shared.getGameMode()
        switch GameService.shared.gameMode {
        case .easy:
            if let gameModeButton = self.childNode(withName: "GameModeButton") as? SKSpriteNode { gameModeButton.texture = SKTexture(imageNamed: "EasyButton") }
            if let titleExtension = self.childNode(withName: "TitleLabel")?.childNode(withName: "TitleLabelExtension") as? SKLabelNode {
                titleExtension.alpha = 1
                titleExtension.text = "easy"
                titleExtension.fontSize = 68
                titleExtension.position = CGPoint(x: 118, y: -142)
            }
            OctogonService.shared.currentParts = OctogonService.shared.easyModeParts
        case .normal:
            if let gameModeButton = self.childNode(withName: "GameModeButton") as? SKSpriteNode { gameModeButton.texture = SKTexture(imageNamed: "NormalButton")}
            self.childNode(withName: "TitleLabel")?.childNode(withName: "TitleLabelExtension")?.alpha = 0
            OctogonService.shared.currentParts = OctogonService.shared.normalModeParts
        case .insane:
            if let gameModeButton = self.childNode(withName: "GameModeButton") as? SKSpriteNode { gameModeButton.texture = SKTexture(imageNamed: "InsaneButton")}
            OctogonService.shared.currentParts = OctogonService.shared.getRandomInsaneParts()
            if let titleExtension = self.childNode(withName: "TitleLabel")?.childNode(withName: "TitleLabelExtension") as? SKLabelNode {
                titleExtension.alpha = 1
                titleExtension.text = "insane"
                titleExtension.fontSize = 68
                titleExtension.position = CGPoint(x: 87, y: -142)
            }
        }
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
        bonusPointsLabel.name = "BonusPointsLabel"
        bonusPointsLabel.initialize(withScore: "\(GameService.shared.getBonusPoints())", description: "Bonus", fontSize: 48)
        bonusPointsLabel.set(position: CGPoint(x: -250, y: 0))
        bonusPointsLabel.createExtraDescriptionLabel(withText: "Points")
        self.addChild(bonusPointsLabel)
    }
    
    func getHighestCombo() {
        let highestComboLabel = ScoreLabel()
        highestComboLabel.name = "HighestComboLabel"
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
        if informationDisplayed {
            self.childNode(withName: "InformationMainMenuScene")?.removeFromParent(); appodealAdsDelegate.presentBanner()
            informationDisplayed = false
        }else {
            for touch in touches {
                let location = touch.location(in: self)
                if atPoint(location).name == "NoAdsButton" {
                    self.childNode(withName: "NotAvailablePanel")?.removeFromParent()
                    let notAvailablePanel = NotAvailablePanel()
                    notAvailablePanel.initialize()
                    notAvailablePanel.animate()
                    self.addChild(notAvailablePanel)
                }
                if atPoint(location).name == "InformationButton" { presentInformation() }
                if atPoint(location).name == "TitleLabel" { GameService.shared.changeGameMode(); presentMainMenu() }
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
    }
    
    func presentInformation() {
        appodealAdsDelegate.dismissBanner()
        informationDisplayed = true
        let information = SKSpriteNode(imageNamed: "InformationMainMenuScene")
        information.name = "InformationMainMenuScene"
        information.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        if IphoneTypeService.shared.isIphoneX() { adjustInformationForIPhoneX(information)
        }else {
            information.size = CGSize(width: 760, height: 1340)
            information.position = CGPoint(x: 0, y: 0)
        }
        information.zPosition = ZPositionService.shared.anything
        self.addChild(information)
        
        let change1 = SKAction.run { information.texture = SKTexture(imageNamed: "InformationMainMenuScene2") }
        let change2 = SKAction.run { information.texture = SKTexture(imageNamed: "InformationMainMenuScene") }
        let wait = SKAction.wait(forDuration: 1)
        
        let sequence = SKAction.sequence([wait,change1,wait,change2])
        let repeatAction = SKAction.repeatForever(sequence)
        
        information.run(repeatAction)
    }
    
    func presentMainMenu() {
        if let mainMenuScene = MainMenuScene(fileNamed: "MainMenuScene") {
            mainMenuScene.scaleMode = GameService.shared.gameAspect
            mainMenuScene.appodealAdsDelegate = appodealAdsDelegate
            self.view?.presentScene(mainMenuScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0)))
        }
    }
    
    func presentGameplayScene() {
        ReviveGameService.shared.canPlayerBeRevived = true
        if let gameplayScene = GameplayScene(fileNamed: "GameplayScene") {
            gameplayScene.scaleMode = GameService.shared.gameAspect
            if let actualOct = octogons.first {  gameplayScene.actualOctogon = actualOct }
            if let lastOct = octogons.last { gameplayScene.lastOctogon = lastOct }
            gameplayScene.appodealAdsDelegate = appodealAdsDelegate
            self.view?.presentScene(gameplayScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0)))
        }
    }
    
    func presentSkinsScene() {
        if let skinsScene = SkinsScene(fileNamed: "SkinsScene") {
            skinsScene.scaleMode = GameService.shared.gameAspect
            skinsScene.appodealAdsDelegate = appodealAdsDelegate
            self.view?.presentScene(skinsScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
        }
    }
}




// MARK: extension for delegate notifications (app state) !!!
extension MainMenuScene {
    func initializeDelegateNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(GameplayScene.appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameplayScene.appWillResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc
    func appDidBecomeActive() { AudioService.shared.resumeBackgroundSound() }
    @objc
    func appWillResignActive() { AudioService.shared.pauseBackgrounSound() }
}


// MARK: extension for iPhoneX
extension MainMenuScene {
    func initializeForIPhoneX() {
        self.childNode(withName: "InformationButton")?.position.x = 235
        self.childNode(withName: "BonusPointsLabel")?.position.x = -220
        self.childNode(withName: "HighestComboLabel")?.position.x = 230
    }
    
    func adjustInformationForIPhoneX(_ information: SKSpriteNode) {
        information.size = CGSize(width: 690, height: 1334)
        information.position = CGPoint(x: 0, y: 0)
    }
}


