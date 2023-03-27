//
//  ViewController.swift
//  cloudplayer
//
//  Created by chandra kiran on 26/03/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UploadViewController())
        let vc3 = UINavigationController(rootViewController: DownloadViewController())
        
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "arrow.up")
        vc3.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        
        vc1.title = "Home"
        vc2.title = "Upload"
        vc3.title = "Download"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1,vc2,vc3], animated: true)
        
//        MainTabBarViewController().viewControllers = [SearchBarViewController()]	
    }

}

