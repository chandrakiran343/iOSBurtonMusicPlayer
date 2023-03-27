//
//  HomeViewController.swift
//  cloudplayer
//
//  Created by chandra kiran on 26/03/23.
//
import SwiftyDropbox
import UIKit

class HomeViewController: UIViewController {
    
    private let homeFeed : UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeed)
        
        
        homeFeed.delegate = self
        homeFeed.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeed.frame = view.bounds
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int{
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
        cell.textLabel?.text = "hello bitch"
        return cell
    }
}
