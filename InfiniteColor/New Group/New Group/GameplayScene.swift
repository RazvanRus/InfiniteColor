//
//  GameplayScene.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 18/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene {
    // MARK: variables
    var spinningFactor: CGFloat = 1
    var scoreMultiplier = 2
    
    var lastOctogon: Octogon?
    var actualOctogon: Octogon?
    var octogons: [Octogon] = []
    var circle = Circle()
    
    var canTouch = true
    var canMoveToMainMenu = false
    
    var scoreLabel: SKLabelNode?
    
    
    // MARK: functions
    override func didMove(to view: SKView) {
        OctogonService.shared.spinningAngle = 2.5
        initialize()
        initializeDelegateNotifications()
    }
    
    func initialize() {
        OctogonService.shared.isScaling = true
        scoreLabel = self.childNode(withName: "ScoreLabel") as? SKLabelNode
        scoreLabel?.zPosition = ZPositionService.shared.score
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createFirstOctogons), userInfo: nil, repeats: false)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let actualOct = actualOctogon {
            if OctogonService.shared.isScaling && actualOct.size.width > CGFloat(500) {
                OctogonService.shared.isScaling = false
            }
        }
        adjustScoreSize()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canMoveToMainMenu {
            presentMainMenu()
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
        lastOctogon?.stopIncreasing()
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
    
    func adjustScoreSize() {
        scoreLabel?.fontSize = getScoreSize()
    }
    
    func getScoreSize() -> CGFloat {
        if let scoreText = scoreLabel?.text, let lastOct = lastOctogon {
            if lastOct.size.height < 150 {
                switch scoreText.count {
                case 1:
                    return lastOct.size.height/1.875
                case 2:
                    return lastOct.size.height/2.5
                case 3:
                    return lastOct.size.height/3.5
                default:
                    return lastOct.size.height/4.5
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
    
    func canMoveToNextOctogon() -> Bool {
        if let octogon =  lastOctogon{
            let part = octogon.getNextPart()
            return octogon.size.height/distanceBetween(circle: circle, and: part) > 2.75
        }
        return false
    }
    
    func moveCircle() {
        canTouch = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2*CircleService.shared.animationDuration) { self.canTouch = true }
        
            if canMoveToNextOctogon() {
                if lastOctogon!.radiansRotation <= CGFloat(3.8) {
                    perfectMove()
                }else {
                    incrementScore(by: 1)
                    scoreMultiplier = 2
                }
                moveAnimation()
                OctogonService.shared.increaseSpinningAngle()
            } else {
                // end game situation
                endGameSituation()
            }
    }
    
    func moveAnimation() {
        createOctogon()
        actualOctogon?.colorize()
        slowOctogons()
        verifyOctogons()
        
        circle.scaleDownAnimation()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CircleService.shared.animationDuration, execute: {
            self.createCircle(for: self.actualOctogon!)
            self.circle.scaleUpAnimation()
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CircleService.shared.animationDuration*2) { self.lastOctogon?.increaseRadiansRotation() }
    }
    
    func perfectMove() {
        let perfectMoveLabel = PerfectMoveLabel()
        perfectMoveLabel.initialize(withText: "x\(scoreMultiplier)")
        if let lastOct = lastOctogon {
            let part = lastOct.getNextPart()
            perfectMoveLabel.setSize(part.size.height*0.8)
            part.addChild(perfectMoveLabel)
            part.perfectMoveAnimation()
        }
        perfectMoveLabel.remove(after: CircleService.shared.animationDuration)
        
        incrementScore(by: scoreMultiplier)
        scoreMultiplier += 1
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
    func createFirstOctogons() {
        let octogon = Octogon()
        octogon.setSize(CGSize(width: 230, height: 230))
        octogon.initialize(spinningFactor: spinningFactor)
        octogon.setPosition(CGPoint(x: 0, y: 0))
        self.addChild(octogon)
        
        spinningFactor *= -1
        octogon.startAnimation()
        octogons.append(octogon)
        
        let secoundOctogon = Octogon()
        secoundOctogon.setSize(CGSize(width: 150, height: 150))
        secoundOctogon.initialize(spinningFactor: spinningFactor)
        secoundOctogon.setPosition(CGPoint(x: 0, y: 0))
        self.addChild(secoundOctogon)
        
        spinningFactor *= -1
        secoundOctogon.startAnimation()
        secoundOctogon.increaseRadiansRotation()
        actualOctogon = octogon
        lastOctogon = secoundOctogon
        actualOctogon?.colorize()
        
        octogons.append(secoundOctogon)
        
        createCircle(for: actualOctogon!)
    }
    
    func createOctogon() {
        let octogon = Octogon()
        octogon.setPosition(CGPoint(x: 0, y: 0))
        var size: CGFloat = 150
        if let lastOct = lastOctogon { size = lastOct.size.height * 0.65 }
        octogon.setSize(CGSize(width: size, height: size))
        octogon.initialize(spinningFactor: spinningFactor)
        
        self.addChild(octogon)
        
        spinningFactor *= -1
        octogon.startAnimation()
        octogon.increaseRadiansRotation()
        octogons.append(octogon)
        
        lastOctogon?.stopIncreasing()
        actualOctogon = lastOctogon
        lastOctogon = octogon
    }
    
    func createCircle(for octogon: Octogon) {
        CircleService.shared.moveToNextPart()
        
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
        stopOctogons()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { self.canMoveToMainMenu = true }
        if let scoreText = scoreLabel?.text, let score = Int(scoreText) {
            createEndGamePannel(withScore: score)
        } else { createEndGamePannel(withScore: 0) }
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
    }
    
    @objc
    func appWillResignActive() {
        stopOctogons()
    }
    
    func stopOctogons() {
        for octogon in octogons {
            octogon.stopAnimation()
        }
        lastOctogon?.stopIncreasing()
    }
    
    func startOctogons() {
        for octogon in octogons {
            octogon.startAnimation()
        }
        lastOctogon?.increaseRadiansRotation()
    }
}



