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
    var spinningAngle: CGFloat = 2.5
    var spinningFactor: CGFloat = 1
    var actualOctogonSize: CGSize = CGSize(width: 0, height: 0)
    var lastOctogonSize: CGSize = CGSize(width: 0, height: 0)
    
    func reset() {
        score = 0
        spinningAngle = 2.5
        spinningFactor = 1
        actualOctogonSize = CGSize(width: 0, height: 0)
        lastOctogonSize = CGSize(width: 0, height: 0)
    }
}
