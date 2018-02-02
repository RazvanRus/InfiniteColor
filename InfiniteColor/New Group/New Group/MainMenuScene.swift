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

    override func didMove(to view: SKView) {
        OctogonService.shared.getParts()
        getLabels()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "PlayButton" { presentGameplayScene() }
            if atPoint(location).name == "SkinsButton" { presentSkinsScene() }
            if atPoint(location).name == "VibrationButton" {
                if !GameService.shared.getVibrationStatus() {
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    atPoint(location).alpha = 1
                }else { atPoint(location).alpha = 0.4}
                GameService.shared.changeVibrationStatus()
            }
        }
    }
    
    func presentGameplayScene() {
        if let gameplayScene = GameplayScene(fileNamed: "GameplayScene") {
            if IphoneTypeService.shared.isIphoneX() { gameplayScene.scaleMode = .aspectFill }
            else { gameplayScene.scaleMode = .aspectFill }
            self.view?.presentScene(gameplayScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
        }
    }
    
    func presentSkinsScene() {
        if let skinsScene = SkinsScene(fileNamed: "SkinsScene") {
            if IphoneTypeService.shared.isIphoneX() { skinsScene.scaleMode = .aspectFill }
            else { skinsScene.scaleMode = .aspectFill }
            self.view?.presentScene(skinsScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
        }
    }
}
