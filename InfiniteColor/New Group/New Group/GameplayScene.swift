//
//  GameplayScene.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 18/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox
import Appodeal

class GameplayScene: SKScene {
    // adds delegate
    var appodealAdsDelegate: AppodealAdsDelegate!
    
    // MARK: variables
    var spinningFactor: CGFloat = 1
    var scoreMultiplier = 1
    var highestCombo = 0
    
    var lastOctogon = Octogon()
    var actualOctogon = Octogon()
    var octogons: [Octogon] = []
    var circle = Circle()
    
    var canTouch = false
    var canMoveToMainMenu = false
    
    var scoreLabel: SKLabelNode?
    
    // MARK: functions
    override func didMove(to view: SKView) {
        resetServices()
        
        initializeDelegateNotifications()
        initializeLabels()
        if ReviveGameService.shared.isPlayerRevived { initializeForRevivePlayer() } else { initialize() }
    }
    
    func resetServices() {
        OctogonService.shared.spinningAngle = 2.5
        OctogonService.shared.isScaling = true
        AudioService.shared.turnUpBackgroundSound()
    }
    
    func initialize() {
        CircleService.shared.moveToNextPart()
        
        if lastOctogon.name == "PlayButton" && actualOctogon.name == "PlayButton" {
            initializeOctogons()
        } else { createFirstOctogons(withSize: CGSize(width: 230, height: 230)) }
    }
    
    func initializeOctogons() {
        octogons.append(actualOctogon)
        octogons.append(lastOctogon)
        actualOctogon.name = "Octogon"
        lastOctogon.name = "Octogon"
        actualOctogon.move(toParent: self)
        lastOctogon.move(toParent: self)
        createCircle(for: actualOctogon.parts.first!)
        circle.scaleUpAnimation()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { self.canTouch = true; self.startOctogons() }
    }
    
    func initializeForRevivePlayer() {
        ReviveGameService.shared.isPlayerRevived = false
        spinningFactor = ReviveGameService.shared.spinningFactor
        if ReviveGameService.shared.octogonsSize.count % 2 == 1 { spinningFactor *= -1 }
        OctogonService.shared.spinningAngle = ReviveGameService.shared.spinningAngle
        incrementScore(by: ReviveGameService.shared.score)
        highestCombo = ReviveGameService.shared.highestCombo
        self.canTouch = true
        createOctogonsForRevive()
    }
    
    func initializeLabels() {
        scoreLabel = self.childNode(withName: "ScoreLabel") as? SKLabelNode
        scoreLabel?.zPosition = ZPositionService.shared.label
    }
    
    override func update(_ currentTime: TimeInterval) {
        if OctogonService.shared.isScaling && actualOctogon.size.width > CGFloat(450) {
            OctogonService.shared.isScaling = false
        }
        adjustScoreSize()
        adjustScaleValue()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canMoveToMainMenu {
            for touch in touches {
                let location = touch.location(in: self)
                if atPoint(location).name == "EGPReviveButton" && ReviveGameService.shared.canPlayerBeRevived {
                    if let scoreText = scoreLabel?.text, let score = Int(scoreText) {
                        prepareForRevive(withScore: score)
                        presentReviveVideoAd()
                    }
                }else { tryToPresentInterstitial() }
            }
        }else {
            if canTouch {
                moveCircle()
                if !OctogonService.shared.isScaling { OctogonService.shared.isScaling = true }
            }
        }
    }
    
    func slowOctogons() {
        for octogon in octogons {
            octogon.slowAnimation()
            octogon.spinningFactor *= -1
        }
        lastOctogon.stopIncreasing()
        spinningFactor *= -1
    }
    
    func verifyOctogons() {
        var index = 0
        for octogon in octogons {
            if octogon.size.height > 1800 {
                octogon.removeOctogon()
                octogons.remove(at: index)
                index -= 1
            }
            index += 1
        }
    }
    
    func adjustScaleValue() { OctogonService.shared.scaleValue = 1 + (70/actualOctogon.size.height) }
    
