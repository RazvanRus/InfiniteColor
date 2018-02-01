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
        createSkinColors()
    }
    
    func createSkinColors() {
        for index in 0..<OctogonService.shared.allParts.count {
            let colorNode = ColorTemplate()
            colorNode.initialize(withIndexPosition: index)
            self.addChild(colorNode)
        }
    }
    
    func deleteSkinColor() {
        for child in self.children {
            if let colorTemplate = child as? ColorTemplate {
                colorTemplate.removeFromParent()
            }
        }
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
            if let colorTemplate = atPoint(location) as? ColorTemplate {
                if !colorTemplate.isAvaible { buy(colorTemplate) }
            }
        }
    }
    
    func buy(_ colorTemplate: ColorTemplate) {
        print("trying to buy")
        if GameService.shared.getBonusPoints() >= colorTemplate.cost {
            OctogonService.shared.buy(color: colorTemplate)
            deleteSkinColor()
            createSkinColors()
        }
    }
    
    func presentMainMenu() {
        if let mainMenuScene = MainMenuScene(fileNamed: "MainMenuScene") {
            mainMenuScene.scaleMode = .aspectFill
            self.view?.presentScene(mainMenuScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
        }
    }
}

