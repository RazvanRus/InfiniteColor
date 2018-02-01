//
//  OctogonServicee.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 22/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import UIKit

extension Array {
    mutating func shuffle() {
        for _ in 0..<((count>0) ? (count-1) : 0) {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}

class OctogonService {
    private init() {}
    static let shared = OctogonService()
    
    var isScaling = true
    
    let animationDuration: TimeInterval = 1
    var scaleValue: CGFloat = 1.3
    var spinningAngle: CGFloat = 2.5
        
    var parts = ["1F5767","4C9376","6DE445","76CFE3","2746F6","EBF74E","EC428D","ED3833"]
    let rotationAngles: [CGFloat] = [3.14159,1.5708,0,4.71239,2.35619,0.785398,5.49779,3.92699]
    
    func increaseSpinningAngle() { if spinningAngle<3.4 {spinningAngle += 0.1} }
    func getScale() -> CGFloat { if isScaling {return scaleValue}else {return 1} }
    func shuffleParts() { parts.shuffle() }
    func getRandomPart() -> String { shuffleParts(); return parts[3]}
}
