//
//  SkinsScene.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 31/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//



import SpriteKit

class SkinsScene: SKScene {
    override func didMove(to view: SKView) {
        initialize()
    }
    
    func initialize() {
        createOctogon()
        createRandomColor()
    }
    
    func createRandomColor() {
        let color = SKSpriteNode()
        color.size = CGSize(width: 95, height: 60)
        color.position = CGPoint(x: 0, y: 0)
        color.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        color.color = hexStringToUIColor(hex: OctogonService.shared.getRandomPart())
        
        self.addChild(color)
    }
    
    func createOctogon() {
        let octogon = Octogon()
        octogon.setPosition(CGPoint(x: 0, y: 350))
        let size = CGSize(width: 400, height: 400)
        octogon.setSize(size)
        octogon.initialize(spinningFactor: 1)
        self.addChild(octogon)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "CancelButton" { presentMainMenu() }
        }
    }
    
    func presentMainMenu() {
        if let mainMenuScene = MainMenuScene(fileNamed: "MainMenuScene") {
            mainMenuScene.scaleMode = .aspectFill
            self.view?.presentScene(mainMenuScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
        }
    }
}


// MARK: extension for hex string manipulation to ui color
extension SkinsScene {
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
