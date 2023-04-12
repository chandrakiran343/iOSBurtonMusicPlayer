//
//  MusicView.swift
//  cloudplayer
//
//  Created by chandra kiran on 01/04/23.
//

import UIKit
import AHDownloadButton


protocol playerControlsDelegate: AnyObject {
    func playertappedplay(_ musicview: MusicView)
    func playertappedpause(_ musicview: MusicView)
    func playertappedforward(_ musicview: MusicView)
    func playertappedbackward(_ musicview:MusicView)
    func playertappednext(_ musicview: MusicView)
    func playertappedprevious(_ musicview: MusicView)
    func somethingWithDuration(_ musicview:MusicView)
}

struct titles{
    var title:String?
    var subtitles:String?
}
class MusicView: UIView{
    
    weak var delegate: playerControlsDelegate?
    weak var dataSource: playerDataSource?
    let durationSlider:UISlider = {
        let slider = UISlider()
        slider.value = 0.0
        return slider
    }()
    
    private var nameLabel: UILabel={
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .semibold)
//        label.text = "this is what you came for"
        return label
    }()
    let durationLabel: UILabel! = {
        return UILabel()
    }()
    let durationFinalLabel: UILabel! = {
        return UILabel()
    }()
    private var subtitle: UILabel={
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        if #available(iOS 13.0, *) {
            label.textColor = .secondaryLabel
        } else {
            // Fallback on earlier versions
            label.textColor = .cyan
        }
//        label.text = "calvin harris, rihanna"
        return label
    }()
    let forwardButton: UIButton = {
        let button = UIButton()
        if #available(iOS 13.0, *){
            button.setImage(UIImage(systemName: "goforward.15"), for: .normal)
            button.tintColor = .magenta
        }else{
            button.setImage(UIImage(named: "forward"), for: .normal)
            
        }
        return button
    }()
    
    let backwardButton: UIButton = {
        let button = UIButton()
        
        if #available(iOS 13.0, *){
            button.setImage(UIImage(systemName: "gobackward.15"), for: .normal)
            button.tintColor = .magenta
        }else{
            button.setImage(UIImage(named: "backward"), for: .normal)
        }
        return button
    }()
    private let previousButton:UIButton={
        let button  = UIButton()
        if #available(iOS 13.0, *) {
            button.tintColor = .label
        } else {
            // Fallback on earlier versions
            button.tintColor = .magenta
        }
        let image: UIImage?
        if #available(iOS 13.0, *) {
            
            image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
        } else {
            // Fallback on earlier versions
            image = UIImage(named: "backward-arrows-couple")
        }
        button.setImage(image, for: .normal)
        return button
    }()
    private let nextButton:UIButton={
        let button  = UIButton()
        if #available(iOS 13.0, *) {
            button.tintColor = .label
        } else {
            // Fallback on earlier versions
            button.tintColor = .clear
        }
        let image: UIImage?
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
        } else {
            // Fallback on earlier versions
            image = UIImage(named: "fast-forward")
        }
        button.setImage( image, for: .normal)
        return button
    }()
        let playbutton:UIButton={
        let button  = UIButton()
        if #available(iOS 13.0, *) {
            button.tintColor = .label
        } else {
            // Fallback on earlier versions
            button.tintColor = .clear
        }
        let image: UIImage?
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
        } else {
            // Fallback on earlier versions
            image = UIImage(named: "pause")
            
        }
        button.setImage( image, for: .normal)
        return button
    }()
   
    let songTitleLabel = UILabel()
    
    let downloadButton = AHDownloadButton()
    let downloadedButton = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitle)
        downloadedButton.setTitle("Done", for: .normal)
        downloadedButton.backgroundColor = .blue
        addSubview(durationSlider)
        addSubview(durationFinalLabel)
        addSubview(durationLabel)
        addSubview(previousButton)
        addSubview(playbutton)
        addSubview(nextButton)
        addSubview(forwardButton)
        addSubview(backwardButton)
        if(!(PlaybackPresenter.shared.track?.downloaded)!){
            addSubview(downloadButton)
        }
        else{
            addSubview(downloadedButton)
        }
        
        downloadButton.downloadedButtonTitle = "Done"
        backwardButton.addTarget(self, action: #selector(didtapbackward), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(didtapforward), for: .touchUpInside)
        playbutton.addTarget(self, action: #selector(didtappause), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didtapnext), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(didtapprevious), for: .touchUpInside)
    }
    
    @objc func didtapbackward(){
        delegate?.playertappedbackward(self)
    }
    @objc func didtapforward(){
        delegate?.playertappedforward(self)
    }
    @objc func didtappause(){
        delegate?.playertappedpause(self)
    }
    @objc func didtapnext(){
        delegate?.playertappednext(self)
    }
    @objc func didtapprevious(){
        delegate?.playertappedprevious(self)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(x: 0, y: 20, width: width, height: height / 8)
        subtitle.frame = CGRect(x: 0, y: nameLabel.bottom, width: width, height: height / 16)
        
        durationSlider.frame = CGRect(x: 10, y: subtitle.bottom, width: width-20, height: 40)
        let buttonSize:CGFloat
        if #available(iOS 13.0, *){
            buttonSize = 40
        }else{
            buttonSize = 30
        }
        
//        playbutton.frame = CGRect(x: (width - buttonSize)/2, y: volumeSlider.bottom+30, width: buttonSize, height: buttonSize)
//
//        backbutton.frame = CGRect(x: playbutton.left - 80, y: playbutton.top, width: buttonSize, height: buttonSize)
//        forwardbutton.frame = CGRect(x: playbutton.right + 80, y: playbutton.top, width: buttonSize, height: buttonSize)
        durationLabel.frame = CGRect(x: durationSlider.right-55,y: durationSlider.bottom, width:80 , height: 15)
        durationFinalLabel.frame = CGRect(x: durationSlider.left,y: durationSlider.bottom, width:80 , height: 15)
        downloadButton.frame = CGRect(x: width - 50 , y: nameLabel.bottom, width: 55, height: 35)
        downloadedButton.frame = downloadButton.frame
        durationLabel.backgroundColor = .clear
        durationFinalLabel.backgroundColor = .clear
        self.delegate?.somethingWithDuration(self)
        playbutton.frame = CGRect(x: (width-buttonSize)/2, y: durationSlider.bottom + self.safeAreaInsets.bottom, width: buttonSize, height: buttonSize)
        forwardButton.frame = CGRect(x: playbutton.right + 30, y: playbutton.top, width: buttonSize, height: buttonSize)
        backwardButton.frame = CGRect(x: playbutton.left - 30 - buttonSize, y: playbutton.top, width: buttonSize, height: buttonSize)
        previousButton.frame = CGRect(x: playbutton.left - 90 - buttonSize, y: playbutton.top, width: buttonSize, height: buttonSize)
        nextButton.frame = CGRect(x: playbutton.right + 90, y: playbutton.top, width: buttonSize, height: buttonSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with titles: titles){
        nameLabel.text = titles.title
        subtitle.text = titles.subtitles
    }
}
