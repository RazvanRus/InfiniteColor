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
    
    var allParts = [("ffc0cb",false),("008080",false),("ff0000",false),("ffd700",false),("00ffff",false),("ff7373",false),("40e0d0",false),("ffa500",false),("0000ff",true),("b0e0e6",false),("003366",false),("800080",false),("fa8072",true),("00ff00",false),("ffff00",false),("ffb6c1",false),("20b2aa",false),("800000",false),("666666",false),("ffc3a0",false),("ff6666",false),("c39797",false),("088da5",false),("ff00ff",false),("008000",false),("0e2f44",false),("660066",false),("faebd7",false),("c6e2ff",true),("daa520",false),("990000",false),("ff7f50",false),("ff4040",false),("00ff7f",false),("ffff66",false),("3399ff",false),("8a2be2",false),("b6fcd5",false),("66cccc",false),("ccff00",false),("000080",false),("0099cc",false),("6dc066",false),("ffffff",false),("000000",false)]
    
    
    var currentParts = ["1F5767","4C9376","6DE445","76CFE3","2746F6","EBF74E","EC428D","ED3833"]
    let rotationAngles: [CGFloat] = [3.14159,1.5708,0,4.71239,2.35619,0.785398,5.49779,3.92699]
    
    func increaseSpinningAngle() { if spinningAngle<3.4 {spinningAngle += 0.1} }
    func getScale() -> CGFloat { if isScaling {return scaleValue}else {return 1} }
    func shuffleParts() { currentParts.shuffle() }
    func getRandomPart() -> String { shuffleParts(); return currentParts[3]}
    
    func getParts() {
        currentParts = getCurrentParts()
        allParts = getAllParts()
    }
    
    func buy(color: ColorTemplate) {
        for index in 0..<allParts.count { if allParts[index].0 == color.name { allParts[index].1 = true } }
        set(allParts: allParts)
    }
    
    func set(allParts parts: [(String,Bool)]) {
        var partsName: [String] = []
        var partsAvaileble: [Bool] = []
        for part in parts { partsName.append(part.0); partsAvaileble.append(part.1) }
        
        UserDefaults.standard.set(partsName, forKey: "RusRazvan.InfiniteColor.allparts.name")
        UserDefaults.standard.set(partsAvaileble, forKey: "RusRazvan.InfiniteColor.allparts.availeble")
        UserDefaults.standard.synchronize()
    }
    func getAllParts() -> [(String,Bool)] {
        if let partsName = UserDefaults.standard.array(forKey: "RusRazvan.InfiniteColor.allparts.name") as? [String], let partsAvaileble = UserDefaults.standard.array(forKey: "RusRazvan.InfiniteColor.allparts.availeble") as? [Bool] {
            var parts: [(String,Bool)] = []
            for index in 0..<partsName.count { parts.append((partsName[index],partsAvaileble[index])) }
            return parts
        } else {
            set(allParts: allParts)
            return allParts
        }
    }
    
    func set(currentParts parts: [String]) {
        UserDefaults.standard.set(parts, forKey: "RusRazvan.InfiniteColor.currentparts")
        UserDefaults.standard.synchronize()
    }
    func getCurrentParts() -> [String] {
        if let parts = UserDefaults.standard.array(forKey: "RusRazvan.InfiniteColor.currentparts") as? [String] { return parts }
        else {
            set(currentParts: currentParts)
            return currentParts
        }
    }
}
