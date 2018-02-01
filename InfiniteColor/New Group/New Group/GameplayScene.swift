//
//  GameplayScene.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 18/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import SpriteKit
import AudioToolbox

class GameplayScene: SKScene {
    // MARK: variables
    var spinningFactor: CGFloat = 1
    var scoreMultiplier = 2
    
    var lastOctogon = Octogon()
    var actualOctogon = Octogon()
    var octogons: [Octogon] = []
    var circle = Circle()
    
    var canTouch = true
    var canMoveToMainMenu = false
    
    var scoreLabel: SKLabelNode?
    var startTimer = Timer()
    
    // MARK: functions
    override func didMove(to view: SKView) {
        resetServices()
        OctogonService.shared.set(currentParts: OctogonService.shared.currentParts)

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
        ReviveGameService.shared.canPlayerBeRevived = true
        CircleService.shared.moveToNextPart()
        
        createFirstOctogons(withSize: CGSize(width: 230, height: 230))
        stopOctogons()
        startTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in self.startOctogons() })
    }
    
    func initializeForRevivePlayer() {
        ReviveGameService.shared.canPlayerBeRevived = false
        ReviveGameService.shared.isPlayerRevived = false
        spinningFactor = ReviveGameService.shared.spinningFactor
        if ReviveGameService.shared.octogonsSize.count % 2 == 1 { spinningFactor *= -1 }
        OctogonService.shared.spinningAngle = ReviveGameService.shared.spinningAngle
        incrementScore(by: ReviveGameService.shared.score)
        
        createOctogonsForRevive()
        stopOctogons()
        startTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in self.startOctogons() })
    }
    
    func initializeLabels() {
        scoreLabel = self.childNode(withName: "ScoreLabel") as? SKLabelNode
        scoreLabel?.zPosition = ZPositionService.shared.score
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
                if atPoint(location).name == "EndGameReviveLabel" {
                    if let scoreText = scoreLabel?.text, let score = Int(scoreText) {
                        prepareForRevive(withScore: score)
                        presentGameplayScene()
                    }
                }else { presentMainMenu() }
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

    func adjustScaleValue() { OctogonService.shared.scaleValue = 1 + (65/actualOctogon.size.height) }
    
    func adjustScoreSize() {
        scoreLabel?.fontSize = getScoreSize()
    }
    
    func getScoreSize() -> CGFloat {
        if let scoreText = scoreLabel?.text {
            if lastOctogon.size.height < 150 {
                switch scoreText.count {
                case 1:
                    return lastOctogon.size.height/1.875
                case 2:
                    return lastOctogon.size.height/2.5
                case 3:
                    return lastOctogon.size.height/3.5
                default:
                    return lastOctogon.size.height/4.5
                }
            }else {
                switch scoreText.count {
                case 1:
                    return 80
                case 2:
                    return 60
                case 3:
                    return 42.85
                default:
                    return 30
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
    
    func getClosestPart(for octogon: Octogon) -> String {
        var closestPart = ""
        var distance: CGFloat = 1001
        for part in octogon.parts {
            let forDistance = distanceBetween(circle: circle, and: part)
            if forDistance < distance {
                distance = forDistance
                closestPart = part.name ?? ""
            }
        }
        return closestPart
    }
    
    func canMoveToNextOctogon() -> Bool {
        let part = lastOctogon.getNextPart()
        let closestPart = getClosestPart(for: lastOctogon)
        return part.name == closestPart
    }
    
    func moveCircle() {
        canTouch = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2*CircleService.shared.animationDuration) { self.canTouch = true }
                
        if canMoveToNextOctogon() {
            if lastOctogon.radiansRotation <= CGFloat(3.8) {
                AudioService.shared.playSoundEffect("perfect")
                perfectMove()
            }else {
                AudioService.shared.playSoundEffect("tap")
                incrementScore(by: 1)
                scoreMultiplier = 2
            }
            moveAnimation()
            OctogonService.shared.increaseSpinningAngle()
        } else {
            // end game situation
            AudioService.shared.playSoundEffect("die")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CircleService.shared.animationDuration*2.01, execute: { AudioService.shared.turnDownBackgroundSound() })
            endGameSituation()
        }
    }
    
    func moveAnimation() {
        createNextOctogon()
        actualOctogon.colorize()
        slowOctogons()
        lastOctogon.fadeInAnimation()
        verifyOctogons()
        
        circle.scaleDownAnimation()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CircleService.shared.animationDuration, execute: {
            CircleService.shared.moveToNextPart()
            self.createCircle(for: self.actualOctogon)
            self.circle.scaleUpAnimation()
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CircleService.shared.animationDuration*2) { self.lastOctogon.increaseRadiansRotation() }
    }
    
    func perfectMove() {
        let perfectMoveLabel = PerfectMoveLabel()
        perfectMoveLabel.initialize(withText: "x\(scoreMultiplier)")
        let part = lastOctogon.getNextPart()
        perfectMoveLabel.setSize(part.size.height*0.8)
        part.addChild(perfectMoveLabel)
        part.perfectMoveAnimation()
        perfectMoveLabel.remove(after: CircleService.shared.animationDuration)
        
        if GameService.shared.getVibrationStatus() { AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate)) }
        
        incrementScore(by: scoreMultiplier)
        incrementBonusPoints(by: 1)
        scoreMultiplier += 1
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
        self.addChild(octogon)
        octogons.append(octogon)
        let secoundSize = CGSize(width: firstSize.width*0.65, height: firstSize.height*0.65)
        let secoundOctogon = createOctogon(withSize: secoundSize)
        self.addChild(secoundOctogon)
        octogons.append(secoundOctogon)
        secoundOctogon.increaseRadiansRotation()
        
        actualOctogon = octogon
        lastOctogon = secoundOctogon
        actualOctogon.instantColorize()

        createCircle(for: actualOctogon)
    }
    
    @objc
    func createOctogonsForRevive() {
        for size in ReviveGameService.shared.octogonsSize {
            actualOctogon = lastOctogon
            lastOctogon = createOctogon(withSize: size)
            
            actualOctogon.stopIncreasing()
            actualOctogon.instantColorize()
            lastOctogon.increaseRadiansRotation()
            
            octogons.append(lastOctogon)
            self.addChild(lastOctogon)
        }
        createCircle(for: actualOctogon)
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
    
    func createCircle(for octogon: Octogon) {
        circle = Circle()
        circle.initialize()
        
        let size = octogon.initialSize
        circle.setSize(CGSize(width: size/9, height: size/9))
        
        let part = octogon.getCurrentPart()
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
        ReviveGameService.shared.isPlayerRevived = true
        ReviveGameService.shared.score = score
        ReviveGameService.shared.spinningFactor = spinningFactor
        ReviveGameService.shared.spinningAngle = OctogonService.shared.spinningAngle
        
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
        endGamePannel.initialize(withScore: score)
        self.addChild(endGamePannel)
        scoreLabel?.removeFromParent()
    }
    
    func presentMainMenu() {
        if let mainMenuScene = MainMenuScene(fileNamed: "MainMenuScene") {
            mainMenuScene.scaleMode = .aspectFill
            self.view?.presentScene(mainMenuScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
        }
    }
    
    func presentGameplayScene() {
        if let gameplayScene = GameplayScene(fileNamed: "GameplayScene") {
            if IphoneTypeService.shared.isIphoneX() { gameplayScene.scaleMode = .aspectFill }
            else { gameplayScene.scaleMode = .aspectFill }
            self.view?.presentScene(gameplayScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
        }
    }
}




// MARK: extension for delegate notifications (app state)
extension GameplayScene {
    func initializeDelegateNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(GameplayScene.appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameplayScene.appWillResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc
    func appDidBecomeActive() {
        if !canMoveToMainMenu {
            startOctogons()
        }
        AudioService.shared.resumeBackgroundSound()
    }
    
    @objc
    func appWillResignActive() {
        stopOctogons()
        AudioService.shared.pauseBackgrounSound()
    }
    
    func stopOctogons() {
        for octogon in octogons {
            octogon.stopAnimation()
        }
        lastOctogon.stopIncreasing()
        startTimer.invalidate()
    }
    
    func startOctogons() {
        for octogon in octogons {
            octogon.startAnimation()
        }
        lastOctogon.increaseRadiansRotation()
    }
}



