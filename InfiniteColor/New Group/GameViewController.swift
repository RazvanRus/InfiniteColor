//
//  GameViewController.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 18/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Appodeal

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initWithAppodealSettings()
        
        AudioService.shared.playBackgroundSound()
        presentMainMenu()
    }
    
    func presentMainMenu() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = MainMenuScene(fileNamed: "MainMenuScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                if IphoneTypeService.shared.isIphoneX() { scene.scaleMode = .aspectFill }
                
                // Present the scene
                scene.appodealAdsDelegate  = self
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            //            view.showsPhysics = true
            //            view.showsFPS = true
            //            view.showsNodeCount = true
        }
    }
    
    
    func presentGameplayScene() {
        ReviveGameService.shared.canPlayerBeRevived = false
        if let view = self.view as? SKView {
            if let gameplayScene = GameplayScene(fileNamed: "GameplayScene") {
                if IphoneTypeService.shared.isIphoneX() { gameplayScene.scaleMode = .aspectFill }
                else { gameplayScene.scaleMode = .aspectFill }
                gameplayScene.appodealAdsDelegate = self
                view.presentScene(gameplayScene)
            }
        }
    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}





// MARK: extension for appodeal adds management
extension GameViewController {
    func initWithAppodealSettings() {
        Appodeal.setInterstitialDelegate(self)
        Appodeal.setRewardedVideoDelegate(self)
        Appodeal.showAd(.bannerBottom, rootViewController: self)
    }
    
    func showBanner() {
        Appodeal.showAd(AppodealShowStyle.bannerBottom, rootViewController: self);
    }
    
    func hideBanner() {
        Appodeal.hideBanner()
    }
    
    func showInterstitial() {
        if Appodeal.isReadyForShow(with: .interstitial) {
            Appodeal.showAd(.interstitial, rootViewController: self)
        }
    }
    
    func showRewardedVideo() {
        if Appodeal.isReadyForShow(with: .rewardedVideo) {
            Appodeal.showAd(.rewardedVideo, rootViewController: self)
        }
    }
}



// MARK: delegate for our own delegate protocol (AppodealAdsDelegate)
extension GameViewController: AppodealAdsDelegate {
    func presentBanner() {
        showBanner()
    }
    
    func dismissBanner() {
        hideBanner()
    }
    
    func presentInterstitial() {
        self.showInterstitial()
    }

    func presentRewardedVideo() {
        self.showRewardedVideo()
    }
}



// MARK: delegate for appodeal interestitial ads
extension GameViewController: AppodealInterstitialDelegate {
    func interstitialDidLoadAdisPrecache(_ precache: Bool){
        NSLog("Interstitial was loaded")
    }
    
    func interstitialDidFailToLoadAd(){
        NSLog("Interstitial failed to load")
    }
    
    func interstitialWillPresent(){
        NSLog("Interstitial will present the ad")
    }
    
    func interstitialDidDismiss(){
        NSLog("Interstitial was closed")
        presentMainMenu()
        showBanner()
    }
    
    func interstitialDidClick(){
        NSLog("Interstitial was clicked")
    }
}



// MARK: delegate for appodeal reward videos
extension GameViewController: AppodealRewardedVideoDelegate {
    func rewardedVideoDidLoadAd(){
        NSLog("video ad was loaded")
    }
    
    func rewardedVideoDidFailToLoadAd(){
        NSLog("video ad failed to load")
    }
    
    func rewardedVideoDidPresent(){
        NSLog("video ad was presented");
    }
    
    func rewardedVideoWillDismiss(){
        NSLog("video ad was closed");
        presentGameplayScene()
        showBanner()
    }
    
    func rewardedVideoDidFinish(_ rewardAmount: UInt, name rewardName: String!){
        NSLog("video ad was fully watched");
        ReviveGameService.shared.isPlayerRevived = true
    }
}


