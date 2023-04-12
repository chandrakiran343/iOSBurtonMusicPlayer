//
//  LoginViewController.swift
//  cloudplayer
//
//  Created by chandra kiran on 26/03/23.
//

import UIKit
import SwiftyDropbox

class LoginViewController: UIViewController {
    
    public var animated:Bool={
        return false
    }()
    
    private let backgroundLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        	
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            view.backgroundColor = .white
        }
        
//        self.navigationItem.largeTitleDisplayMode = .always
//
        self.setupUI()
        self.startBackgroundAnimation()
        let textLabel = UILabel(frame: CGRect(x: 0, y: view.height / 2, width: view.width, height: 80))
        textLabel.text = "Burton Music player"
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 34)
        textLabel.backgroundColor = .clear
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .left
        self.navigationItem.titleView = textLabel
       
        
        self.navigationItem.titleView = textLabel
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with DropBox", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.frame = CGRect(x: 20, y: view.height - 100-view.safeAreaInsets.bottom,
                              width: view.width - 40, height: 50)

        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        view.addSubview(button)
        
    }
    
    private func setupUI() {
            view.backgroundColor = .white
            
            // Add background layer
            backgroundLayer.frame = view.bounds
            view.layer.addSublayer(backgroundLayer)
            
            // Add other UI elements, such as text fields and buttons, as needed
        }
    override func viewDidAppear(_ animated: Bool) {
        self.animated = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.animated = false
    }
    
    @objc func signIn() {

        if (DropboxClientsManager.authorizedClient == nil){
            if(self.animated){
                myButtonInControllerPressed()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    private func startBackgroundAnimation() {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                UIColor(red: 247/255, green: 155/255, blue: 56/255, alpha: 1).cgColor,
                UIColor(red: 247/255, green: 93/255, blue: 89/255, alpha: 1).cgColor
            ]
            gradientLayer.locations = [0, 1]
            gradientLayer.frame = backgroundLayer.bounds
            
            let animation = CABasicAnimation(keyPath: "colors")
            animation.fromValue = gradientLayer.colors
            animation.toValue = [
                UIColor(red: 247/255, green: 93/255, blue: 89/255, alpha: 1).cgColor,
                UIColor(red: 247/255, green: 155/255, blue: 56/255, alpha: 1).cgColor
            ]
            animation.duration = 3
            animation.autoreverses = true
            animation.repeatCount = .infinity
            gradientLayer.add(animation, forKey: nil)
            
            backgroundLayer.addSublayer(gradientLayer)
        }
    
    
    func myButtonInControllerPressed() {
        // OAuth 2 code flow with PKCE that grants a short-lived token with scopes, and performs refreshes of the token automatically.
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read","files.metadata.read","files.metadata.write","files.content.read","files.content.write"], includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: self,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:],
                                                                       completionHandler: {success in
                                                                        print("HI")
                                                                       }
            )},
            scopeRequest: scopeRequest
        )
    }
}
