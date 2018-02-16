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
    case insane = 3
}

class GameService {
    private init() {}
    static let shared = GameService()
    
    var gameMode = GameMode.normal
    
    func set(highscore points: Int) {
        UserDefaults.standard.set(points, forKey: "RusRazvan.InfiniteColor.highscore\(getGameMode())")
        UserDefaults.standard.synchronize()
    }
    func getHighscore() -> Int { return UserDefaults.standard.integer(forKey: "RusRazvan.InfiniteColor.highscore\(getGameMode())") }
    
    func set(highestCombo combo: Int) {
        UserDefaults.standard.set(combo, forKey: "RusRazvan.InfiniteColor.highestCombo\(getGameMode())")
        UserDefaults.standard.synchronize()
    }
    func getHighestCombo() -> Int { return UserDefaults.standard.integer(forKey: "RusRazvan.InfiniteColor.highestCombo\(getGameMode())")}
    
    func set(bonusPoints points: Int) {
        var bonusPoints = points
        if points > 999 { bonusPoints = 999 }
        UserDefaults.standard.set(bonusPoints, forKey: "RusRazvan.InfiniteColor.bonuspoints")
        UserDefaults.standard.synchronize()
    }
    func getBonusPoints() -> Int { return UserDefaults.standard.integer(forKey: "RusRazvan.InfiniteColor.bonuspoints") }
    
    func changeVibrationStatus() { set(vibrationStatus: !getVibrationStatus()) }
    func set(vibrationStatus status: Bool) {
        UserDefaults.standard.set(!status, forKey: "RusRazvan.InfiniteColor.vibrationStatus")
        UserDefaults.standard.synchronize()
    }
    func getVibrationStatus() -> Bool { return !UserDefaults.standard.bool(forKey: "RusRazvan.InfiniteColor.vibrationStatus") }

    func changeGameMode() {
        if let nextMode = GameMode(rawValue: gameMode.rawValue+1) { gameMode = nextMode }else { gameMode = .easy }
        set(gameMode: gameMode)
    }
    func set(gameMode mode: GameMode) {
        UserDefaults.standard.set(mode.rawValue, forKey: "RusRazvan.InfiniteColor.gameMode")
        UserDefaults.standard.synchronize()
    }
    func getGameMode() -> GameMode {
        if let gameMode = GameMode(rawValue: UserDefaults.standard.integer(forKey: "RusRazvan.InfiniteColor.gameMode")) { return gameMode}
        return GameMode.normal }
}
