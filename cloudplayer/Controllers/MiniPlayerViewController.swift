//
//  MiniPlayerViewController.swift
//  cloudplayer
//
//  Created by chandra kiran on 10/04/23.
//

import UIKit

class MiniPlayerViewController: UIViewController {
    
    var songName = UILabel()
    var artistName = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.songName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.artistName.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.songName.backgroundColor = .clear
        self.artistName.backgroundColor = .clear
        self.songName.textAlignment = .left
        self.artistName.textAlignment = .left
        self.songName.translatesAutoresizingMaskIntoConstraints = false
        self.artistName.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cyan
        
        
        view.addSubview(songName)
        view.addSubview(artistName)
        // Do any additional setup after loading the view.
    }
    
    func setSongName(name:String){
        self.songName.text = name
        self.viewDidLoad()
    }
    func setArtistName(name:String){
        self.artistName.text = name
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
