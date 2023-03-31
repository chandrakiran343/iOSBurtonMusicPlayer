//
//  ViewController.swift
//  cloudplayer
//
//  Created by chandra kiran on 26/03/23.
//

import UIKit
import SwiftyDropbox

class MainTabBarViewController: UITabBarController {
    
    @objc func logoutProcess(){
        print("pressed logout")
        DropboxClientsManager.unlinkClients()
        let window = UIApplication.shared.windows.first
        let nav = UINavigationController(rootViewController: LoginViewController())
        nav.navigationBar.prefersLargeTitles = true
        nav.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let c1 = HomeViewController()
        let c2 = UploadViewController()
        let c3 = DownloadViewController()
        
        
        let logout = UIButton()
        logout.setTitle("Logout", for: .normal)
        logout.setTitleColor(.red, for: .normal)
        
        logout.addTarget(self, action: #selector(logoutProcess), for: .touchUpInside)
        
        logout.frame = CGRect(x: view.width - view.safeAreaInsets.right - 80, y: 20, width: 80, height: 60)
        
        view.addSubview(logout)
        
        c1.navigationItem.largeTitleDisplayMode = .always
        c2.navigationItem.largeTitleDisplayMode = .always
        c3.navigationItem.largeTitleDisplayMode = .always
        
        c1.title = "Home"
        c2.title = "Uploads"
        c3.title = "Downloads"
        
        let vc1 = UINavigationController(rootViewController: c1)
        let vc2 = UINavigationController(rootViewController: c2)
        let vc3 = UINavigationController(rootViewController: c3)
        
        vc1.navigationBar.prefersLargeTitles = true
        vc2.navigationBar.prefersLargeTitles = true
        vc3.navigationBar.prefersLargeTitles = true
        
        
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "arrow.up")
        vc3.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
//        vc1.navigationItem.
        
        
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1,vc2,vc3], animated: true)
        
//        MainTabBarViewController().viewControllers = [SearchBarViewController()]	
    }

}

