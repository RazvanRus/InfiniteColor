//
//  GameService.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 29/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//


import Foundation

class GameService {
    private init() {}
    static let shared = GameService()
    
    func set(highscore points: Int) {
        UserDefaults.standard.set(points, forKey: "RusRazvan.InfiniteColor.highscore")
        UserDefaults.standard.synchronize()
    }
    func getHighscore() -> Int { return UserDefaults.standard.integer(forKey: "RusRazvan.InfiniteColor.highscore") }
    
    func set(bonusPoints points: Int) {
        UserDefaults.standard.set(points, forKey: "RusRazvan.InfiniteColor.bonuspoints")
        UserDefaults.standard.synchronize()
    }
    func getBonusPoints() -> Int { return UserDefaults.standard.integer(forKey: "RusRazvan.InfiniteColor.bonuspoints") }
    
    func changeVibrationStatus() { set(vibrationStatus: !getVibrationStatus()) }
    func set(vibrationStatus status: Bool) {
        UserDefaults.standard.set(!status, forKey: "RusRazvan.InfiniteColor.vibrationStatus")
        UserDefaults.standard.synchronize()
    }
    func getVibrationStatus() -> Bool { return !UserDefaults.standard.bool(forKey: "RusRazvan.InfiniteColor.vibrationStatus") }
}
