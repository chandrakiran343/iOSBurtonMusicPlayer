import UIKit
import AVFoundation
import SwiftAudioPlayer
import AHDownloadButton


class MusicViewController: UIViewController{
    	
    
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
    
    func minimize(){
        self.view.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.maxY - 40, width: self.view.frame.width, height: 40)
        self.viewDidLoad()
    }
    
    var isDownloading: Bool = false
        var isStreaming: Bool = false
        var beingSeeked: Bool = false
        var loopEnabled = false
    var downloadProgress: CGFloat = 0.0
    
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//
//        if isBeingDismissed{
            
//        }
//    }
    
    func tapdownloadButton(downloadButton: AHDownloadButton, state: AHDownloadButton.State) -> Void {
        DispatchQueue.main.async {
            let remoteUrl = (PlaybackPresenter.shared.currentTrack?.downloadlink)!
            switch state{
            case .startDownload:
                downloadButton.progress = 0
                print("Tapped download")
                
//                if !SAPlayer.Downloader.isDownloaded(withRemoteUrl: remoteUrl,name:PlaybackPresenter.shared.currentTrack!.name){
                    
                
                downloadButton.state = .pending
                    downloadButton.progress = 0
    //            downloadButton.transitionAnimationDuration = TimeInterval(2.0)
    //            downloadButton.state = .downloadi
                    downloadButton.state = .downloading
                    self.simulateDownloading()
                    SAPlayer.Downloader.downloadAudio(withRemoteUrl: remoteUrl ,name:PlaybackPresenter.shared.currentTrack!.name){result,error in
                    self.controls.downloadButton.progress = 1
                    self.controls.downloadButton.state = .downloaded
                    PlaybackPresenter.shared.track?.downloaded = true
                    PlaybackPresenter.shared.presenter.viewDidLoad()
                       

                    print(result)
                    }
                    
//                }
//                e/lse{
//                    downloadButton.state = .downloaded
//                }
                

            case .pending:
                print("Wait a minute")

            case .downloading:
                SAPlayer.Downloader.cancelDownload(withRemoteUrl: remoteUrl)
                print("downloading")
                

            case .downloaded:
                print("downloaded")
            }
        }
    }
    
    func stateChange(button: AHDownloadButton , state: AHDownloadButton.State) -> Void {
        if(state == .pending){
            button.state = .downloading
        }
    }
    
    
    
    private let controls = MusicView()
    
    var downloadTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.isUserInteractionEnabled = true
        
        self.subscribeToChanges()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            view.backgroundColor = .white
        }
        
        controls.delegate = self
        
        controls.downloadButton.didTapDownloadButtonAction = tapdownloadButton
        
        
        controls.downloadButton.downloadButtonStateChangedAction = stateChange
        controls.dataSource = self.dataSource
        
        view.addSubview(imageview)
//        if(SAPlayer.shared.){
//            controls.playbutton.isEnabled = false
//        }
        view.addSubview(controls)
        self.controls.playbutton.isEnabled = false
        self.controls.forwardButton.isEnabled = false
        self.controls.backwardButton.isEnabled = false
        if(self.playbackStatus == .paused){
            if #available(iOS 13.0 , *){
                controls.playbutton.setImage(UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular)), for: .normal)
            }
            else{
                controls.playbutton.setImage(UIImage(named: "pause"), for: .normal)
            }
        }
        configureBarButtons()
        configure()
    }
    
    func simulateDownloading(){
        downloadTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true){ timer in
            
            guard self.controls.downloadButton.progress < 1 else{
                self.controls.downloadButton.state = .downloaded
                timer.invalidate()
                return
            }
            
            self.controls.downloadButton.progress += CGFloat(timer.timeInterval / 5)
        }
        downloadTimer?.fire()
    }
    
    func subscribeToChanges() {
            durationId = SAPlayer.Updates.Duration.subscribe { [weak self] (duration) in
                guard let self = self else { return }
                self.duration = duration
            }
        
            elapsedId = SAPlayer.Updates.ElapsedTime.subscribe { [weak self] (position) in
                guard let self = self else { return }
                self.elapse = position
                if(!self.controls.playbutton.isEnabled){
                    self.controls.playbutton.isEnabled = true
                    self.controls.forwardButton.isEnabled = true
                    self.controls.backwardButton.isEnabled = true
                }
//                self.currentTimestampLabel.text = SAPlayer.prettifyTimestamp(position)
                self.controls.durationFinalLabel.text = SAPlayer.prettifyTimestamp(self.elapse)
                
                self.controls.durationSlider.value = Float(position / self.duration)
                
                if (self.elapse == self.duration && PlaybackPresenter.shared.songId < PlaybackPresenter.shared.tracks.count - 1){
                    PlaybackPresenter.shared.startPlayBack(from: PlaybackPresenter.shared.presenter, track: PlaybackPresenter.shared.tracks[PlaybackPresenter.shared.songId + 1], tracks: PlaybackPresenter.shared.tracks, index: IndexPath(row:PlaybackPresenter.shared.songId + 1, section: 0))
                    self.viewDidLoad()
                }
                guard self.duration != 0 else { return }
            }
            
            downloadId = SAPlayer.Updates.AudioDownloading.subscribe { [weak self] (url, progress) in
                guard let self = self else { return }
//                guard url == self.selectedAudio.url else { return }
                
                self.downloadProgress = CGFloat(progress)
                print("the download progress is: ", self.controls.downloadButton.progress	, self.downloadProgress)
                
//                if(self.controls.downloadButton.state == .downloading){
                    self.controls.downloadButton.progress += self.downloadProgress
//                self.controls.downloadButton.progress = self.downloadProgress
//                if self.isDownloading {
//                    DispatchQueue.main.async {
//                        UIView.performWithoutAnimation {
////                            self.downloadButton.setTitle("Cancel \(String(format: "%.2f", (progress * 100)))%", for: .normal)
//                        }
//                    }
//                }
            }
            
            bufferId = SAPlayer.Updates.StreamingBuffer.subscribe{ [weak self] (buffer) in
                guard let self = self else { return }

                self.bufferProgress?.progress = Float(buffer.bufferingProgress)

                if buffer.bufferingProgress >= 0.05 {
                    
                    
                    SAPlayer.shared.play()
                    print("Song started playing")
                    
//                    self.controls.playbutton.isEnabled = true
                    self.controls.durationLabel.text = SAPlayer.prettifyTimestamp(self.duration)
                } else {
//                    self.streamButton.isEnabled = true
                    print("buffer still loading")
                }
            }
            
            playingStatusId = SAPlayer.Updates.PlayingStatus.subscribe { [weak self] (playing) in
                guard let self = self else { return }
                
                
                	
                switch playing {
                case .playing:
//                    self.isPlayable = true
                    self.playbackStatus = .playing
                    MainTabBarViewController.shared.helpWithStatus(status: self.playbackStatus)
                        if #available(iOS 13.0 , *){
                            self.controls.playbutton.setImage(UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular)), for: .normal)
                        }
                        else{
                            self.controls.playbutton.setImage(UIImage(named: "pause"), for: .normal)
                        }
                        

