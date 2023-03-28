//
//  LoginViewController.swift
//  cloudplayer
//
//  Created by chandra kiran on 26/03/23.
//

import UIKit
import SwiftyDropbox

class LoginViewController: UIViewController {
    
    private var animated:Bool={
        return false
    }()
    private let button: UIButton = {
       let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with DropBox", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen
        title = "Login with your DropBox account"
        
        
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.animated = true
        print("After appear",self.animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        print("before appear",self.animated)
        self.animated = false
    }
    @objc func signIn() {
        if (DropboxClientsManager.authorizedClient == nil){
            if(self.animated){
                myButtonInControllerPressed()
            }
        }
        else{
            if(self.animated){
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let sceneDelegate = windowScene.delegate as? SceneDelegate,
                   let window = sceneDelegate.window{
                    if(self.viewIfLoaded?.window != nil){
                        window.rootViewController = MainTabBarViewController()
                        window.makeKeyAndVisible()
                    }
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect(x: 20, y: view.height - 60-view.safeAreaInsets.bottom,
                              width: view.width - 40, height: 50)
        
    }
    
    func myButtonInControllerPressed() {
        // OAuth 2 code flow with PKCE that grants a short-lived token with scopes, and performs refreshes of the token automatically.
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read"], includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: self,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )
    }
}
