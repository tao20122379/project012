//
//  MP3Player.swift
//  MP3Player
//
//  Created by James Tyner on 7/17/15.
//  Copyright (c) 2015 James Tyner. All rights reserved.
//

import UIKit
import AVFoundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class MP3Player: NSObject, AVAudioPlayerDelegate {
    
    var player:AVAudioPlayer?
    var currentStart: TimeInterval?
    var currentEnd: TimeInterval?
    var longTime: TimeInterval?
    var timer: Timer?
    override init(){
        //tracks = FileReader.readFiles()
        super.init()
        
    }
    
    func audioPlayWithName(_ fileNmae: String, startTime: Double, endTime: Double) {
        currentStart = startTime
        currentEnd = endTime
        longTime = currentEnd! - currentStart!
        let url =  URL(fileURLWithPath: Bundle.main.path(forResource: fileNmae, ofType: "mp3")!)
        do {
            player = try AVAudioPlayer(contentsOf: url)

            player!.numberOfLoops = 0
            player!.enableRate = true
            timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(MP3Player.playProgress), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
            player?.currentTime = self.currentStart!
            player?.play()
        }
        catch {
            
        }
    }
    
    func playProgress() {
        if self.player!.currentTime - self.currentStart! > self.longTime {
            self.timer?.invalidate()
            self.player!.stop()
        }
    }
    
    func initWithFileMp3(_ fileNmae: String){
        
        if(player != nil){
            player = nil
        }
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: fileNmae, ofType: "mp3")!)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
        }
        catch {
        
        }
      }
    
    func play() {
        if player?.isPlaying == false {
             player?.play()
        }
    }
    
    func stop(){
        if player?.isPlaying == true {
            player?.stop()
            player?.currentTime = 0
        }
    }
    
    func pause(){
        if player?.isPlaying == true{
            player?.pause()
        }
    }
    
}

