//
//  ViewController.swift
//  cloudplayer
//
//  Created by chandra kiran on 26/03/23.
//
import Foundation
import UIKit
import MediaPlayer
import SwiftyDropbox

class MainTabBarViewController: UITabBarController {
    
    @objc func logoutProcess(){
        print("pressed logout")
        DropboxClientsManager.unlinkClients()
        let window = UIApplication.shared.windows.first
        let nav = UINavigationController(rootViewController: LoginViewController())
        nav.navigationBar.prefersLargeTitles = true
        nav.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    static let downloadedFiles:[Song] = {
        
        var songs: [Song] = []
        
        let storage = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(storage)
        do{
            let files = try FileManager.default.contentsOfDirectory(at: storage.first!, includingPropertiesForKeys: nil    )
            
            print("hello",files)
            print()
            for file in files{
                let url = file.absoluteURL
                let item = AVAsset(url: file)
                let commonmeta = item.commonMetadata
                
                let filename = file.absoluteString.split(separator: "/").last?.removingPercentEncoding
                let components = filename?.split(separator: ".")
                var title: String = ""
                if components!.count > 1{
                    title = (components?.dropLast().joined(separator: "."))!
                }else{
                    title = filename!
                }
//                let Titlemetadata = AVMetadataItem.metadataItems(from: commonmeta, withKey: AVMetadataKey.commonKeyTitle, keySpace: AVMetadataKeySpace.common).first
                let ArtistMetaData = AVMetadataItem.metadataItems(from: commonmeta, withKey: AVMetadataKey.commonKeyArtist, keySpace: AVMetadataKeySpace.common)
                let albumnameMetaData = AVMetadataItem.metadataItems(from: commonmeta, withKey: AVMetadataKey.commonKeyAlbumName, keySpace: AVMetadataKeySpace.common)
                let ArtmeMetaData = AVMetadataItem.metadataItems(from: commonmeta, withKey: AVMetadataKey.commonKeyArtwork, keySpace: AVMetadataKeySpace.common)
 //                print(ArtistMetaData.first?.stringValue)
                
                let song = Song(name: (title), artist: ArtistMetaData.first?.stringValue, albumname: albumnameMetaData.first?.stringValue, duration: Double(CMTimeGetSeconds(item.duration)), albumArt: UIImage(data: ArtmeMetaData.first?.dataValue ?? Data()), url: url.absoluteString, downloadlink: url,downloaded: true)
                
                 
                songs.append(song)
            }
        }catch{
            print(error)
        }
        
        
        let media = MPMediaQuery.songs()
        let items = media.items
        
        if (items == nil){
            return []
        }
        
        for item in items! {
            let url = item.assetURL
            let song = Song(name: item.title ?? "Unnamed", artist: item.artist, albumname: item.albumTitle, duration: item.playbackDuration, albumArt: item.artwork?.image(at: CGSize(width: 500, height: 500)), url: "", downloadlink: url,downloaded: true)
            songs.append(song)
        }
        return songs
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            view.backgroundColor = .white
        }
        
        
        
        
        let c1 = HomeViewController()
        let c2 = UploadViewController()
        let c3 = DownloadViewController()
        
        
        let logout = UIButton()
        logout.setTitle("Logout", for: .normal)
        logout.setTitleColor(.red, for: .normal)
        
        logout.addTarget(self, action: #selector(logoutProcess), for: .touchUpInside)
        
        logout.frame = CGRect(x: view.width - view.safeAreaInsets.right - 80, y: 20, width: 80, height: 60)
        
        view.addSubview(logout)
        
        c1.navigationItem.largeTitleDisplayMode = .always
        c2.navigationItem.largeTitleDisplayMode = .always
        c3.navigationItem.largeTitleDisplayMode = .always
        
        c1.title = "Home"
        c2.title = "Uploads"
        c3.title = "Downloads"
        
        let vc1 = UINavigationController(rootViewController: c1)
        let vc2 = UINavigationController(rootViewController: c2)
        let vc3 = UINavigationController(rootViewController: c3)
        
        vc1.navigationBar.prefersLargeTitles = true
        vc2.navigationBar.prefersLargeTitles = true
        vc3.navigationBar.prefersLargeTitles = true
        
        
        
        if #available(iOS 13.0, *) {
            vc1.tabBarItem.image = UIImage(systemName: "house")
            vc2.tabBarItem.image = UIImage(systemName: "arrow.up")
            vc3.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        } else {
            // Fallback on earlier versions
            vc1.tabBarItem.image = UIImage(named: "home")
            vc2.tabBarItem.image = UIImage(named: "upload")
            vc3.tabBarItem.image = UIImage(named: "downloading")
        }
        
        
//        vc1.navigationItem.
        
        
        
        if #available(iOS 13.0, *) {
            tabBar.tintColor = .label
        } else {
            // Fallback on earlier versions
            tabBar.tintColor = .clear
        }
        
        setViewControllers([vc1,vc2,vc3], animated: true)
        
//        MainTabBarViewController().viewControllers = [SearchBarViewController()]	
    }

}

