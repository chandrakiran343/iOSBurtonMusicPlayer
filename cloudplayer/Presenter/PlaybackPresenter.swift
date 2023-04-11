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
    
    var track: Song?
    var tracks = [Song]()
    
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
    var songId: Int!
    var songdata: Data!
    var navvc: UIViewController?
    var presenter: UIViewController!
//    private var song:Song?
    
    func startPlayBack(from viewcontroller: UIViewController,track: Song,tracks: [Song], index : IndexPath){
        SAPlayer.shared.engine?.prepare()
        self.tracks = tracks
        self.track = tracks[index.row]
        self.songId = index.row
        self.presenter = viewcontroller
        let vc = MusicViewController()
//        vc.title = track.name
        
        vc.modalPresentationStyle = .overFullScreen
        if #available(iOS 13.0, *) {
            vc.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        vc.dataSource = self
        
        
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
            SAPlayer.shared.play()
        }
        navvc = UINavigationController(rootViewController: vc)
        self.presenting(vc: viewcontroller)
    }
    
    func presenting(vc: UIViewController){
        vc.present(navvc!, animated: true, completion: nil)
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
