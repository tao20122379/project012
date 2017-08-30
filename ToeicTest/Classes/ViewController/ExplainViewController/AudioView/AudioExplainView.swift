//
//  AudioExplainView.swift
//  ToeicTest
//
//  Created by khactao on 4/19/17.
//
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
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class AudioExplainView: UIView, AVAudioPlayerDelegate {
    
    // MARK: - IBOutleft and variable
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var progressController: UISlider!
    @IBOutlet weak var startTimeLablel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedStep: UIStepper!
    
    var avPlayer: AVAudioPlayer?
    var timer: Timer?
    var beginTimerString: String?
    var endTimerString: String?
    var currentStart: TimeInterval?
    var currentEnd: TimeInterval?
    var longTime: TimeInterval?
    var disk: CADisplayLink?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }

    // MARK: - Funcion
    func audioPlayWithName(_ fileNmae: String, startTime: Double, endTime: Double) {
        speedStep.minimumValue = 5
        speedStep.maximumValue = 15
        speedStep.value = 10
        currentStart = startTime
        currentEnd = endTime
       
        longTime = currentEnd! - currentStart!
        let url =  URL(fileURLWithPath: Bundle.main.path(forResource: fileNmae, ofType: "mp3")!)
        do {
            avPlayer = try AVAudioPlayer(contentsOf: url)
            avPlayer!.delegate = self
            avPlayer!.numberOfLoops = 0
            avPlayer?.enableRate = true
            self.endTimeLabel.text = endString()
            self.startTimeLablel.text = beginString()
            timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(AudioExplainView.playProgress), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
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
            playPauseButton.setBackgroundImage(UIImage(named: "play1"), for: UIControlState())
            self.avPlayer!.play()
            timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(AudioExplainView.playProgress), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)

        }
    }
    
    func beginString() -> String {
        return String(format: "%.2d:%.2d", Int((self.avPlayer!.currentTime - currentStart!)/60), Int(self.avPlayer!.currentTime - currentStart!)%60)
    }
    
    func endString() -> String {
        return String(format: "%.2d:%.2d", Int(self.longTime!/60), Int(self.longTime!.truncatingRemainder(dividingBy: 60)))
    }
    
    func stopMusic() {
        self.timer?.invalidate()
        self.avPlayer!.stop()
        self.avPlayer!.currentTime = self.currentStart!
        self.progress.progress = 0
        self.progressController.value = 0
        self.startTimeLablel.text = self.beginString()
        self.playPauseButton.setBackgroundImage(UIImage(named: "pause1"), for: UIControlState())
        
    }
    
    // MARK: - Audio Delegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playPauseButton.setBackgroundImage(UIImage(named: "pause1"), for: UIControlState())
    }
    
    
    @IBAction func stopSelected(_ sender: AnyObject) {
        self.timer?.invalidate()
        self.avPlayer!.stop()
        self.avPlayer!.currentTime = self.currentStart!
        self.avPlayer?.prepareToPlay()
        self.startTimeLablel.text = beginString()
        self.progress.progress = 0
        self.progressController.value = 0
        self.playPauseButton.setBackgroundImage(UIImage(named: "pause1"), for: UIControlState())
        
    }
    
    @IBAction func playPauseSelected(_ sender: UIButton) {
        if avPlayer!.isPlaying {
            sender.setBackgroundImage(UIImage(named: "pause1"), for: UIControlState())
            self.avPlayer!.pause()
            timer?.invalidate()
        }
            
        else {
            sender.setBackgroundImage(UIImage(named: "play1"), for: UIControlState())
            self.avPlayer!.play()
            timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(AudioExplainView.playProgress), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)

        }
        
    }
    
    @IBAction func stepValuchange(_ sender: UIStepper) {
        self.speedLabel.text = String(format: "%.1f", sender.value/10)
        avPlayer?.rate = Float(sender.value/10)
    }
    
    @IBAction func progressControllerSelected(_ sender: UISlider) {
        self.progressController.value = sender.value
        self.progress.progress = sender.value
        self.avPlayer!.currentTime = Double(sender.value) * self.longTime! + self.currentStart!
    }
    

}
