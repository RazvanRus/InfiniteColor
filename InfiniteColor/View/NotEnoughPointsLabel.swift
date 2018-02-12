//
//  NotEnoughPointsLabel.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 12/02/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import SpriteKit

class NotEnoughPointsLabel: SKSpriteNode {
    func initialize() {
        createPanel()
        let text = createText()
        self.addChild(text)
    }
    
    func createPanel() {
        self.name = "NotEnoughPointsPanel"
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = CGPoint(x: 0, y: -195)
        self.color = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 0)
        self.size = CGSize(width: 300, height: 100)
        self.zPosition = 10
        self.alpha = 1
    }
    
    func createText() -> SKLabelNode{
        let textLabel = SKLabelNode()
        textLabel.name = "NEPPTextLabel"
        textLabel.position = CGPoint(x: 0, y: 0)
        textLabel.text = "Not enough points"
        textLabel.fontName = "AvenirNext-Medium"
        textLabel.fontSize = 50
        textLabel.fontColor = SKColor.white
        textLabel.horizontalAlignmentMode = .center
        textLabel.verticalAlignmentMode = .center
        textLabel.alpha = 1
        
        return textLabel
    }
    
    func animate() {
        let fade = SKAction.fadeAlpha(to: 0.4, duration: 1)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fade,remove])
        self.run(sequence)
    }
}
