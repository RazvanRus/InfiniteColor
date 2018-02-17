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
    // adds delegate
    var appodealAdsDelegate: AppodealAdsDelegate!
    
    var selectedPart = Part()
    var informationDisplayed = false
    
    override func didMove(to view: SKView) {
        appodealAdsDelegate.dismissBanner()
        if IphoneTypeService.shared.isIphoneX() { initializeForIPhoneX() }
        initialize()
        initializeDelegateNotifications()
    }
    
    func initialize() {
        createLabels()
        createOctogon()
        createSkinColors()
    }
    
    func createLabels() {
        getBonusPoints()
        //        getAvailableSkinsNumber()
        //        getUnavailableSkinsNumber()
    }
    
    func getBonusPoints() {
        self.childNode(withName: "BonusPointsLabel")?.removeFromParent()
        let bonusPointsLabel = ScoreLabel()
        bonusPointsLabel.name = "BonusPointsLabel"
        bonusPointsLabel.initialize(withScore: "\(GameService.shared.getBonusPoints())", description: "Bonus", fontSize: 48)
        bonusPointsLabel.set(position: CGPoint(x: 0, y: 220))
        bonusPointsLabel.createExtraDescriptionLabel(withText: "Points")
        self.addChild(bonusPointsLabel)
        bonusPointsLabel.setScale(1.35)
    }
    
    func getAvailableSkinsNumber() {
        self.childNode(withName: "AvailableSkinsLabel")?.removeFromParent()
        let availableSkinsLabel = ScoreLabel()
        availableSkinsLabel.name = "AvailableSkinsLabel"
        availableSkinsLabel.initialize(withScore: "\(OctogonService.shared.getAvailableSkinsNumber())", description: "Bought", fontSize: 50)
        availableSkinsLabel.set(position: CGPoint(x: -275, y: 220))
        availableSkinsLabel.createExtraDescriptionLabel(withText: "Skins")
        self.addChild(availableSkinsLabel)
    }
    
    func getUnavailableSkinsNumber() {
        self.childNode(withName: "UnavailableSkinsLabel")?.removeFromParent()
        let unavailableSkinsLabel = ScoreLabel()
        unavailableSkinsLabel.name = "UnavailableSkinsLabel"
        unavailableSkinsLabel.initialize(withScore: "\(OctogonService.shared.getUnavailableSkinsNumber())", description: "Remaining", fontSize: 50)
        unavailableSkinsLabel.set(position: CGPoint(x: 275, y: 220))
        unavailableSkinsLabel.createExtraDescriptionLabel(withText: "Skins")
        self.addChild(unavailableSkinsLabel)
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
        octogon.setPosition(CGPoint(x: 0, y: 220))
        let size = CGSize(width: 325, height: 325)
        octogon.setSize(size)
        octogon.initialize(spinningFactor: 1)
        self.addChild(octogon)
        selectedPart = octogon.parts.first!
        selectedPart.isSelected()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if informationDisplayed {
            self.childNode(withName: "InformationSkinsScene")?.removeFromParent()
            informationDisplayed = false
        }else {
            for touch in touches {
                let location = touch.location(in: self)
                if atPoint(location).name == "ExitButton" { presentMainMenu() }
                if atPoint(location).name == "InformationButton" { presentInformation() }
                if let octogonPart = atPoint(location) as? Part { changeSelectedPart(with: octogonPart) }
                if let colorTemplate = atPoint(location) as? ColorTemplate { colorTapped(colorTemplate) }
                else{ if let colorTemplate = atPoint(location).parent as? ColorTemplate { colorTapped(colorTemplate) } }
            }
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
                self.childNode(withName: "NotEnoughPointsPanel")?.removeFromParent()
                let alreadyUsedPannel = SkinsMenuMessagePanel()
                alreadyUsedPannel.initialize(withText: "Skin already in use")
                alreadyUsedPannel.animate()
                self.addChild(alreadyUsedPannel)
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
            self.childNode(withName: "NotEnoughPointsPanel")?.removeFromParent()
            let notEnoughPointsPanel = SkinsMenuMessagePanel()
            notEnoughPointsPanel.initialize(withText: "Not enough points")
            notEnoughPointsPanel.animate()
            self.addChild(notEnoughPointsPanel)
        }
    }
    
    func presentInformation() {
        informationDisplayed = true
        let information = SKSpriteNode(imageNamed: "InformationSkinsScene")
        information.name = "InformationSkinsScene"
        information.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        if IphoneTypeService.shared.isIphoneX() { adjustInformationForIPhoneX(information)
        }else {
            information.size = CGSize(width: 760, height: 1340)
            information.position = CGPoint(x: 0, y: 0)
        }
        information.zPosition = ZPositionService.shared.anything
        self.addChild(information)
        
        let change1 = SKAction.run { information.texture = SKTexture(imageNamed: "InformationSkinsScene2") }
        let change2 = SKAction.run { information.texture = SKTexture(imageNamed: "InformationSkinsScene") }
        let wait = SKAction.wait(forDuration: 1)
        
        let sequence = SKAction.sequence([wait,change1,wait,change2])
        let repeatAction = SKAction.repeatForever(sequence)
        
        information.run(repeatAction)
    }
    
    func presentMainMenu() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) { self.appodealAdsDelegate.presentBanner() }
        if let mainMenuScene = MainMenuScene(fileNamed: "MainMenuScene") {
            mainMenuScene.scaleMode = .aspectFill
            if IphoneTypeService.shared.isIphoneX() { mainMenuScene.scaleMode = .aspectFill }
            mainMenuScene.appodealAdsDelegate = appodealAdsDelegate
            self.view?.presentScene(mainMenuScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
        }
    }
    
    func presentSkinsScene() {
        if let skinsScene = SkinsScene(fileNamed: "SkinsScene") {
            if IphoneTypeService.shared.isIphoneX() { skinsScene.scaleMode = .aspectFill     }
            else { skinsScene.scaleMode = .aspectFill }
            skinsScene.appodealAdsDelegate = appodealAdsDelegate
            self.view?.presentScene(skinsScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
        }
    }
}



// MARK: extension for delegate notifications (app state) !!!
extension SkinsScene {
    func initializeDelegateNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(GameplayScene.appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameplayScene.appWillResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc
    func appDidBecomeActive() { AudioService.shared.resumeBackgroundSound() }
    @objc
    func appWillResignActive() { AudioService.shared.pauseBackgrounSound() }
}



// MARK: extension for iPhoneX
extension SkinsScene {
    func initializeForIPhoneX() {
        setColorTemplateVariables()
        self.childNode(withName: "InformationButton")?.position.x = 235
        self.childNode(withName: "ExitButton")?.position.x = -240
        self.childNode(withName: "TitleLabel")?.position.y = 560
    }
    
    func adjustInformationForIPhoneX(_ information: SKSpriteNode) {
        information.size = CGSize(width: 700, height: 1334)
        information.position = CGPoint(x: -20, y: 0)
    }
    
    func setColorTemplateVariables() {
        IphoneTypeService.shared.iPhoneXColorTemplateWidth = 30
        IphoneTypeService.shared.iPhoneXColorTemplateDistanceBetween = 30
        IphoneTypeService.shared.iPhoneXColorTemplateStartingXPosition = -60.0
    }
}

