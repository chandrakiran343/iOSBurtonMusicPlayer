//
//  HomeViewController.swift
//  cloudplayer
//
//  Created by chandra kiran on 26/03/23.
//
import SwiftyDropbox
import UIKit
import AVFoundation
import AHDownloadButton

class HomeViewController: UIViewController,UISearchBarDelegate {
    
    var filenames: [Song] = []
    weak var table : UITableView!
    private let client: DropboxClient? = {
        return DropboxClientsManager.authorizedClient
    }()
    var ogData:[Song]!
    
    private let homeFeed : UITableView = {
        var table:UITableView
        if #available(iOS 13.0, *) {
            table = UITableView(frame: .zero, style: .insetGrouped)
        } else {
            // Fallback on earlier versions
            table = UITableView(frame: .zero, style: .grouped)
        }
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        table.separatorColor = .magenta
        table.separatorStyle = UITableViewCell.SeparatorStyle.singleLine		
        return table
    }()
    
    var ini = true
    var filteredData: [Song]!
    private let searchBar: UISearchBar = {
//        let search = UISearchBar(frame: CGRect(x:0,y:0,width:100,height: 120))
        let search = UISearchBar()
        
        search.placeholder = "Search for the Audio here"
        return search
    }()
    
    func getFiles() {
        self.filenames = []
        self.ogData = []
        listAudioFiles(path: "")
    }
    
    
    func listAudioFiles(path:String){
        client?.files.listFolder(path: path).response{ [self]response,error in
            if let response = response{
                print(response)
                for entry in response.entries{
                    
                    if(entry.name.hasSuffix("mp3") || entry.name.hasSuffix("m4a")){
                        DispatchQueue.global(qos: .background) .async {
                            self.client?.files.getTemporaryLink(path: entry.pathLower!).response{ response,error in
                                        if let link = response?.link{
                                            do{
                                                let url = URL(string: link )!
//                                                let asset = AVAsset(url: url)
                                                var res: Bool = false
                                                for item in MainTabBarViewController.downloadedFiles{
                                                    if (entry.name == item.name){
                                                        res = true
                                                    }
                                                }
                                                
                                                let song = Song(name: entry.name, artist:"Unknown", albumname: nil,duration: 0.0 ,albumArt:nil,url:entry.pathLower ?? "/", downloadlink: url, downloaded: res)
                                                self.filenames.append(song)
                                                self.ogData.append(song)
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
        if(self.ini){
            self.ini = false
            
            self.getFiles()
            homeFeed.delegate = self
            homeFeed.dataSource = self
        }
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
        filteredData = searchText.count == 0 ? ogData : filenames.filter{ (item: Song)->Bool in
            return item.name.range(of: searchText, options: .caseInsensitive,range: nil,locale: nil) != nil
        }
        // setup to handle index out of bounds error while no search results
        filenames = filteredData
        homeFeed.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filenames = ogData!
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, AHDownloadButtonDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        print(filenames)	
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int{
        return filenames.count
    }
    func initAction(button: AHDownloadButton, state: AHDownloadButton.State) -> Void {
        button.downloadButtonStateChangedAction!(button, state)
    }
    
    func changeState(button: AHDownloadButton, state: AHDownloadButton.State) -> Void{
        print(button.subviews)
    }
    
    @objc func download(_ sender:ScapeGoatButton){
        print("Reached the download button ", sender.id)
        
        sender.object.didTapDownloadButtonAction?(sender.object, sender.object.state)
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        if(indexPath.row < filenames.count){
        let song = filenames[indexPath.row]
            
        cell.configure(song: song)
            
        cell.textLabel?.textAlignment = .natural
        cell.textLabel?.textColor = .white
            
            
        return cell
        }
        else{
            print(indexPath.row)
            print("ripped")
        }
        return cell
    }
    

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = .groupTableViewBackground
        cell.tintColor = .systemPurple
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        cell.layoutMargins = UIEdgeInsets(top: 10.0, left: 0, bottom: 10.0, right: 0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var songName: String = ""
        let song: Song
        if (indexPath.row < filenames.count){
            song = filenames[indexPath.row]
            songName = song.name
            PlaybackPresenter.shared.startPlayBack(from: self,track: song, tracks: filenames, index: indexPath)
        }
        else{
            print(indexPath.row)
            print("something's fucked up")
        }
    }
}

