//
//  DownloadViewController.swift
//  cloudplayer
//
//  Created by chandra kiran on 26/03/23.
//

import UIKit
import MediaPlayer	
import SwiftAudioPlayer

class DownloadViewController: UIViewController, UISearchBarDelegate {
    var tableView: UITableView = {
        var table:UITableView
        if #available(iOS 13.0, *) {
            table = UITableView(frame: .zero, style: .insetGrouped)
        } else {
            // Fallback on earlier versions
            table = UITableView(frame: .zero)
        }
        table.register(DownloadTableViewCell.self, forCellReuseIdentifier: DownloadTableViewCell.identifier)
        return table
    }()
    var filteredData: [Song]!
    private let searchBar: UISearchBar = {
//        let search = UISearchBar(frame: CGRect(x:0,y:0,width:100,height: 120))
        let search = UISearchBar()
        
        search.placeholder = "Search for the Audio here"
        return search
    }()
    var audioFiles: [Song] = []
    var ogData: [Song] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
            
        audioFiles = MainTabBarViewController.downloadedFiles
            
        ogData = audioFiles
        tableView.reloadData()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self

        tableView.tableHeaderView = searchBar
    
        searchBar.sizeToFit()

        tableView.tableHeaderView?.frame.size.height = searchBar.frame.size.height
        
        filteredData = audioFiles
        
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.count == 0 ? ogData : audioFiles.filter{ (item: Song)->Bool in
            return item.name.range(of: searchText, options: .caseInsensitive,range: nil,locale: nil) != nil
        }
        // setup to handle index out of bounds error while no search results
        audioFiles = filteredData
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        audioFiles = ogData
    }

}

extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return audioFiles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DownloadTableViewCell.identifier, for: indexPath) as? DownloadTableViewCell else {
            return UITableViewCell()
        }
        if(indexPath.row < audioFiles.count){
        let song = audioFiles[indexPath.row]
            
        cell.configure(song: song)
            
        
        cell.textLabel?.textAlignment = .natural
        cell.textLabel?.textColor = .white

        return cell
        }
        else{
            print(indexPath.row)
            print("ripped")
        }
        cell.backgroundColor = .cyan
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = audioFiles[indexPath.row]
        
        PlaybackPresenter.shared.startPlayBack(from: self , track: song)
    }
}

