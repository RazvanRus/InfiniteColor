//
//  ReviveOctogon.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 12/02/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import UIKit

class ReviveOctogon: Octogon {
    override func initialize(spinningFactor: CGFloat) {
        OctogonService.shared.currentParts = ReviveGameService.shared.lastOctogonParts
        super.createOctogon()
        super.createParts()
        super.spinningFactor = spinningFactor
    }
}
