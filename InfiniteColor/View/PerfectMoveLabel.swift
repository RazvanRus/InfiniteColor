//
//  PerfectMoveLabel.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 27/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import SpriteKit
import AudioToolbox

class PerfectMoveLabel: SKLabelNode {
    func initialize(withText text: String) {
        createLabel(withText: text)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func setSize(_ size :CGFloat) {
        self.fontSize = size
    }
    
    func createLabel(withText text: String) {
        self.text = text
        self.fontSize = 20
        self.fontName = "AvenirNext-Medium"
        self.fontColor = .black
        self.verticalAlignmentMode = .center
        self.horizontalAlignmentMode = .center
    }
    
    func remove(after amountTime: TimeInterval) {
        let wait = SKAction.wait(forDuration: amountTime)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([wait,remove])
        self.run(sequence)
    }
}
