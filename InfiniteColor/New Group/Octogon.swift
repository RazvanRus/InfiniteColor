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
    var animationTimer = Timer()
    var initialSize: CGFloat = 150


    func initialize(spinningFactor: CGFloat) {
        OctogonService.shared.shuffleParts()
        createOctogon()
        createParts()
        self.spinningFactor = spinningFactor
    }
    
    func createOctogon() {
        self.name = "Octogon"
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 5
    }
    
    func createParts() {
        for i in 0..<4 {
            createFirstPart(for: i)
            createSecoundPart(for: i)
        }
    }
    
    func createFirstPart(for index: Int) {
        let part = SKSpriteNode(imageNamed: OctogonService.shared.parts[index])
        part.name = OctogonService.shared.parts[index]
        part.size = CGSize(width: (initialSize/7)*3, height: initialSize/7)
        var positionX: CGFloat = 0
        var positionY: CGFloat = 0
        if index%2 == 0 {
            positionX = 0
            positionY = initialSize/2 * CGFloat(1-index)
        } else {
            positionY = 0
            positionX = initialSize/2 * CGFloat(2-index)
        }
        part.position = CGPoint(x: positionX, y: positionY)
        part.zRotation = OctogonService.shared.rotationAngles[index]

        self.addChild(part)
    }
    
    func createSecoundPart(for index: Int) {
        let part = SKSpriteNode(imageNamed: OctogonService.shared.parts[index+4])
        part.name = OctogonService.shared.parts[index+4]
        part.size = CGSize(width: (initialSize/7)*3, height: initialSize/7)
        var positionX: CGFloat = 0
        var positionY: CGFloat = 0
        if index<2 {
            positionX = initialSize/2 - initialSize/7
        } else {
            positionX = -(initialSize/2 - initialSize/7)
        }
        if index == 0 || index == 3 {
            positionY = initialSize/2 - initialSize/7
        } else {
            positionY = -(initialSize/2 - initialSize/7)
        }
        
        part.position = CGPoint(x: positionX, y: positionY)
        part.zRotation = OctogonService.shared.rotationAngles[index+4]
        
        self.addChild(part)
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
        self.removeFromParent()
    }
    
    
    @objc
    func animate() {
        let rotate = SKAction.rotate(byAngle: OctogonService.shared.spinningAngle*spinningFactor, duration: OctogonService.shared.animationDuration)
        let scale = SKAction.scale(by: OctogonService.shared.scaleValue, duration: OctogonService.shared.animationDuration)
        let group = SKAction.group([rotate,scale])
        self.run(group)
                
        animationTimer.invalidate()
        animationTimer = Timer.scheduledTimer(timeInterval: OctogonService.shared.animationDuration, target: self, selector: #selector(animate), userInfo: nil, repeats: false)
    }
    
    func slowAnimation() {
        self.removeAllActions()
        let rotate1 = SKAction.rotate(byAngle: OctogonService.shared.spinningAngle*0.05*spinningFactor, duration: OctogonService.shared.animationDuration/5)
        let rotate2 = SKAction.rotate(byAngle: OctogonService.shared.spinningAngle*0.04*spinningFactor, duration: OctogonService.shared.animationDuration/5)
        let rotate3 = SKAction.rotate(byAngle: OctogonService.shared.spinningAngle*0.03*spinningFactor, duration: OctogonService.shared.animationDuration/5)
        let rotate4 = SKAction.rotate(byAngle: OctogonService.shared.spinningAngle*0.04*spinningFactor, duration: OctogonService.shared.animationDuration/5)
        let rotate5 = SKAction.rotate(byAngle: OctogonService.shared.spinningAngle*0.05*spinningFactor, duration: OctogonService.shared.animationDuration/5)
        let sequence = SKAction.sequence([rotate1,rotate2,rotate3,rotate4,rotate5])
        let scale = SKAction.scale(by: OctogonService.shared.scaleValue, duration: OctogonService.shared.animationDuration)
        let group = SKAction.group([sequence,scale])
        self.run(group)
        
        animationTimer.invalidate()
        animationTimer = Timer.scheduledTimer(timeInterval: OctogonService.shared.animationDuration, target: self, selector: #selector(animate), userInfo: nil, repeats: false)
    }
}












