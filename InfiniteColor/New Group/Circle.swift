//
//  Circle.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 18/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import SpriteKit

class Circle: SKSpriteNode {
    
    func initialize() {
        createCircle()
    }
    
    func createCircle() {
        self.name = "Circle"
        self.texture = SKTexture(imageNamed: "\(CircleService.shared.nextPartColor)Circle")
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.alpha = 1
        self.zPosition = 6
    }
    
    func setPosition(_ position: CGPoint) {
        self.position = position
    }
    
    func setSize(_ size: CGSize) {
        self.size = size
    }

    
    func scaleDownAnimation() {
        let scaleDown = SKAction.scale(to: 0.1, duration: CircleService.shared.animationDuration)
        let remove = SKAction.run {
            self.removeFromParent()
        }
        let sequence = SKAction.sequence([scaleDown,remove])
        self.run(sequence)
    }
    
    func scaleUpAnimation() {
        let scaleDown = SKAction.scale(to: 0.1, duration: 0)
        let scaleUp = SKAction.scale(to: 1, duration: CircleService.shared.animationDuration)
        let sequence = SKAction.sequence([scaleDown,scaleUp])
        self.run(sequence)
    }
}
