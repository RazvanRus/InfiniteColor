//
//  ZPositionService.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 25/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//


import UIKit

class ZPositionService {
    private init() {}
    static let shared = ZPositionService()
    
    let background: CGFloat = 0
    let octogon: CGFloat = 1
    let part: CGFloat = 2
    let circle: CGFloat = 4
    let score: CGFloat = 8
    let endGame: CGFloat = 16
}
