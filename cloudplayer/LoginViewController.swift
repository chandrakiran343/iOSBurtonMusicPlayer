//
//  LoginViewController.swift
//  cloudplayer
//
//  Created by chandra kiran on 26/03/23.
//

import UIKit
import SwiftyDropbox

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        // Do any additional setup after loading the view.
    }
    var hit = 0
    override func viewDidAppear(_ animated: Bool) {
        if (DropboxClientsManager.authorizedClient == nil){
            myButtonInControllerPressed()
        }
        else{
//            present(MainTabBarViewController(), animated: true)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let window = sceneDelegate.window{
                window.rootViewController = MainTabBarViewController()
                window.makeKeyAndVisible()
            }
//            appDelegate.window?.rootViewController = MainTabBarViewController()
//            self.tabBarController?.tabBar(MainTabBarViewController, animated: true)
              
        }
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
       
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    }
}
