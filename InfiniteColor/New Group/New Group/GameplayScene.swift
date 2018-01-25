//
//  GameplayScene.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 18/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene {
    var spinningFactor: CGFloat = 1
    
    var lastOctogon: Octogon?
    var actualOctogon: Octogon?
    var octogons: [Octogon] = []
    var circle = Circle()
    
    var isScaling = true
    var canTouch = true
    var canMoveToMainMenu = false
    
    var score = 0
    var scoreLabel: SKLabelNode?
    
    override func didMove(to view: SKView) {
        initialize()
        initializeDelegateNotifications()
    }
    
    func initialize() {
        scoreLabel = self.childNode(withName: "ScoreLabel") as? SKLabelNode
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createFirstOctogons), userInfo: nil, repeats: false)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let actualOct = actualOctogon {
            if isScaling && actualOct.size.width > CGFloat(500) {
                OctogonService.shared.scaleValue = 1
                isScaling = false
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canMoveToMainMenu {
            presentMainMenu()
        }else {
            if canTouch {
                for _ in touches {
                    moveCircle()
                    createOctogon()
                    actualOctogon?.colorize()
                    slowOctogons()
                    verifyOctogons()
                    if !isScaling {
                        isScaling = true
                        OctogonService.shared.scaleValue = 1.25
                    }
                }
            }
        }
    }
    
    func slowOctogons() {
        for octogon in octogons {
            octogon.slowAnimation()
            octogon.spinningFactor *= -1
        }
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
    
    func distanceBetween(circle: Circle, and part: SKSpriteNode) -> CGFloat {
        guard let circlePositionRelative = circle.scene?.convert(circle.position, from: circle.parent!) else {return 1000}
        guard let partPositionRelative = part.scene?.convert(part.position, from: part.parent!) else {return 1000}
        
        let xValue = partPositionRelative.x - circlePositionRelative.x
        let yValue = partPositionRelative.y - circlePositionRelative.y
        let distance = xValue*xValue + yValue*yValue
        
        return distance.squareRoot()
    }
    
    func moveCircle() {
        canTouch = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2*CircleService.shared.animationDuration) { self.canTouch = true }
        
        if let octogon =  lastOctogon, let part = octogon.childNode(withName: CircleService.shared.nextPartColor) as? SKSpriteNode {
            if octogon.size.height/distanceBetween(circle: circle, and: part) > 2.75 {
                incrementScore()
                circle.scaleDownAnimation()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CircleService.shared.animationDuration, execute: {
                    self.createCircle(for: octogon)
                    self.circle.scaleUpAnimation()
                })
            } else {
                // end game situation
                endGameSituation()
            }
        }
    }
    
    func incrementScore() {
        if let scoreText = scoreLabel?.text,
            let score = Int(scoreText) {
            scoreLabel?.text = "\(score+1)"
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
        octogons.append(octogon)
        
        actualOctogon = lastOctogon
        lastOctogon = octogon
    }
    
    func createCircle(for octogon: Octogon) {
        CircleService.shared.moveToNextPart()
        
        circle = Circle()
        circle.initialize()
        
        let size = octogon.initialSize
        circle.setSize(CGSize(width: size/9, height: size/9))
        
        if let part = octogon.childNode(withName: CircleService.shared.currentPartColor) { part.addChild(circle) }
    }
}




// MARK: endGameSituation
extension GameplayScene {
    func endGameSituation() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { self.canMoveToMainMenu = true }
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
        startOctogons()
    }
    
    @objc
    func appWillResignActive() {
        stopOctogons()
    }
    
    func stopOctogons() {
        for octogon in octogons {
            octogon.stopAnimation()
        }
    }
    
    func startOctogons() {
        for octogon in octogons {
            octogon.startAnimation()
        }
    }
}