//                    self.playPauseButton.setTitle("Pause", for: .normal)
                    return
                case .paused:
//                    self.isPlayable = true
                    self.playbackStatus = .paused
                    MainTabBarViewController.shared.helpWithStatus(status: self.playbackStatus)
                    if #available(iOS 13.0, *){
                        self.controls.playbutton.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular)), for: .normal)
                    }
                    else{
                        self.controls.playbutton.setImage(UIImage(named: "play-button-arrowhead"), for: .normal)
                    }
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
        SAPlayer.shared.skipForwardSeconds = 15
        imageview.image = PlaybackPresenter.shared.albumArt
        controls.configure(with: titles(
            title: dataSource?.name, subtitles: dataSource?.artist
        ))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageview.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width-20)
        controls.frame = CGRect(x: 10, y: imageview.bottom,
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
        MainTabBarViewController.shared.addMinPlayer(data:PlaybackPresenter.shared.track!.name)
//        let lmao = UIApplication.shared.windows.first?.rootViewController
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = false
        }
        dismiss(animated: true, completion: nil)
//        minimize()
    }
    @objc private func didTapAction(){
        dismiss(animated: true, completion: nil)
    }
}

extension MusicViewController: playerControlsDelegate,URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("done")
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("hello", Double(totalBytesWritten/totalBytesExpectedToWrite))
    }
    
    
    func playertappedprevious(_ musicview: MusicView) {
        var currentIndex = PlaybackPresenter.shared.songId - 1
                   if (currentIndex < 0){
                       currentIndex = 0
                   }
        let nextSong = PlaybackPresenter.shared.tracks[currentIndex]
        let tracks = PlaybackPresenter.shared.tracks
       
        PlaybackPresenter.shared.startPlayBack(from: PlaybackPresenter.shared.presenter, track: nextSong, tracks: tracks, index: IndexPath(row: currentIndex, section: 0))
        self.viewDidLoad()
    }
    
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
        if (self.elapse + 15 < self.duration){
            SAPlayer.shared.skipForward()
        }
            
    }
    
    func playertappedbackward(_ musicview: MusicView) {
        // insert code
        SAPlayer.shared.skipBackwards()
    }
    
    func playertappednext(_ musicview: MusicView){
//        PlaybackPresenter.shared.musicControl(PlaybackPresenter.shared.presenter, action: "next", content: "")
        var currentIndex = PlaybackPresenter.shared.songId + 1
        if (currentIndex >= PlaybackPresenter.shared.tracks.count){
            currentIndex = PlaybackPresenter.shared.tracks.count - 1
        }
        let nextSong = PlaybackPresenter.shared.tracks[currentIndex]
        let tracks = PlaybackPresenter.shared.tracks
        
        PlaybackPresenter.shared.startPlayBack(from: PlaybackPresenter.shared.presenter, track: nextSong, tracks: tracks, index: IndexPath(row: currentIndex, section: 0))
        self.viewDidLoad()
    }
    
    func somethingWithDuration(_ musicview: MusicView){
        print("the needed end duration is: ",self.duration)
//        musicview.durationLabel.text = SAPlayer.prettifyTimestamp(self.duration)
//        self.controls.durationFinalLabel.text = SAPlayer.prettifyTimestamp(self.elapse)
        print("End duration label is: ",musicview.durationLabel.text as Any)
    }
    
   
}
