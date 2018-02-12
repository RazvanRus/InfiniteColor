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
    mutating func rotate(positions: Int, size: Int? = nil) {
        guard positions < count && (size ?? 0) <= count else {
            print("invalid input1")
            return
        }
        reversed(start: 0, end: positions - 1)
        reversed(start: positions, end: (size ?? count) - 1)
        reversed(start: 0, end: (size ?? count) - 1)
    }
    mutating func reversed(start: Int, end: Int) {
        guard start >= 0 && end < count && start < end else {
            return
        }
        var start = start
        var end = end
        while start < end, start != end {
            self.swapAt(start, end)
            start += 1
            end -= 1
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
    
    var easyModeParts = ["ffeb12","00be27","006ee7","e83813","ffeb12","00be27","006ee7","e83813"]
    var normalModeParts = ["7bdae5","ca2905","7acf3d","7e48be","f1ca2e","2f84d0","336d40","eb59b0"]
    var insaneModeParts =
        [["fc0fd4","cf7e82","e301a9","9a293b","f472e8","b176a9","902577","ff99c5"],
        ["80574d","ff9381","7b4338","ffb299","9a4f1e","956364","d16b52","b98c6f"],
        ["8b7844","ffb844","958b77","d17122","f5dda6","a75a1b","976c4d","7b5700"],
        ["fffba2","33fe5c","55745c","ffdc21","00dc5e","ddddc9","309e00","7a8a00"],
        ["8ab895","02e5b6","468788","95f5b0","007b6a","b9fff8","01aa90","8affcd"],
        ["04539b","8bacff","0071b0","5171d6","559ee0","0085ef","8491df","798deb"],
        ["4c4bd1","18087a","32008f","435397","1d0062","8f399c","591c55","664eaa"]]
    var allParts = [("7e48be",true),("528f86",false),("e0c0b3",false),("abde84",false),("7acf3d",true),("9da070",false),("8a7862",false),("e0d17a",false),("6fb3dd",false),("a17885",false),("d89d72",false),("c7b4df",false),("ca2905",true),("966fa6",false),("63dfbe",false),("d83e62",false),("2f84d0",true),("5ee17e",false),("cb4081",false),("cae046",false),("872d83",false),("60819f",false),("6e75d9",false),("eb59b0",true),("9a5f2a",false),("f1ca2e",true),("c3e2b5",false),("d3736f",false),("5eaa71",false),("493f81",false),("cd81db",false),("adcecb",false),("df8bb1",false),("db6e33",false),("7bdae5",true),("cc45d3",false),("d99637",false),("336d40",true),("df423f",false),("5c3acb",false),("529d34",false),("9c9835",false)]
    var currentParts = ["7bdae5","ca2905","7acf3d","7e48be","f1ca2e","2f84d0","336d40","eb59b0"]
    let rotationAngles: [CGFloat] = [3.14159,1.5708,0,4.71239,2.35619,0.785398,5.49779,3.92699]
    
    func increaseSpinningAngle() { if spinningAngle<3.4 {spinningAngle += 0.1} }
    func getScale() -> CGFloat { if isScaling {return scaleValue}else {return 1} }
    func shuffleParts() { if GameService.shared.gameMode == .easy { shuffleEasy() }else { currentParts.shuffle() } }
    func shuffleEasy() { currentParts.rotate(positions: Int(arc4random_uniform(UInt32(currentParts.count/2))*2)) }
    func getRandomPart() -> String { return currentParts[Int(arc4random_uniform(UInt32(currentParts.count)))] }
    
    func getRandomInsaneParts() -> [String] { return insaneModeParts[Int(arc4random_uniform(UInt32(insaneModeParts.count)))]}
    
    func getParts() {
        normalModeParts = getNormalModeParts()
        allParts = getAllParts()
    }
    
    func saveParts() {
        set(normalModeParts: normalModeParts)
        set(allParts: allParts)
    }
    
    func buy(color: ColorTemplate) {
        for index in 0..<allParts.count { if allParts[index].0 == color.name { allParts[index].1 = true } }
        set(allParts: allParts)
    }
    
    func substitute(currentPart currPart: Part, with partName: String) {
        var exists = false
        for index in 0..<normalModeParts.count { if normalModeParts[index] == currPart.name { normalModeParts.remove(at: index);exists=true ; break } }
        if exists { normalModeParts.append(partName) }
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
    
    func set(normalModeParts parts: [String]) {
        UserDefaults.standard.set(parts, forKey: "RusRazvan.InfiniteColor.normalmodeparts")
        UserDefaults.standard.synchronize()
    }
    func getNormalModeParts() -> [String] {
        if let parts = UserDefaults.standard.array(forKey: "RusRazvan.InfiniteColor.normalmodeparts") as? [String] { return parts }
        else {
            set(normalModeParts: normalModeParts)
            return normalModeParts
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
