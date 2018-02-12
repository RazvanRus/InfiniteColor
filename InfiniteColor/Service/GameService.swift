//
//  GameService.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 29/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//


import Foundation

enum GameMode: Int {
    case easy = 1
    case normal = 2
    case insane = 4
}

class GameService {
    private init() {}
    static let shared = GameService()
    
    var gameMode = GameMode.normal
    
    func set(highscore points: Int) {
        UserDefaults.standard.set(points, forKey: "RusRazvan.InfiniteColor.highscore")
        UserDefaults.standard.synchronize()
    }
    func getHighscore() -> Int { return UserDefaults.standard.integer(forKey: "RusRazvan.InfiniteColor.highscore") }
    
    func set(highestCombo combo: Int) {
        UserDefaults.standard.set(combo, forKey: "RusRazvan.InfiniteColor.highestCombo")
        UserDefaults.standard.synchronize()
    }
    func getHighestCombo() -> Int { return UserDefaults.standard.integer(forKey: "RusRazvan.InfiniteColor.highestCombo")}
    
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
