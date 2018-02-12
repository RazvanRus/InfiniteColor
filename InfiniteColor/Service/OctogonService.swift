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
    
    var allParts = [("7e48be",true),("528f86",false),("e0c0b3",false),("abde84",false),("ca2905",true),("7acf3d",true),("9da070",false),("8a7862",false),("e0d17a",false),("6fb3dd",false),("a17885",false),("d89d72",false),("c7b4df",false),("966fa6",false),("63dfbe",false),("d83e62",false),("5ee17e",false),("cb4081",false),("cae046",false),("872d83",false),("60819f",false),("6e75d9",false),("9a5f2a",false),("f1ca2e",true),("c3e2b5",false),("d3736f",false),("5eaa71",false),("493f81",false),("cd81db",false),("adcecb",false),("df8bb1",false),("db6e33",false),("7bdae5",true),("cc45d3",false),("d99637",false),("336d40",true),("df423f",false),("5c3acb",false),("529d34",false),("eb59b0",true),("2f84d0",true),("9c9835",false)]
    var currentParts = ["7bdae5","ca2905","7acf3d","7e48be","f1ca2e","2f84d0","336d40","eb59b0"]
    let rotationAngles: [CGFloat] = [3.14159,1.5708,0,4.71239,2.35619,0.785398,5.49779,3.92699]
    
    func increaseSpinningAngle() { if spinningAngle<3.4 {spinningAngle += 0.1} }
    func getScale() -> CGFloat { if isScaling {return scaleValue}else {return 1} }
    func shuffleParts() { currentParts.shuffle() }
    func getRandomPart() -> String { return(currentParts[Int(arc4random_uniform(UInt32(currentParts.count)))]) }
    
    func getParts() {
        currentParts = getCurrentParts()
        allParts = getAllParts()
    }
    
    func saveParts() {
        set(currentParts: currentParts)
        set(allParts: allParts)
    }
    
    func buy(color: ColorTemplate) {
        for index in 0..<allParts.count { if allParts[index].0 == color.name { allParts[index].1 = true } }
        set(allParts: allParts)
    }
    
    func substitute(currentPart currPart: Part, with partName: String) {
        var exists = false
        for index in 0..<currentParts.count { if currentParts[index] == currPart.name { currentParts.remove(at: index);exists=true ; break } }
        if exists { currentParts.append(partName) } 
    }
    
    
    
    
    
    /// MARK: saving and retriving from userDefaults
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
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
