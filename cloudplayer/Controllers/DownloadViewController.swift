//
//  DownloadViewController.swift
//  cloudplayer
//
//  Created by chandra kiran on 26/03/23.
//

import UIKit

class DownloadViewController: UIViewController {
    var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    var audioFiles: [URL] = []
    let fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        fetchLocalAudioFiles()
    }
    
    func fetchLocalAudioFiles() {
//        do {
//            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            let audioFiles = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles).filter { $0.pathExtension == "mp3" }
//            self.audioFiles = audioFiles
//            tableView.reloadData()
//        } catch {
//            print("Error fetching local audio files: \(error.localizedDescription)")
//        }
        // Start the search in the root directory
//        _ = try? fileManager.url(for: .downloadsDirectory, in: .localDomainMask, appropriateFor: nil, create: false); else {
//            print(audioFiles)
//               return audioFiles
//           }
        
        
        
    }
}

extension DownloadViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let audioFileURL = audioFiles[indexPath.row]
        cell.textLabel?.text = audioFileURL.lastPathComponent
        return cell
    }
}

extension DownloadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let audioFileURL = audioFiles[indexPath.row]
//        let playerViewController = PlaybackPresenter.shared.startPlayBack(from: self, url: audioFileURL)
        }
}