    func adjustScoreSize() {
        scoreLabel?.fontSize = getScoreSize()
    }
    
    func getScoreSize() -> CGFloat {
        if let scoreText = scoreLabel?.text {
            if lastOctogon.size.height < 200 {
                switch scoreText.count {
                case 1:
                    return lastOctogon.size.height/1.875
                case 2:
                    return lastOctogon.size.height/2.25
                case 3:
                    return lastOctogon.size.height/3.0
                default:
                    return lastOctogon.size.height/4.0
                }
            }else {
                switch scoreText.count {
                case 1:
                    return 107
                case 2:
                    return 89
                case 3:
                    return 67
                default:
                    return 50
                }
            }
        }
        return 80
    }
    
    func distanceBetween(circle: Circle, and part: Part) -> CGFloat {
        guard let circlePositionRelative = circle.scene?.convert(circle.position, from: circle.parent!) else {return 1000}
        guard let partPositionRelative = part.scene?.convert(part.position, from: part.parent!) else {return 1000}
        
        let xValue = partPositionRelative.x - circlePositionRelative.x
        let yValue = partPositionRelative.y - circlePositionRelative.y
        let distance = xValue*xValue + yValue*yValue
        
        return distance.squareRoot()
    }
    
    func getClosestPart(for octogon: Octogon) -> Part {
        var closestPart = Part()
        var distance: CGFloat = 1001
        for part in octogon.parts {
            let forDistance = distanceBetween(circle: circle, and: part)
            if forDistance < distance {
                distance = forDistance
                closestPart = part
            }
        }
        return closestPart
    }
    
    func canMove(toClosestPart closestPart: Part) -> Bool {
        let part = lastOctogon.getNextPart()
        return part.name == closestPart.name
    }
    
    func moveCircle() {
        canTouch = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2*CircleService.shared.animationDuration) { self.canTouch = true }
        if scoreMultiplier > GameService.shared.getHighestCombo() { GameService.shared.set(highestCombo: scoreMultiplier) }
        if scoreMultiplier > highestCombo { highestCombo = scoreMultiplier }
        let closestPart = getClosestPart(for: lastOctogon)
        if canMove(toClosestPart: closestPart) {
            if lastOctogon.radiansRotation <= CGFloat(3.8) {
                AudioService.shared.playSoundEffect("perfect")
                perfectMove(forPart: closestPart)
            }else {
                AudioService.shared.playSoundEffect("tap")
                incrementScore(by: 1)
                scoreMultiplier = 1
            }
            moveAnimation(toClosestPart: closestPart)
            OctogonService.shared.increaseSpinningAngle()
        } else {
            // end game situation
            AudioService.shared.playSoundEffect("die")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CircleService.shared.animationDuration*2.01, execute: { AudioService.shared.turnDownBackgroundSound() })
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CircleService.shared.animationDuration*1.01, execute: { self.endGameSituation() })
            stopOctogons()
            lastOctogon.colorize()
            circle.scaleDownAnimation()
        }
    }
    
    func moveAnimation(toClosestPart part: Part) {
        createNextOctogon()
        actualOctogon.colorize()
        slowOctogons()
        lastOctogon.fadeInAnimation()
        verifyOctogons()
        
        circle.scaleDownAnimation()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CircleService.shared.animationDuration, execute: {
            CircleService.shared.moveToNextPart()
            self.createCircle(for: part)
            self.circle.scaleUpAnimation()
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CircleService.shared.animationDuration*2) { self.lastOctogon.increaseRadiansRotation() }
    }
    
    func perfectMove(forPart part: Part) {
        if scoreMultiplier < 100 { scoreMultiplier += 1 }
        
        let perfectMoveLabel = PerfectMoveLabel()
        perfectMoveLabel.initialize(withText: "x\(scoreMultiplier)")
        perfectMoveLabel.setSize(part.size.height*0.8)
        part.addChild(perfectMoveLabel)
        part.perfectMoveAnimation()
        perfectMoveLabel.remove(after: CircleService.shared.animationDuration)
        
        if GameService.shared.getVibrationStatus() { AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate)) }
        
        incrementScore(by: scoreMultiplier)
        incrementBonusPoints(by: 1)
    }
    
    func incrementBonusPoints(by amount: Int) {
        GameService.shared.set(bonusPoints: GameService.shared.getBonusPoints()+1)
    }
    
    func incrementScore(by amount: Int) {
        if let scoreText = scoreLabel?.text,
            let score = Int(scoreText) {
            scoreLabel?.text = "\(score+amount)"
        }
    }
}



