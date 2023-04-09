//
//  DownloadTableViewCell.swift
//  cloudplayer
//
//  Created by chandra kiran on 08/04/23.
//

import UIKit

class DownloadTableViewCell: UITableViewCell {
    
    static let identifier: String = "DownloadCell"
    
    private let songTitleLabel = UILabel()
        private let artistNameLabel = UILabel()
        
//    private var selected:Int = 0
    var data: Data!
    var name: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           
           // Configure subviews
           songTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
           artistNameLabel.font = UIFont.systemFont(ofSize: 14)
           
           
           // Add subviews
           contentView.addSubview(songTitleLabel)
           contentView.addSubview(artistNameLabel)
           
           
           // Set up constraints
           songTitleLabel.translatesAutoresizingMaskIntoConstraints = false
           artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
           
           NSLayoutConstraint.activate([
               songTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
               songTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
               songTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
               
               artistNameLabel.topAnchor.constraint(equalTo: songTitleLabel.bottomAnchor, constant: 4),
               artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
               artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
               
           ])
       }
    
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    func configure(song: Song) {
        songTitleLabel.text = song.name
        artistNameLabel.text = song.artist
    }
}
