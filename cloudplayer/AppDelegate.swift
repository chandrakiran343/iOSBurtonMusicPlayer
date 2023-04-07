//
//  AppDelegate.swift
//  cloudplayer
//
//  Created by chandra kiran on 26/03/23.
//

import UIKit
import SwiftyDropbox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DropboxClientsManager.setupWithAppKey("g6a1xtuli3pxot6")
        
        if #available(iOS 13.0, *){
            print("not legacy")
        }
        else{
            if(DropboxClientsManager.authorizedClient == nil){
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.navigationBar.prefersLargeTitles = true
                nav.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                window = UIWindow()
                window?.rootViewController = nav
                window?.makeKeyAndVisible()
            }
            else{
                window = UIWindow()
                let maintab = MainTabBarViewController()
                self.window?.rootViewController = maintab
                window?.makeKeyAndVisible()
            }
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let oauthCompletion: DropboxOAuthCompletion = { [self] in
          if let authResult = $0 {
              switch authResult {
              case .success:
                  print("Success! User is logged into DropboxClientsManager.")
                if let navig = self.window?.rootViewController as? UINavigationController{
                    navig.setNavigationBarHidden(true, animated: false)
                    navig.pushViewController(MainTabBarViewController(), animated: true)
                    
                    
                }
              case .cancel:
                  print("Authorization flow was manually canceled by user!")
              case .error(_, let description):
                  print("Error: \(String(describing: description))")
              }
          }
        }

//        for context in url {
            // stop iterating after the first handle-able url
        return DropboxClientsManager.handleRedirectURL(url, completion: oauthCompletion)
//        }

    }
//    
// 

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

