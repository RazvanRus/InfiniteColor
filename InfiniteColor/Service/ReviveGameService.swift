//
//  ReviveGameService.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 29/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import UIKit

class ReviveGameService {
    
    private init() {}
    static var shared = ReviveGameService()
    
    var isPlayerRevived = false
    var canPlayerBeRevived = true
    
    var score = 0
    var highestCombo = 1
    var spinningAngle: CGFloat = 2.5
    var spinningFactor: CGFloat = 1
    var octogonsSize: [CGSize] = []
    
    func reset() {
        score = 0
        highestCombo = 1
        spinningAngle = 2.5
        spinningFactor = 1
        octogonsSize = []
    }
}
