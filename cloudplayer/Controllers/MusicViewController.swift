import UIKit
import AVFoundation



class MusicViewController: UIViewController {
    
    
    var audioplayer: AVAudioPlayer!
    let playButton = UIButton()
    private let imageview :UIImageView={
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .systemBlue
        return img
    }()
    var dataSource: playerDataSource?
    
    let pauseButton = UIButton()
    let songTitleLabel = UILabel()
    let slider = UISlider()
    
    private let controls = MusicView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        controls.delegate = self
        controls.dataSource = self.dataSource
        view.addSubview(imageview)
        view.addSubview(controls)
        configureBarButtons()
        configure()
//        playbutton.setImage(UIImage(systemName: "play"), for: .normal)
//        pauseButton.setImage(UIImage(systemName: "pause"), for: .normal)
//
//        playbutton.setTitle("play", for: .normal)
//        playbutton.frame = CGRect(x: view.width - view.safeAreaInsets.right - 80, y: 50, width: 80, height: 60)
//        view.addSubview(playbutton)
    }
    
    private func configure(){
        imageview.image = UIImage(named: "icon")
        controls.configure(with: titles(
            title: dataSource?.name, subtitles: dataSource?.artist
        ))
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageview.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width-50)
        controls.frame = CGRect(x: 10, y: imageview.bottom + 10,
                                width: view.width - 20,
                                height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15)
    }
    
    private func configureBarButtons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        
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
        let player = PlaybackPresenter.shared.audioplayer
        
//        if((player?) != nil){
            player?.pause()
//        }
//        else{
//            player?.play()
//        }
    }
    
    func playertappedforward(_ musicview: MusicView) {
     // insert code
    }
    
    func playertappedbackward(_ musicview: MusicView) {
        // insert code
    }
    
}
