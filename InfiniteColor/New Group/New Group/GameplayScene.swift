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
    var lastOctogon: Octogon? = nil
    var actualOctogon: Octogon? = nil
    var octogons: [Octogon] = []
    var circle = Circle()
    
    var canTouch = true
    
    override func didMove(to view: SKView) {
        initialize()
    }
    
    func initialize() {
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createFirstOctogons), userInfo: nil, repeats: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canTouch {
            for _ in touches {
                moveCircle()
                createOctogon()
                slowOctogons()
                verifyOctogons()
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
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { self.canTouch = true }
        
        if let octogon =  lastOctogon, let part = octogon.childNode(withName: CircleService.shared.nextPartColor) as? SKSpriteNode {
            
            if octogon.size.height/distanceBetween(circle: circle, and: part) > 2.75 {
                circle.scaleDownAnimation()
                CircleService.shared.moveToNextPart()
                createCircle(for: octogon)
                circle.scaleUpAnimation()
            } else {
                // end game situation
                presentMainMenu()
            }
        }
    }
    
    func presentMainMenu() {
        if let mainMenuScene = MainMenuScene(fileNamed: "MainMenuScene") {
            mainMenuScene.scaleMode = .aspectFill
            self.view?.presentScene(mainMenuScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
        }
    }
}



// MARK: creating stuffs functions
extension GameplayScene {
    @objc
    func createFirstOctogons() {
        let octogon = Octogon()
        octogon.setSize(CGSize(width: 240, height: 240))
        octogon.initialize(spinningFactor: spinningFactor)
        octogon.setPosition(CGPoint(x: 0, y: 0))
        self.addChild(octogon)
        
        spinningFactor *= -1
        octogon.animate()
        octogons.append(octogon)
        
        let secoundOctogon = Octogon()
        secoundOctogon.setSize(CGSize(width: 150, height: 150))
        secoundOctogon.initialize(spinningFactor: spinningFactor)
        secoundOctogon.setPosition(CGPoint(x: 0, y: 0))
        self.addChild(secoundOctogon)
        
        spinningFactor *= -1
        secoundOctogon.animate()
        
        actualOctogon = octogon
        lastOctogon = secoundOctogon
        
        octogons.append(secoundOctogon)
        
        createCircle(for: actualOctogon!)
    }
    
    func createOctogon() {
        let octogon = Octogon()
        octogon.setPosition(CGPoint(x: 0, y: 0))
        var size: CGFloat = 150
        if let lastOct = lastOctogon { size = lastOct.size.height * 0.625 }
        octogon.setSize(CGSize(width: size, height: size))
        octogon.initialize(spinningFactor: spinningFactor)
        
        self.addChild(octogon)
        
        spinningFactor *= -1
        octogon.animate()
        octogons.append(octogon)
        
        actualOctogon = lastOctogon
        lastOctogon = octogon
    }
    
    func createCircle(for octogon: Octogon) {
        circle = Circle()
        circle.initialize()
        
        let size = octogon.initialSize
        circle.setSize(CGSize(width: size/9, height: size/9))
        
        if let part = octogon.childNode(withName: CircleService.shared.currentPartColor) { part.addChild(circle) }
    }
}







