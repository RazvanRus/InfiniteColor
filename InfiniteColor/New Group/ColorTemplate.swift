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
    var index = 0
    
    
    func initialize(withIndexPosition indexPosition: Int) {
        index = indexPosition
        isAvailable = OctogonService.shared.allParts[indexPosition].1
        createColorTemplate(forIndex: indexPosition)
    }
    
    func createColorTemplate(forIndex index: Int) {
        let part = OctogonService.shared.allParts[index]

        self.name = part.0
        self.size = CGSize(width: 130, height: 100)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = ZPositionService.shared.part
        setPosition(forIndex: index)
        setCost(forIndex: index)
        setColor(forPart: part)
        
        if OctogonService.shared.normalModeParts.contains(self.name!) { alreadyInUse() }
    }
    
    func setPosition(forIndex index: Int) {
        let xPosition = -300 + Double(150 * (index % 5))
        let yPosition =  -120 - (125 * Double(index / 5))
        self.position = CGPoint(x: xPosition, y: yPosition)
    }
    
    func setColor(forPart part: (String,Bool)) {
        if isAvailable {self.color = OctogonService.shared.hexStringToUIColor(hex: part.0)} else { notAvailable() }
    }
    
    func setCost(forIndex index: Int) { cost = 150 * Int(index/10 + 1)}
    
    func alreadyInUse() {
        let border = SKSpriteNode(imageNamed: "rectangleBorder")
        border.name = "Border"
        border.position = CGPoint(x: 0, y: 0)
        border.size = self.size
        border.alpha = 1
        border.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        border.zPosition = self.zPosition+1
        self.addChild(border)
    }
    
    func notAvailable() {
        if index % 4 == 3 { self.color = .red
        }else { self.color = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 0.4) }
        createCostLabel()
    }
    
    func createCostLabel() {
        let costLabel = SKLabelNode()
        costLabel.name = self.name
        costLabel.text = "\(cost)"
        costLabel.fontSize = 40
        costLabel.fontName = "AvenirNext-DemiBold"
        costLabel.fontColor = .white
        costLabel.verticalAlignmentMode = .bottom
        costLabel.horizontalAlignmentMode = .center
        costLabel.position = CGPoint(x: 0, y: -5)
        
        let descriptionLabel = SKLabelNode()
        descriptionLabel.name = self.name
        descriptionLabel.text = "Points"
        descriptionLabel.fontSize = 25
        descriptionLabel.fontName = "AvenirNext-Regular"
        descriptionLabel.fontColor = .white
        descriptionLabel.verticalAlignmentMode = .top
        descriptionLabel.horizontalAlignmentMode = .center
        descriptionLabel.position = CGPoint(x: 0, y: -6)
        
        self.addChild(costLabel)
        self.addChild(descriptionLabel)
    }
}
