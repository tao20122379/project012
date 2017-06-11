//
//  AudioExplainView.swift
//  ToeicTest
//
//  Created by khactao on 4/19/17.
//
//

import UIKit
import AVFoundation

class AudioExplainView: UIView, AVAudioPlayerDelegate {
    
    // MARK: - IBOutleft and variable
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var progressController: UISlider!
    @IBOutlet weak var startTimeLablel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
   // @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedStep: UIStepper!
    
    var avPlayer: AVAudioPlayer?
    var timer: NSTimer?
    var beginTimerString: String?
    var endTimerString: String?
    var currentStart: NSTimeInterval?
    var currentEnd: NSTimeInterval?
    var longTime: NSTimeInterval?
    var disk: CADisplayLink?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
    }

    // MARK: - Funcion
    func audioPlayWithName(fileNmae: String, startTime: Double, endTime: Double) {
               speedStep.minimumValue = 5
        speedStep.maximumValue = 15
        speedStep.value = 10
        currentStart = startTime
        currentEnd = endTime
       
        longTime = currentEnd! - currentStart!
        let url =  NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(fileNmae, ofType: "mp3")!)
        do {
            avPlayer = try AVAudioPlayer(contentsOfURL: url)
            avPlayer!.delegate = self
            avPlayer!.numberOfLoops = 0
            avPlayer?.enableRate = true
            self.endTimeLabel.text = endString()
            self.startTimeLablel.text = beginString()
            timer = NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: #selector(AudioExplainView.playProgress), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
            avPlayer?.currentTime = self.currentStart!
            avPlayer?.play()
        }
        catch {
            
        }
    }
    
    func playProgress() {
        if self.avPlayer!.currentTime - self.currentStart! < self.longTime {
            self.progress.progress = Float((self.avPlayer!.currentTime-self.currentStart!)/self.longTime!)
            self.progressController.value =  self.progress.progress
            self.startTimeLablel.text = beginString()
        }
        else if ((self.avPlayer!.currentTime - currentStart!) >= self.longTime) {
            self.stopMusic()
        }
    }
    
    func beginString() -> String {
        return String(format: "%.2d:%.2d", Int((self.avPlayer!.currentTime - currentStart!)/60), Int(self.avPlayer!.currentTime - currentStart!)%60)
    }
    
    func endString() -> String {
        return String(format: "%.2d:%.2d", Int(self.longTime!/60), Int(self.longTime!%60))
    }
    
    func stopMusic() {
        self.timer?.invalidate()
        self.avPlayer!.stop()
        self.avPlayer!.currentTime = self.currentStart!
        self.progress.progress = 0
        self.progressController.value = 0
        self.startTimeLablel.text = self.beginString()
        self.playPauseButton.setBackgroundImage(UIImage(named: "pause1"), forState: .Normal)
        
    }
    
    // MARK: - Audio Delegate
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        self.playPauseButton.setBackgroundImage(UIImage(named: "pause1"), forState: .Normal)
    }
    
    
    @IBAction func stopSelected(sender: AnyObject) {
        self.timer?.invalidate()
        self.avPlayer!.stop()
        self.avPlayer!.currentTime = self.currentStart!
        self.avPlayer?.prepareToPlay()
        self.startTimeLablel.text = beginString()
        self.progress.progress = 0
        self.progressController.value = 0
        self.playPauseButton.setBackgroundImage(UIImage(named: "pause1"), forState: .Normal)
        
    }
    
    @IBAction func playPauseSelected(sender: UIButton) {
        if avPlayer!.playing {
            sender.setBackgroundImage(UIImage(named: "pause1"), forState: .Normal)
            self.avPlayer!.pause()
            timer?.invalidate()
        }
            
        else {
            sender.setBackgroundImage(UIImage(named: "play1"), forState: .Normal)
            self.avPlayer!.play()
            timer = NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: #selector(AudioExplainView.playProgress), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)

        }
        
    }
    
    @IBAction func stepValuchange(sender: UIStepper) {
        self.speedLabel.text = String(format: "%.1f", sender.value/10)
        avPlayer?.rate = Float(sender.value/10)
    }
    
    @IBAction func progressControllerSelected(sender: UISlider) {
        self.progressController.value = sender.value
        self.progress.progress = sender.value
        self.avPlayer!.currentTime = Double(sender.value) * self.longTime! + self.currentStart!
    }
    

}
