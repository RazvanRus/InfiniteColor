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
