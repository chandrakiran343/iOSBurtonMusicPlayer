//
//  MusicView.swift
//  cloudplayer
//
//  Created by chandra kiran on 01/04/23.
//

import UIKit


protocol playerControlsDelegate: AnyObject {
    func playertappedplay(_ musicview: MusicView)
    func playertappedpause(_ musicview: MusicView)
    func playertappedforward(_ musicview: MusicView)
    func playertappedbackward(_ musicview:MusicView)
}

struct titles{
    var title:String?
    var subtitles:String?
}
class MusicView: UIView {
    
    weak var delegate: playerControlsDelegate?
    weak var dataSource: playerDataSource?
    private let volumeSlider:UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private var nameLabel: UILabel={
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .semibold)
//        label.text = "this is what you came for"
        return label
    }()
    
    private var subtitle: UILabel={
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
//        label.text = "calvin harris, rihanna"
        return label
    }()
    
    private let backbutton:UIButton={
        let button  = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
        button.setImage( image, for: .normal)
        return button
    }()
    private let forwardbutton:UIButton={
        let button  = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
        button.setImage( image, for: .normal)
        return button
    }()
    private let playbutton:UIButton={
        let button  = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
        button.setImage( image, for: .normal)
        return button
    }()
   
    let songTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitle)
        addSubview(volumeSlider)
        
        addSubview(backbutton)
        addSubview(playbutton)
        addSubview(forwardbutton)
        
        backbutton.addTarget(self, action: #selector(didtapback), for: .touchUpInside)
        forwardbutton.addTarget(self, action: #selector(didtapforward), for: .touchUpInside)
        playbutton.addTarget(self, action: #selector(didtappause), for: .touchUpInside)
        
        
    }
    
    @objc func didtapback(){
        delegate?.playertappedbackward(self)
    }
    @objc func didtapforward(){
        delegate?.playertappedforward(self)
    }
    @objc func didtappause(){
        delegate?.playertappedpause(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 0, y: 20, width: width, height: 50)
        subtitle.frame = CGRect(x: 0, y: nameLabel.bottom+10, width: width, height: 50)
        
        volumeSlider.frame = CGRect(x: 10, y: subtitle.bottom+20, width: width-20, height: 44)
        let buttonSize:CGFloat = 40
        
//        playbutton.frame = CGRect(x: (width - buttonSize)/2, y: volumeSlider.bottom+30, width: buttonSize, height: buttonSize)
//
//        backbutton.frame = CGRect(x: playbutton.left - 80, y: playbutton.top, width: buttonSize, height: buttonSize)
//        forwardbutton.frame = CGRect(x: playbutton.right + 80, y: playbutton.top, width: buttonSize, height: buttonSize)
        playbutton.frame = CGRect(x: (width-buttonSize)/2, y: volumeSlider.bottom+20, width: buttonSize, height: buttonSize)
        backbutton.frame = CGRect(x: playbutton.left - 80 - buttonSize, y: playbutton.top, width: buttonSize, height: buttonSize)
        forwardbutton.frame = CGRect(x: playbutton.right + 80, y: playbutton.top, width: buttonSize, height: buttonSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with titles: titles){
        nameLabel.text = titles.title
        subtitle.text = titles.subtitles
    }
}
