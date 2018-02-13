//
//  SkinsScene.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 31/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//



/*
 1. when you change a color update(and save) octogonservice.current parts by removing the old color and adding the new color - DONE
 2. update the octogon presented in the skinsScene (part.sprite = Sprite(imageNamed: newColour.name)) and name - Done
 3. the currentParts colours should be grayed our from the colors list and them can not be used to change another currentParts colour. partialy Done (need image)
 4. messages for when you dont have enought bonus points to buy a part. (need image)
 5. selected octogon parts should have a border, notAvaileble colors should have a Black sprite (or smth) with number of points needed for the unlocking (need image)
 6. get priceint depending on index ( first 10 will be 50 points, next 10 100, next 10 150, next 10 200, last 5 250) - done (need image for priceing)
 7. message when you try to buy (are you shure you want to spend 50/100/,, coins for this skin? yes/no) (need image)
 
 */

import SpriteKit

class SkinsScene: SKScene {
    var selectedPart = Part()
    
    override func didMove(to view: SKView) {
        initialize()
    }
    
    func initialize() {
        getBonusPoints()
        createOctogon()
        createSkinColors()
    }
    
    func getBonusPoints() {
        self.childNode(withName: "BonusPointsLabel")?.removeFromParent()
        let bonusPointsLabel = ScoreLabel()
        bonusPointsLabel.name = "BonusPointsLabel"
        bonusPointsLabel.initialize(withScore: "\(GameService.shared.getBonusPoints())", description: "Bonus", fontSize: 50)
        bonusPointsLabel.set(position: CGPoint(x: -280, y: 580))
        bonusPointsLabel.createExtraDescriptionLabel(withText: "Points")
        self.addChild(bonusPointsLabel)
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
        let size = CGSize(width: 375, height: 375)
        octogon.setSize(size)
        octogon.initialize(spinningFactor: 1)
        self.addChild(octogon)
        selectedPart = octogon.parts.first!
        selectedPart.isSelected()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "CancelButton" { presentMainMenu() }
            if let octogonPart = atPoint(location) as? Part { changeSelectedPart(with: octogonPart) }
            if let colorTemplate = atPoint(location) as? ColorTemplate { colorTapped(colorTemplate) }
            if let colorTemplate = atPoint(location).parent as? ColorTemplate { colorTapped(colorTemplate) }
        }
    }
    
    func colorTapped(_ colorTemplate: ColorTemplate) {
        if colorTemplate.isAvailable { changeColor(with: colorTemplate) }else { buy(colorTemplate) }
        deleteSkinColor()
        createSkinColors()
    }
    
    func changeSelectedPart(with part: Part) {
        selectedPart.isNotSelected()
        selectedPart = part
        selectedPart.isSelected()
    }
    
    func changeColor(with color: ColorTemplate) {
        if let colorName = color.name {
            if OctogonService.shared.normalModeParts.contains(colorName) {
                // message that color selected is already used !
            }else {
                OctogonService.shared.substitute(currentPart: selectedPart, with: colorName)
                OctogonService.shared.saveParts()
                updateOctogon(with: colorName)
            }
        }
    }
    
    func updateOctogon(with colorName: String) { selectedPart.color = OctogonService.shared.hexStringToUIColor(hex: colorName); selectedPart.name = colorName }
    
    func buy(_ colorTemplate: ColorTemplate) {
        if GameService.shared.getBonusPoints() >= colorTemplate.cost {
            OctogonService.shared.buy(color: colorTemplate)
            GameService.shared.set(bonusPoints: GameService.shared.getBonusPoints() - colorTemplate.cost)
            getBonusPoints()
        } else {
            let notEnoughPointsPanel = NotEnoughPointsLabel()
            notEnoughPointsPanel.initialize()
            notEnoughPointsPanel.animate()
            self.addChild(notEnoughPointsPanel)
        }
    }
    
    func presentMainMenu() {
        if let mainMenuScene = MainMenuScene(fileNamed: "MainMenuScene") {
            mainMenuScene.scaleMode = .aspectFill
            self.view?.presentScene(mainMenuScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
        }
    }
}

