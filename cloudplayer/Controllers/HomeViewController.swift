//
//  HomeViewController.swift
//  cloudplayer
//
//  Created by chandra kiran on 26/03/23.
//
import SwiftyDropbox
import UIKit

class HomeViewController: UIViewController,UISearchBarDelegate {
    
    private let homeFeed : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    let data = ["hello", "kiloo","syboo"]
    
    var filteredData: [String]!
    private let searchBar: UISearchBar = {
//        let search = UISearchBar(frame: CGRect(x:0,y:0,width:100,height: 120))
        let search = UISearchBar()
        
        search.placeholder = "Search for the Audio here"
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(searchBar)
        view.addSubview(homeFeed)
    
        
        filteredData = data
        homeFeed.delegate = self
        homeFeed.dataSource = self
        searchBar.delegate = self
//        searchBar.dataSource = self
        homeFeed.tableHeaderView = searchBar
    
        searchBar.sizeToFit()

        homeFeed.tableHeaderView?.frame.size.height = searchBar.frame.size.height
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeed.frame = view.bounds
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? data : data.filter{ (item: String)->Bool in
            return item.range(of: searchText, options: .caseInsensitive,range: nil,locale: nil) != nil
        }
        // setup to handle index out of bounds error while no search results
//        print(filteredData[0])
//        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for:indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .systemBlue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

