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
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    let data = ["hello", "kiloo","syboo"]
    
    var filteredData: [String]!
    private let searchBar: UISearchBar = {
//        let search = UISearchBar(frame: CGRect(x:0,y:0,width:100,height: 120))
        let search = UISearchBar()
        
        search.placeholder = "Search for the Audio here"
        return search
    }()
    
    func getFiles() {
        self.filenames = []
        client?.files.listFolder(path: "").response{response,error in
            if let response = response{
                print(response)
                for entry in response.entries{
                    
                    if(entry.name.hasSuffix("mp3") || entry.name.hasSuffix("m4a")){
                        print(entry.name)
                        let song = Song(name: entry.name, artist:"Unknown", albumname: nil,duration: " " ,albumArt: nil,url:entry.pathLower ?? "/")
                        self.filenames.append(song)
                        self.homeFeed.reloadData()
                    }
                    
//                    self.tableView.reload
                }
                
            }
            else{
                print("Api rippped")
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
        view.backgroundColor = .systemBackground
        
        
        view.addSubview(homeFeed)
    
        
        homeFeed.delegate = self
        homeFeed.dataSource = self
//        searchBar.delegate = self.filenames
//        searchBar.dataSource = self.filenames
        homeFeed.tableHeaderView = searchBar
    
        searchBar.sizeToFit()

        homeFeed.tableHeaderView?.frame.size.height = searchBar.frame.size.height
        
        filteredData = data
        
        
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
        filteredData = searchText.isEmpty ? data : data.filter{ (item: String)->Bool in
            return item.range(of: searchText, options: .caseInsensitive,range: nil,locale: nil) != nil
        }
        // setup to handle index out of bounds error while no search results
//        print(filteredData[0])
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

        let song = filenames[indexPath.row]
        print(indexPath.row)
        cell.configure(song: song)
        
        
        cell.textLabel?.textAlignment = .natural
        cell.backgroundColor = .systemBlue

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
        let song:Song = filenames[indexPath.row]
        songName = song.name
//        let queue = DispatchQueue(label: "download queue")
        DispatchQueue.global(qos: .background).async{
            PlaybackPresenter.shared.downloadSong(name:song.name, path: song.url ?? "/")
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
    
        
        
            
        PlaybackPresenter.shared.startPlayBack(from: self,track: song)
    }
}

