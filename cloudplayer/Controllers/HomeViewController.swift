//
//  HomeViewController.swift
//  cloudplayer
//
//  Created by chandra kiran on 26/03/23.
//
import SwiftyDropbox
import UIKit
import AVFoundation
//import PromiseKit

class HomeViewController: UIViewController,UISearchBarDelegate {
    
    var filenames: [Song] = []
    weak var table : UITableView!
    private let client: DropboxClient? = {
        return DropboxClientsManager.authorizedClient
    }()
    
    private let homeFeed : UITableView = {
        var table:UITableView
        if #available(iOS 13.0, *) {
            table = UITableView(frame: .zero, style: .insetGrouped)
        } else {
            // Fallback on earlier versions
            table = UITableView(frame: .zero, style: .grouped)
        }
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    let data = ["hello", "kiloo","syboo"]
    
    var filteredData: [Song]!
    private let searchBar: UISearchBar = {
//        let search = UISearchBar(frame: CGRect(x:0,y:0,width:100,height: 120))
        let search = UISearchBar()
        
        search.placeholder = "Search for the Audio here"
        return search
    }()
    
    func getFiles() {
        self.filenames = []
        listAudioFiles(path: "")
    }
    
    func listAudioFiles(path:String){
        client?.files.listFolder(path: path).response{response,error in
            if let response = response{
                print(response)
                for entry in response.entries{
                    
                    if(entry.name.hasSuffix("mp3") || entry.name.hasSuffix("m4a")){
                        print(entry.name)
                        DispatchQueue.global(qos: .background) .async {
                            self.client?.files.getTemporaryLink(path: entry.pathLower!).response{ response,error in
                                        if let link = response?.link{
                                            do{
                                                let url = URL(string: link )!
                                               let asset = AVAsset(url: url)
                                                let rip = asset.metadata
                                                let artworkdata = AVMetadataItem.metadataItems(from: rip, filteredByIdentifier: AVMetadataIdentifier.commonIdentifierArtwork)
                                                var albumart: UIImage?
                                                if(artworkdata.first != nil){
                                                   
                                                albumart = UIImage(data: (artworkdata.first?.dataValue)!)
                                                }
                                                
                                                
                                                let song = Song(name: entry.name, artist:"Unknown", albumname: nil,duration: " " ,albumArt: albumart,url:entry.pathLower ?? "/", downloadlink: url)
                                                self.filenames.append(song)
                                                self.homeFeed.reloadData()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                for folder in response.entries where folder is Files.FolderMetadata{
                    self.listAudioFiles(path: folder.pathLower!)
                }
                    }
                }
    }
    override func viewDidAppear(_ animated: Bool) {
        if let indexPath = homeFeed.indexPathForSelectedRow{
            homeFeed.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFiles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            view.backgroundColor = .white
        }
        
        
        view.addSubview(homeFeed)
    
        
        homeFeed.delegate = self
        homeFeed.dataSource = self
        searchBar.delegate = self
//        searchBar.dataSource = self.filenames
        homeFeed.tableHeaderView = searchBar
    
        searchBar.sizeToFit()

        homeFeed.tableHeaderView?.frame.size.height = searchBar.frame.size.height
        
        filteredData = filenames
        
        // Do any additional setup after loading the view.
    }
    public func getSomething(){
        
        print("Api method called")
        
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeed.frame = view.bounds
        homeFeed.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? filenames: filenames.filter{ (item: Song)->Bool in
            return item.name.range(of: searchText, options: .caseInsensitive,range: nil,locale: nil) != nil
        }
        print("debug point for search")
        // setup to handle index out of bounds error while no search results
        print(filteredData as Any)
//        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        print(filenames)
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int{
        return filenames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        if(indexPath.row < filenames.count){
        let song = filenames[indexPath.row]
            
            print(indexPath.row)
        cell.configure(song: song)
            
        
        cell.textLabel?.textAlignment = .natural
            cell.textLabel?.textColor = .white
//        cell.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.0)
            	

        return cell
        }
        else{
            print(indexPath.row)
            print("ripped")
        }
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var songName: String = ""
        let song: Song?
        if (indexPath.row < filenames.count){
            song = filenames[indexPath.row]
            songName = song!.name
    //        let queue = DispatchQueue(label: "download queue")
//            DispatchQueue.global(qos: .background).async{
//                PlaybackPresenter.shared.downloadSong(name:song!.name, path: song?.url ?? "/")
//            }
            PlaybackPresenter.shared.startPlayBack(from: self,track: song!)
        }
        else{
            print(indexPath.row)
            print("something's fucked up")
        }
        
        
        print(songName)
//        Dispatch.main.async(){
//            let asset = AVAsset(url: (URL(string: "https://vgmsite.com/soundtracks/club-nintendo-picross-3ds-gamerip-2012/ygyogizjed/01.%20Home%20Menu%20Banner.mp3") ?? URL(string:"/"))!)
//            let artWorkItems = AVMetadataItem.metadataItems(from: asset.metadata, filteredByIdentifier: AVMetadataIdentifier.commonIdentifierArtwork)
//            if let artWorkItem = artWorkItems.first, let imageData = artWorkItem.dataValue{
//                let albumArt = UIImage(data: imageData)
//                song.albumArt = albumArt
//                print(albumArt)
//            }
//            else{
//                print("Album art not there")
//            }
//        }
    
        
        
            
        
    }
}

