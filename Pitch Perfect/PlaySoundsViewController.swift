//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Joseph Balsamo on 11/15/15.
//  Copyright © 2015 Joseph Balsamo. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var audioPlayerEcho: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
            audioPlayerEcho = try AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
            audioPlayer.enableRate = true
        } catch {
            print("couldn't load file :(")
        }
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func resetAndStop() {
        audioPlayer.stop()
        audioPlayer.rate = 1
        audioPlayerEcho.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        resetAndStop()
        audioPlayer.currentTime = 0.0
        audioPlayerEcho.currentTime = 0.15
        audioPlayer.play()
        audioPlayerEcho.play()
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        resetAndStop()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let unitReverb = AVAudioUnitReverb()
        unitReverb.wetDryMix = 75
        audioEngine.attachNode(unitReverb)
        
        audioEngine.connect(audioPlayerNode, to: unitReverb, format: nil)
        audioEngine.connect(unitReverb, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        resetAndStop()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    
    func playAudioAtSpeed(speed: Float) {
        resetAndStop()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioAtSpeed(0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioAtSpeed(2.0)
    }
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayerEcho.stop()
        audioEngine.stop()
    }
}
