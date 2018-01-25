//
//  CircleService.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 22/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import UIKit

class CircleService {
    private init() {}
    static let shared = CircleService()
    
    let animationDuration = 0.25
    
    var currentPartColor = OctogonService.shared.getRandomPart()
    var nextPartColor = OctogonService.shared.getRandomPart()
    
    func moveToNextPart() {
        currentPartColor = nextPartColor
        while nextPartColor == currentPartColor {
            nextPartColor = OctogonService.shared.getRandomPart()
        }
    }
}
