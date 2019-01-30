//
//  ViewController.swift
//  AudioRecorder
//
//  Created by siddharth on 30/01/19.
//  Copyright © 2019 clarionTechnologies. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playStopButtonEnabledFalse()
        recorderSettings()
    }
    
 
}

extension ViewController {
    
    func playStopButtonEnabledFalse(){
        playButton.isEnabled = false
        stopButton.isEnabled = false
    }
    
    func recorderSettings(){
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let soundFileUrl = path[0].appendingPathComponent("sound.caf")
        let recordingSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                                 AVEncoderBitRateKey: 16,
                                 AVNumberOfChannelsKey: 2,
                                 AVSampleRateKey: 44100.0] as [String: Any]
        let audioSession = AVAudioSession.sharedInstance()
        
        do{
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            } catch let error as NSError {
                print("Audio Session error: \(error.localizedDescription)")
            }
        
        do{
            try audioRecorder = AVAudioRecorder(url: soundFileUrl, settings: recordingSettings)
            audioRecorder?.prepareToRecord()
            } catch let error as NSError {
                print("Audio recording error: \(error.localizedDescription)")
            }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        stopButton.isEnabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play decode error")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
       
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio record Encode Error")
    }
}

extension ViewController {
    
    @IBAction func recordButtonAction(_ sender: Any) {
        if audioRecorder?.isRecording == false {
            playButton.isEnabled = false
            stopButton.isEnabled = true
            audioRecorder?.record()
        }
    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        if audioRecorder?.isRecording == false {
            stopButton.isEnabled = true
            recordButton.isEnabled = false
            
            do{
                try audioPlayer = AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            }catch let error as NSError {
                print("Error playing audio: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func stopButtonAction(_ sender: Any) {
        stopButton.isEnabled = false
        playButton.isEnabled = true
        recordButton.isEnabled = true
        
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        }else {
            audioPlayer?.stop()
        }
    }
}

