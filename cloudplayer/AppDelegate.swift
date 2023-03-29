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



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DropboxClientsManager.setupWithAppKey("g6a1xtuli3pxot6")
        
        return true
    }
//    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        
//        let oauthCompletion: DropboxOAuthCompletion = {
//          if let authResult = $0 {
//              switch authResult {
//              case .success:
//                  print("Success! User is logged into DropboxClientsManager.")
//              case .cancel:
//                  print("Authorization flow was manually canceled by user!")
//              case .error(_, let description):
//                  print("Error: \(String(describing: description))")
//              }
//          }
//        }
//        let canHandleUrl = DropboxClientsManager.handleRedirectURL(url, completion: oauthCompletion)
//        return canHandleUrl
//    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

