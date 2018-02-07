//
//  Ortogon.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 18/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import SpriteKit

class Octogon: SKSpriteNode {
    var spinningFactor: CGFloat = 1
    var initialSize: CGFloat = 150
    var radiansRotation: CGFloat = 0.0
    var parts: [Part] = []
    var animationTimer = Timer()
    var increaseRadiansRotationTimer = Timer()

    
    func initialize(spinningFactor: CGFloat) {
        OctogonService.shared.shuffleParts()
        createOctogon()
        createParts()
        self.spinningFactor = spinningFactor
    }
    
    func createOctogon() {
        self.name = "Octogon"
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = ZPositionService.shared.octogon
    }
    
    func createParts() {
        for i in 0..<4 {
            let part1 = Part()
            part1.initialize(withInitialSize: initialSize)
            part1.createFirstPart(for: i)
            self.addChild(part1)
            parts.append(part1)
            
            let part2 = Part()
            part2.initialize(withInitialSize: initialSize)
            part2.createSecoundPart(for: i)
            self.addChild(part2)
            parts.append(part2)
        }
    }
    
    func setPosition(_ position: CGPoint) {
        self.position = position
    }
    
    func setSize(_ size: CGSize) {
        self.size = size
        self.initialSize = size.height
    }
    
    func removeOctogon() {
        self.animationTimer.invalidate()
        self.removeAllActions()
        self.removeAllChildren()
        self.removeFromParent()
    }
    
    @objc
    func increaseRadiansRotation() {
        radiansRotation += OctogonService.shared.spinningAngle/10
        
        increaseRadiansRotationTimer.invalidate()
        increaseRadiansRotationTimer = Timer.scheduledTimer(timeInterval: OctogonService.shared.animationDuration/10, target: self, selector: #selector(increaseRadiansRotation), userInfo: nil, repeats: false)
    }
    
    func stopIncreasing() {
        increaseRadiansRotationTimer.invalidate()
    }
    
    func stopAnimation() {
        animationTimer.invalidate()
        self.removeAllActions()
    }
    
    @objc
    func startAnimation() {
        let rotate = SKAction.rotate(byAngle: OctogonService.shared.spinningAngle*spinningFactor, duration: OctogonService.shared.animationDuration)
        let scale = SKAction.scale(by: OctogonService.shared.getScale(), duration: OctogonService.shared.animationDuration)
        let group = SKAction.group([rotate,scale])

        self.removeAllActions()
        self.run(group)
        
        animationTimer.invalidate()
        animationTimer = Timer.scheduledTimer(timeInterval: OctogonService.shared.animationDuration, target: self, selector: #selector(startAnimation), userInfo: nil, repeats: false)
    }
    
    func slowAnimation() {
        self.removeAllActions()
        let rotate1 = SKAction.rotate(byAngle: OctogonService.shared.spinningAngle*0.015*spinningFactor, duration: CircleService.shared.animationDuration/2.5)
        let rotate2 = SKAction.rotate(byAngle: OctogonService.shared.spinningAngle*0.01*spinningFactor, duration: CircleService.shared.animationDuration/2.5)
        let rotate3 = SKAction.rotate(byAngle: OctogonService.shared.spinningAngle*0.0075*spinningFactor, duration: CircleService.shared.animationDuration/2.5)
        let rotate4 = SKAction.rotate(byAngle: OctogonService.shared.spinningAngle*0.01*spinningFactor, duration: CircleService.shared.animationDuration/2.5)
        let rotate5 = SKAction.rotate(byAngle: OctogonService.shared.spinningAngle*0.015*spinningFactor, duration: CircleService.shared.animationDuration/2.5)
        let sequence = SKAction.sequence([rotate1,rotate2,rotate3,rotate4,rotate5])
        let scale = SKAction.scale(by: OctogonService.shared.getScale()*0.885, duration: CircleService.shared.animationDuration*2)
        let group = SKAction.group([sequence,scale])
        self.run(group)

        animationTimer.invalidate()
        animationTimer = Timer.scheduledTimer(timeInterval: CircleService.shared.animationDuration*2, target: self, selector: #selector(startAnimation), userInfo: nil, repeats: false)
    }
    
    func colorize() {
        for part in parts { part.slowColorize() }
    }
    
    func instantColorize() {
        for part in parts { part.instantColorize() }
    }
    
    func fadeInAnimation() {
        self.alpha = 0.01
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: CircleService.shared.animationDuration*2)
        self.run(fadeIn)
    }
    
    func getNextPart() -> Part {
        for part in parts { if part.name == CircleService.shared.nextPartColor {return part} }
        return parts.first!
    }

    func getCurrentPart() -> Part {
        for part in parts { if part.name == CircleService.shared.currentPartColor {return part} }
        return parts.first!
    }
}












