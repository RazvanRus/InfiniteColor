//
//  ResumePanel.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 12/02/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import SpriteKit

class ResumePanel: SKSpriteNode {
    var text = SKLabelNode()
    
    func initialize() {
        createPanel()
        text = createText()
        self.addChild(text)
    }
    
    func createPanel() {
        self.name = "ResumePanel"
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = CGPoint(x: 0, y: 0)
        self.size = CGSize(width: 750, height: 1334)
        self.zPosition = 10
        self.color = SKColor.black
        self.alpha = 0.95
    }
    
    func createText() -> SKLabelNode{
        let textLabel = SKLabelNode()
        textLabel.name = "RPTextLabel"
        textLabel.position = CGPoint(x: 0, y: 0)
        textLabel.text = "3"
        textLabel.fontName = "AvenirNext-DemiBold"
        textLabel.fontSize = 150
        textLabel.fontColor = SKColor.white
        textLabel.horizontalAlignmentMode = .center
        textLabel.verticalAlignmentMode = .center
        textLabel.alpha = 1
        
        return textLabel
    }
    
    func animate() {
        let wait = SKAction.wait(forDuration: TimeInterval(1.01))
        let changeTextTo1 = SKAction.run { self.text.text = "1" }
        let changeTextTo2 = SKAction.run { self.text.text = "2" }
        let remove = SKAction.removeFromParent()
        let fadeBackground = SKAction.fadeAlpha(to: 0.85, duration: 3)
        
        let sequence = SKAction.sequence([wait,changeTextTo2,wait,changeTextTo1,wait,remove])
        let group = SKAction.group([sequence,fadeBackground])
        
        self.run(group)
    }
}
