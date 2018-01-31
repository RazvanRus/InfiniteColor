//
//  AudioService.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 29/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import SpriteKit
import AVFoundation

class AudioService {
    private init() {}
    public static let shared = AudioService()
    
    var backgroundPlayer = AVAudioPlayer()
    var soundEffectsPlayer = AVAudioPlayer()

    func playBackgroundSound() {
        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "main", ofType: "mp3")!))
            backgroundPlayer.prepareToPlay()
            
            let audioSession = AVAudioSession.sharedInstance()
            do { try audioSession.setCategory(AVAudioSessionCategorySoloAmbient) }catch{print(error)}
        }catch{print(error)}

        backgroundPlayer.numberOfLoops = -1
        backgroundPlayer.volume = 0.8
        backgroundPlayer.play()
    }
    
    func playSoundEffect(_ effect: String) {
        do {
            soundEffectsPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: effect, ofType: "mp3")!))
            soundEffectsPlayer.prepareToPlay()
            
            let audioSession = AVAudioSession.sharedInstance()
            do { try audioSession.setCategory(AVAudioSessionCategorySoloAmbient) }catch{print(error)}
        }catch{print(error)}
        
        turnDownBackgroundSound()
        soundEffectsPlayer.volume = 1
        soundEffectsPlayer.play()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CircleService.shared.animationDuration*2) { self.soundEffectsPlayer.stop(); self.turnUpBackgroundSound() }
    }
    
    func turnDownBackgroundSound() { backgroundPlayer.volume = 0.3 }
    func turnUpBackgroundSound() { backgroundPlayer.volume = 0.8 }
    func pauseBackgrounSound() {backgroundPlayer.pause()}
    func resumeBackgroundSound() {backgroundPlayer.play()}
}







