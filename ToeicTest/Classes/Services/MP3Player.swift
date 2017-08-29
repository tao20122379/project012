//
//  MP3Player.swift
//  MP3Player
//
//  Created by James Tyner on 7/17/15.
//  Copyright (c) 2015 James Tyner. All rights reserved.
//

import UIKit
import AVFoundation

class MP3Player: NSObject, AVAudioPlayerDelegate {
    
    var player:AVAudioPlayer?
    var currentStart: NSTimeInterval?
    var currentEnd: NSTimeInterval?
    var longTime: NSTimeInterval?
    var timer: NSTimer?
    override init(){
        //tracks = FileReader.readFiles()
        super.init()
        
    }
    
    func audioPlayWithName(fileNmae: String, startTime: Double, endTime: Double) {
        currentStart = startTime
        currentEnd = endTime
        longTime = currentEnd! - currentStart!
        let url =  NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(fileNmae, ofType: "mp3")!)
        do {
            player = try AVAudioPlayer(contentsOfURL: url)

            player!.numberOfLoops = 0
            player!.enableRate = true
            timer = NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: #selector(MP3Player.playProgress), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
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
    
    func initWithFileMp3(fileNmae: String){
        
        if(player != nil){
            player = nil
        }
        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(fileNmae, ofType: "mp3")!)
        do {
            player = try AVAudioPlayer(contentsOfURL: url)
            player?.prepareToPlay()
        }
        catch {
        
        }
      }
    
    func play() {
        if player?.playing == false {
             player?.play()
        }
    }
    
    func stop(){
        if player?.playing == true {
            player?.stop()
            player?.currentTime = 0
        }
    }
    
    func pause(){
        if player?.playing == true{
            player?.pause()
        }
    }
    
}