// MARK: creating stuffs functions
extension GameplayScene {
    @objc
    func createFirstOctogons(withSize firstSize: CGSize) {
        if firstSize.width >  CGFloat(500) { OctogonService.shared.isScaling = false }
        
        let octogon = createOctogon(withSize: firstSize)
        octogon.startAnimation()
        self.addChild(octogon)
        octogons.append(octogon)
        let secoundSize = CGSize(width: firstSize.width*0.65, height: firstSize.height*0.65)
        let secoundOctogon = createOctogon(withSize: secoundSize)
        secoundOctogon.startAnimation()
        self.addChild(secoundOctogon)
        octogons.append(secoundOctogon)
        secoundOctogon.increaseRadiansRotation()
        
        actualOctogon = octogon
        lastOctogon = secoundOctogon
        actualOctogon.instantColorize()
        
        createCircle(for: actualOctogon.parts.first!)
    }
    
    @objc
    func createOctogonsForRevive() {
        for size in ReviveGameService.shared.octogonsSize {
            actualOctogon = lastOctogon
            lastOctogon = createOctogonForRevive(withSize: size)
            
            actualOctogon.stopIncreasing()
            actualOctogon.instantColorize()
            lastOctogon.increaseRadiansRotation()
            
            lastOctogon.startAnimation()
            octogons.append(lastOctogon)
            self.addChild(lastOctogon)
        }
        createCircle(for: actualOctogon.parts.first!)
    }
    
    func createOctogonForRevive(withSize size: CGSize) -> Octogon {
        let octogon = ReviveOctogon()
        octogon.setPosition(CGPoint(x: 0, y: 0))
        octogon.setSize(size)
        octogon.initialize(spinningFactor: spinningFactor)
        
        spinningFactor *= -1
        octogon.startAnimation()
        
        return octogon
    }
    
    func createOctogon(withSize size: CGSize) -> Octogon{
        let octogon = Octogon()
        octogon.setPosition(CGPoint(x: 0, y: 0))
        octogon.setSize(size)
        octogon.initialize(spinningFactor: spinningFactor)
        
        spinningFactor *= -1
        octogon.startAnimation()
        
        return octogon
    }
    
    func createNextOctogon() {
        let size = CGSize(width: lastOctogon.size.width*0.65, height: lastOctogon.size.width*0.65)
        let octogon = createOctogon(withSize: size)
        self.addChild(octogon)
        octogons.append(octogon)
        
        lastOctogon.stopIncreasing()
        actualOctogon = lastOctogon
        lastOctogon = octogon
        lastOctogon.increaseRadiansRotation()
    }
    
    func createCircle(for part: Part) {
        circle = Circle()
        circle.initialize()
        
        guard let octogon = part.parent as? Octogon else { return }
        let size = octogon.initialSize
        circle.setSize(CGSize(width: size/9, height: size/9))
        
        part.addChild(circle)
    }
}




// MARK: endGameSituation
extension GameplayScene {
    func endGameSituation() {
        canMoveToMainMenu = true
        stopOctogons()
        setHighscore()
        ReviveGameService.shared.reset()
        
        if let scoreText = scoreLabel?.text, let score = Int(scoreText) {
            createEndGamePannel(withScore: score)
        } else { createEndGamePannel(withScore: 0) }
    }
    
