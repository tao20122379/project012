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
    
    override init(){
        //tracks = FileReader.readFiles()
        super.init()
        
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

