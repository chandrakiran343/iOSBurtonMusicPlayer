//
//  MusicViewController.swift
//  cloudplayer
//
//  Created by chandra kiran on 31/03/23.
//

import UIKit
import AVFoundation

class MusicPlayer{
    var audioPlayer: AVAudioPlayer?
    
    func loadAudioFile(withName name: String, andExtension fileExtension: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: fileExtension) else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("Error loading audio file: \(error.localizedDescription)")
        }
    }
    
    func play(){
        audioPlayer?.play()
    }
    
    func pause(){
        audioPlayer?.pause()
    }
    
    @objc func playtapped(){
        audioPlayer?.play()
    }
    @objc func pausetapped(){
        audioPlayer?.pause()
    }
}
class MusicViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let player = MusicPlayer()
        player.loadAudioFile(withName: "", andExtension: "mp3")
        // Do any additional setup after loading the view.
    }
    

   

}
