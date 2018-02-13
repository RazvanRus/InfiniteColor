//
//  ScoreLabel.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 08/02/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import SpriteKit

class ScoreLabel: SKSpriteNode {
    func initialize(withScore score: String, description: String, fontSize: Int) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = ZPositionService.shared.label
        self.alpha = 0.9
        
        let scoreLabel = createScoreLabel(withScore: score, andFontSize: fontSize)
        let descriptionLabel = createDescriptionLabel(withText: description)
        self.addChild(scoreLabel)
        self.addChild(descriptionLabel)
    }
    
    func set(position: CGPoint) {
        self.position = position
    }
    
    func createScoreLabel(withScore score: String,andFontSize fontSize: Int) -> SKLabelNode {
        let scoreLabel = SKLabelNode()
        scoreLabel.text = score
        scoreLabel.fontSize = CGFloat(fontSize)
        scoreLabel.fontName = "AvenirNext-DemiBold"
        scoreLabel.fontColor = .black
        scoreLabel.verticalAlignmentMode = .bottom
        scoreLabel.horizontalAlignmentMode = .center
        return scoreLabel
    }
    
    func createDescriptionLabel(withText text: String) -> SKLabelNode {
        let descriptionLabel = SKLabelNode()
        descriptionLabel.text = text
        descriptionLabel.fontSize = 29
        descriptionLabel.fontName = "AvenirNext-Regular"
        descriptionLabel.fontColor = .black
        descriptionLabel.verticalAlignmentMode = .top
        descriptionLabel.horizontalAlignmentMode = .center
        descriptionLabel.position = CGPoint(x: 0, y: 1.5)
        return descriptionLabel
    }
    
    func createExtraDescriptionLabel(withText text: String) {
        let extraDescription = SKSpriteNode()
        extraDescription.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        extraDescription.position = CGPoint(x: 0, y: -22)
        
        let extraDescriptionLabel = SKLabelNode()
        extraDescriptionLabel.text = text
        extraDescriptionLabel.fontSize = 29
        extraDescriptionLabel.fontName = "AvenirNext-Regular"
        extraDescriptionLabel.fontColor = .black
        extraDescriptionLabel.verticalAlignmentMode = .top
        extraDescriptionLabel.horizontalAlignmentMode = .center
        
        extraDescription.addChild(extraDescriptionLabel)
        self.addChild(extraDescription)
    }
    
    func animateWithAlpha() {
        let fadeIn = SKAction.fadeAlpha(to: 0.9, duration: 1)
        let fadeOut = SKAction.fadeAlpha(to: 0.4, duration: 1)
        
        let sequence = SKAction.sequence([fadeOut,fadeIn])
        let repeatFade = SKAction.repeatForever(sequence)
        
        self.run(repeatFade, withKey: "FadeAction")
    }
}