    func prepareForRevive(withScore score: Int) {
        ReviveGameService.shared.score = score
        ReviveGameService.shared.highestCombo = highestCombo
        ReviveGameService.shared.spinningFactor = spinningFactor
        ReviveGameService.shared.spinningAngle = OctogonService.shared.spinningAngle
        ReviveGameService.shared.lastOctogonParts = OctogonService.shared.currentParts
        
        for octogon in octogons {
            ReviveGameService.shared.octogonsSize.append(octogon.size)
        }
    }
    
    func setHighscore() {
        if let scoreText = scoreLabel?.text, let score = Int(scoreText) {
            if score > GameService.shared.getHighscore() { GameService.shared.set(highscore: score) }
        }
    }
    
    func createEndGamePannel(withScore score: Int) {
        let endGamePannel = EndGamePannel()
        endGamePannel.initialize(withScore: score, andCombo: highestCombo)
        self.addChild(endGamePannel)
        //        scoreLabel?.removeFromParent()
    }
    
    func presentMainMenu() {
        if let mainMenuScene = MainMenuScene(fileNamed: "MainMenuScene") {
            mainMenuScene.scaleMode = .aspectFill
            if IphoneTypeService.shared.isIphoneX() { mainMenuScene.scaleMode = .aspectFill }
            mainMenuScene.appodealAdsDelegate = appodealAdsDelegate
            self.view?.presentScene(mainMenuScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
        }
    }
    
    func presentGameplayScene() {
        if let gameplayScene = GameplayScene(fileNamed: "GameplayScene") {
            if IphoneTypeService.shared.isIphoneX() { gameplayScene.scaleMode = .aspectFill }
            else { gameplayScene.scaleMode = .aspectFill }
            gameplayScene.appodealAdsDelegate = appodealAdsDelegate
            self.view?.presentScene(gameplayScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.25)))
        }
    }
}




// MARK: extension for delegate notifications (app state) !!!
extension GameplayScene {
    func initializeDelegateNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(GameplayScene.appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameplayScene.appWillResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc
    func appDidBecomeActive() {
        if !canMoveToMainMenu {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: { self.canTouch = true; self.startOctogons() })
//            if let resumePanel = self.childNode(withName: "ResumePanel") as? ResumePanel { resumePanel.animate() }
        }
        AudioService.shared.resumeBackgroundSound()
    }
    
    @objc
    func appWillResignActive() {
        self.canTouch = false
        stopOctogons()
//        if !canMoveToMainMenu { createResumePanel() }
        AudioService.shared.pauseBackgrounSound()
    }
    
    func stopOctogons() {
        setHighscore()
        for octogon in octogons { octogon.stopAnimation() }
        lastOctogon.stopIncreasing()
    }
    
    func startOctogons() {
        for octogon in octogons { octogon.startAnimation() }
        lastOctogon.increaseRadiansRotation()
    }
    
    func createResumePanel() {
        let resumePanel = ResumePanel()
        resumePanel.initialize()
        self.addChild(resumePanel)
    }
}



// MARK: extension for appodeal ads management
extension GameplayScene {
    func presentReviveVideoAd() {
        if ReviveGameService.shared.canPlayerBeRevived {
            if (Appodeal.isReadyForShow(with: .rewardedVideo)) {
                appodealAdsDelegate.presentRewardedVideo()
            }
        }
    }
    
    func tryToPresentInterstitial() {
        let randomSourceArc = GKARC4RandomSource()
        let randomNumber = randomSourceArc.nextInt(upperBound: 3)
        if randomNumber == 1 {
            if (Appodeal.isReadyForShow(with: .interstitial)) {
                appodealAdsDelegate.presentInterstitial()
            }else {
                presentMainMenu()
            }
        }else {
            presentMainMenu()
        }
    }
}



// MARK: appodeal ads delegate protocol
protocol AppodealAdsDelegate {
    func presentInterstitial()
    func presentRewardedVideo()
    func presentBanner()
    func dismissBanner()
}


