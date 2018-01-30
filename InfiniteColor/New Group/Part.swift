//
//  Part.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 26/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import SpriteKit

class Part: SKSpriteNode {
    var initialSize: CGFloat = 150
    
    func initialize(withInitialSize size: CGFloat) {
        initialSize = size
    }
    
    func createFirstPart(for index: Int) {
        self.texture = SKTexture(imageNamed: OctogonService.shared.parts[index])
        self.name = OctogonService.shared.parts[index]
        self.size = CGSize(width: (initialSize/7)*3, height: initialSize/7)
        var positionX: CGFloat = 0
        var positionY: CGFloat = 0
        if index%2 == 0 {
            positionX = 0
            positionY = (initialSize/2 + 1) * CGFloat(1-index)
        } else {
            positionY = 0
            positionX = (initialSize/2 + 1) * CGFloat(2-index)
        }
        self.position = CGPoint(x: positionX, y: positionY)
        self.zRotation = OctogonService.shared.rotationAngles[index]
        self.zPosition = ZPositionService.shared.part
    }
    
    func createSecoundPart(for index: Int) {
        self.texture = SKTexture(imageNamed: OctogonService.shared.parts[index+4])
        self.name = OctogonService.shared.parts[index+4]
        self.size = CGSize(width: (initialSize/7)*3, height: initialSize/7)
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
        
        self.position = CGPoint(x: positionX, y: positionY)
        self.zRotation = OctogonService.shared.rotationAngles[index+4]
        self.zPosition = ZPositionService.shared.part
    }
    
    
    
    func colorize(inTime time: TimeInterval) {
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        let colorize = SKAction.colorize(with: color, colorBlendFactor: 0.95, duration: time)
        self.run(colorize)
    }
    
    func instantColorize() { colorize(inTime: 0) }
    func slowColorize() { colorize(inTime: CircleService.shared.animationDuration*2) }
    
    func perfectMoveAnimation() {
        let scaleUp = SKAction.scale(by: 1.2, duration: CircleService.shared.animationDuration/2)
        let scaleDown = SKAction.scale(by: 0.833333333, duration: CircleService.shared.animationDuration/2)
        let sequence = SKAction.sequence([scaleUp,scaleDown])
        self.run(sequence)
    }
}
