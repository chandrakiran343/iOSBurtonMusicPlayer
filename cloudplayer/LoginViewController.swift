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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        	
        view.backgroundColor = .systemBackground
        
//        self.navigationItem.largeTitleDisplayMode = .always
//
        title = "Burton Music player"
        
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with DropBox", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.frame = CGRect(x: 20, y: view.height - 100-view.safeAreaInsets.bottom,
                              width: view.width - 40, height: 50)

        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        view.addSubview(button)
        
        
        // Do any additional setup after loading the view.
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
    
    
    
    
    func myButtonInControllerPressed() {
        // OAuth 2 code flow with PKCE that grants a short-lived token with scopes, and performs refreshes of the token automatically.
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read"], includeGrantedScopes: false)
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
