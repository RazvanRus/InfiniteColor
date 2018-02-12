//
//  ColorTemplate.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 01/02/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import SpriteKit

class ColorTemplate: SKSpriteNode {
    var cost = 50
    var isAvailable = false
    
    
    func initialize(withIndexPosition indexPosition: Int) {
        isAvailable = OctogonService.shared.allParts[indexPosition].1
        createColorTemplate(forIndex: indexPosition)
    }
    
    func createColorTemplate(forIndex index: Int) {
        let part = OctogonService.shared.allParts[index]

        self.name = part.0
        self.size = CGSize(width: 110, height: 75)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = ZPositionService.shared.part
        setPosition(forIndex: index)
        setColor(forPart: part)
        setCost(forIndex: index)
        
        if OctogonService.shared.currentParts.contains(self.name!) { alreadyInUse() }
    }
    
    func setPosition(forIndex index: Int) {
        let xPosition = -312.5 + Double(125 * (index % 6))
        let yPosition =  25.0 - (87.5 * Double(index / 6))
        self.position = CGPoint(x: xPosition, y: yPosition)
    }
    
    func setColor(forPart part: (String,Bool)) {
        if isAvailable {self.color = OctogonService.shared.hexStringToUIColor(hex: part.0)} else { notAvailable() }
    }
    
    func setCost(forIndex index: Int) { cost = 50 * Int(index/10 + 1)}
    
    func notAvailable() {
        self.color = .black
    }
    
    func alreadyInUse() {
        let gray = SKSpriteNode()
        gray.name = "InUse"
        gray.position = CGPoint(x: 0, y: 0)
        gray.size = self.size
        gray.color = .gray
        gray.alpha = 0.7
        gray.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gray.zPosition = self.zPosition+1
        self.addChild(gray)
    }
    
    func createCostLabel() {
        let costLabel = SKLabelNode()
        costLabel.name = self.name
        costLabel.color = .white
        costLabel.fontSize = 25
        costLabel.text = "\(cost) points"
        self.addChild(costLabel)
    }
}
