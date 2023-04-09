//
//  CollectionViewTableViewCell.swift
//  cloudplayer
//
//  Created by chandra kiran on 26/03/23.
//

import UIKit
import SwiftyDropbox
import AVFoundation

import SwiftAudioPlayer

struct Song{
    let name: String
    var artist: String?
    let albumname: String?
    let duration: Double?
    var albumArt: UIImage?
    let url : String?
    var downloadlink: URL?
    var downloaded: Bool?
}



class CollectionViewTableViewCell: UITableViewCell{
    
    static let identifier = "SongViewTableViewCell"

    private let songTitleLabel = UILabel()
        private let artistNameLabel = UILabel()
        private let albumNameLabel = UILabel()
        private let durationLabel = UILabel()
    
//    private var selected:Int = 0
    var data: Data!
    var name: String!
//    private var audioplayer: AVAudioPlayer!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           
           // Configure subviews
           songTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
           artistNameLabel.font = UIFont.systemFont(ofSize: 14)
           albumNameLabel.font = UIFont.systemFont(ofSize: 14)
           durationLabel.font = UIFont.systemFont(ofSize: 14)
           
           // Add subviews
           contentView.addSubview(songTitleLabel)
           contentView.addSubview(artistNameLabel)
           contentView.addSubview(albumNameLabel)
           contentView.addSubview(durationLabel)
            
           
           // Set up constraints
           songTitleLabel.translatesAutoresizingMaskIntoConstraints = false
           artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
           albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
           durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
           
           NSLayoutConstraint.activate([
               songTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
               songTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
               songTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
               
               artistNameLabel.topAnchor.constraint(equalTo: songTitleLabel.bottomAnchor, constant: 4),
               artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
               artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
               
               albumNameLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 4),
               albumNameLabel.leadingAnchor.constraint(equalTo:	 contentView.leadingAnchor, constant: 16),
               albumNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
               
               durationLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 4),
               durationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
               durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
               durationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
           ])
        
       }
//    override func layoutSubviews() {
//
////        downloadButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
//
//
//    }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       // MARK: - Configure Cell
       
       func configure(song: Song) {
           songTitleLabel.text = song.name
           artistNameLabel.text = song.artist
           albumNameLabel.text = song.albumname
        durationLabel.text = "\(song.duration ?? 0.0)"
       }
    
    
}
