import UIKit
import AVFoundation
import SwiftAudioPlayer


class MusicViewController: UIViewController {
    	
    
    var audioplayer: AVAudioPlayer!
    let playButton = UIButton()
    private let imageview :UIImageView={
        let img = UIImageView()
        img.contentMode = .center
        img.contentMode = .scaleToFill
        img.backgroundColor = .systemBlue
        return img
    }()
    
    var bufferProgress: UIProgressView? = {
        return UIProgressView()
    }()

    
    var playingStatusId: UInt?
    var playbackStatus: SAPlayingStatus = .playing
    var dataSource: playerDataSource?
    
    let pauseButton = UIButton()
    let songTitleLabel = UILabel()
    let slider = UISlider()
        
    var downloadId: UInt?
    var durationId: UInt?
    var bufferId: UInt?
    var queueId: UInt?
    var duration: Double = 0.0
    var elapse: Double = 0.0
    var elapsedId: UInt?
    
    
    var isDownloading: Bool = false
        var isStreaming: Bool = false
        var beingSeeked: Bool = false
        var loopEnabled = false
        
    
    private let controls = MusicView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subscribeToChanges()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            view.backgroundColor = .white
        }
        
        controls.delegate = self
        controls.dataSource = self.dataSource
        view.addSubview(imageview)
        controls.playbutton.isEnabled = false
        view.addSubview(controls)
        configureBarButtons()
        configure()
    }
    func subscribeToChanges() {
            durationId = SAPlayer.Updates.Duration.subscribe { [weak self] (duration) in
                guard let self = self else { return }
//                self.durationLabel.text =  SAPlayer.prettifyTimestamp(duration)
                self.duration = duration
            }
        
            elapsedId = SAPlayer.Updates.ElapsedTime.subscribe { [weak self] (position) in
                guard let self = self else { return }
                self.elapse = position
//                self.currentTimestampLabel.text = SAPlayer.prettifyTimestamp(position)
                self.controls.durationFinalLabel.text = SAPlayer.prettifyTimestamp(self.elapse)
                self.controls.durationSlider.value = Float(position / self.duration)
                guard self.duration != 0 else { return }
                
//                self.scrubberSlider.value = Float(position/self.duration)
            }
            
            downloadId = SAPlayer.Updates.AudioDownloading.subscribe { [weak self] (url, progress) in
                guard let self = self else { return }
//                guard url == self.selectedAudio.url else { return }
                
                if self.isDownloading {
                    DispatchQueue.main.async {
                        UIView.performWithoutAnimation {
//                            self.downloadButton.setTitle("Cancel \(String(format: "%.2f", (progress * 100)))%", for: .normal)
                        }
                    }
                }
            }
            
            bufferId = SAPlayer.Updates.StreamingBuffer.subscribe{ [weak self] (buffer) in
                guard let self = self else { return }

                self.bufferProgress?.progress = Float(buffer.bufferingProgress)

                if buffer.bufferingProgress >= 0.05 {
//                    self.streamButton.isEnabled = false
                    SAPlayer.shared.play()
                    print("Song started playing")
                    
                    self.controls.playbutton.isEnabled = true
                    self.controls.durationLabel.text = SAPlayer.prettifyTimestamp(self.duration)
                } else {
//                    self.streamButton.isEnabled = true
                    print("buffer still loading")
                }
            }
            
            playingStatusId = SAPlayer.Updates.PlayingStatus.subscribe { [weak self] (playing) in
                guard let self = self else { return }
                
                self.playbackStatus = playing
                
                switch playing {
                case .playing:
//                    self.isPlayable = true
                    self.playbackStatus = .playing
//                    self.playPauseButton.setTitle("Pause", for: .normal)
                    return
                case .paused:
//                    self.isPlayable = true
                    self.playbackStatus = .paused
//                    self.playPauseButton.setTitle("Play", for: .normal)
                    return
                case .buffering:
//                    self.isPlayable = false
                    self.playbackStatus = .buffering
//                    self.playPauseButton.setTitle("Loading", for: .normal)
                    return
                case .ended:
                    if !self.loopEnabled {
//                        self.isPlayable = false
                        self.playbackStatus = .ended
//                        self.playPauseButton.setTitle("Done", for: .normal)
                    }
                    return
                }
            }
            
//            queueId = SAPlayer.Updates.AudioQueue.subscribe { [weak self] forthcomingPlaybackUrl in
//                guard let self = self else { return }
//                /// we update the selected audio. this is a little contrived, but allows us to update outlets
//                if let indexFound = self.selectedAudio.getIndex(forURL: forthcomingPlaybackUrl) {
//                    self.selectAudio(atIndex: indexFound)
//                }
//
//                self.currentUrlLocationLabel.text = "\(forthcomingPlaybackUrl.absoluteString)"
//            }
        }
    
    func unsubscribeFromChanges() {
            guard let durationId = self.durationId,
                  let elapsedId = self.elapsedId,
                  let downloadId = self.downloadId,
                  let queueId = self.queueId,
                  let bufferId = self.bufferId,
                  let playingStatusId = self.playingStatusId else { return }
            
            SAPlayer.Updates.Duration.unsubscribe(durationId)
        
            SAPlayer.Updates.ElapsedTime.unsubscribe(elapsedId)
            SAPlayer.Updates.AudioDownloading.unsubscribe(downloadId)
            SAPlayer.Updates.AudioQueue.unsubscribe(queueId)
            SAPlayer.Updates.StreamingBuffer.unsubscribe(bufferId)
            SAPlayer.Updates.PlayingStatus.unsubscribe(playingStatusId)
        }
    
    private func configure(){
        imageview.image = PlaybackPresenter.shared.albumArt
        controls.configure(with: titles(
            title: dataSource?.name, subtitles: dataSource?.artist
        ))
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageview.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width-20)
        controls.frame = CGRect(x: 10, y: imageview.bottom + 10,
                                width: view.width - 20,
                                height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15)
    }
    
    private func configureBarButtons(){
        if #available(iOS 13.0, *) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        } else {
            // Fallback on earlier versions
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapClose))
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    @objc private func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    @objc private func didTapAction(){
        dismiss(animated: true, completion: nil)
    }
}

extension MusicViewController: playerControlsDelegate{
    func playertappedplay(_ musicview: MusicView) {
    //insert code
    }
    
    func playertappedpause(_ musicview: MusicView) {
//        let player = PlaybackPresenter.shared.audioplayer
        print("caught")
        SAPlayer.shared.togglePlayAndPause()
        print(self.playbackStatus)
        if(self.playbackStatus == .paused){
            if #available(iOS 13.0 , *){
                musicview.playbutton.setImage(UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular)), for: .normal)
            }
            else{
                musicview.playbutton.setImage(UIImage(named: "pause"), for: .normal)
            }
        }
        else{
            if #available(iOS 13.0, *){
                musicview.playbutton.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular)), for: .normal)
            }
            else{
                musicview.playbutton.setImage(UIImage(named: "play-button-arrowhead"), for: .normal)
            }
        }
    }
    
    func playertappedforward(_ musicview: MusicView) {
     // insert code
    }
    
    func playertappedbackward(_ musicview: MusicView) {
        // insert code
    }
    
    func somethingWithDuration(_ musicview: MusicView){
        print("the needed end duration is: ",self.duration)
//        musicview.durationLabel.text = SAPlayer.prettifyTimestamp(self.duration)
//        self.controls.durationFinalLabel.text = SAPlayer.prettifyTimestamp(self.elapse)
        print("End duration label is: ",musicview.durationLabel.text as Any)
    }
}
