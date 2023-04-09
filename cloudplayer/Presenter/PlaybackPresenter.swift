//
//  PlaybackPresenter.swift
//  cloudplayer
//
//  Created by chandra kiran on 01/04/23.
//

import Foundation
import UIKit
import SwiftyDropbox
import SwiftAudioPlayer
import AVFoundation

protocol playerDataSource:AnyObject {
    var name:String? {get}
    var artist:String?{get}
    var imageurl:URL?{get}
    var song:Song?{get}
    var albumArt:UIImage?{get}
}

final class PlaybackPresenter: playerDataSource{
    
    static let shared = PlaybackPresenter()
    
    private var track: Song?
    private var tracks = [Song]()
    
    var currentTrack :Song? {
        if let track = track{
            return track
        }
        else if !tracks.isEmpty{
            return tracks.first
        }
        return nil
    }
    
    var audioplayer: AVPlayer?
    
    var songdata: Data!
    var navvc: UIViewController?
//    private var song:Song?
    func startPlayBack(from viewcontroller: UIViewController,track: Song){
        
        let vc = MusicViewController()
//        vc.title = track.name
        self.track = track
        self.tracks.append(track)
        vc.modalPresentationStyle = .popover
        vc.dataSource = self
        SAPlayer.shared.engine?.prepare()
        print(track.downloadlink?.absoluteString)
        let array = track.downloadlink?.absoluteString.split(separator: ".")
        let key:String
        if(array!.count>2){
            key = String(array![2])
        }
        else{
            key = ""
        }
        if( key == "dropboxusercontent"){
            SAPlayer.shared.clear()
            SAPlayer.shared.startRemoteAudio(withRemoteUrl: track.downloadlink!)
        }
        else{
            SAPlayer.shared.clear()
            SAPlayer.shared.startSavedAudio(withSavedUrl: track.downloadlink!)
        }
        navvc = UINavigationController(rootViewController: vc)
//        navvc.setNavigationBarHidden(true, animated: true)
        viewcontroller.present(navvc!, animated: true, completion: nil)
    }
}
    

extension PlaybackPresenter{
    var name:String?{
        return currentTrack?.name
    }
    var artist: String?{
        return currentTrack?.artist
    }
    var imageurl: URL?{
        return nil 
    }
    var song:Song?{
        return currentTrack
    }
    var albumArt: UIImage?{
        return currentTrack?.albumArt ?? UIImage(named: "icon")
    }
}
