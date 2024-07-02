//
//  SearchViewController.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 25.06.24.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var items: [Item] = []
    
    let discoverTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(LandscapeItemTableViewCell.self, forCellReuseIdentifier: LandscapeItemTableViewCell.identifier)
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(discoverTableView)
        
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        
        fetchDiscoverMovies()
    }
    
    override func viewDidLayoutSubviews() {
        discoverTableView.frame = view.bounds
        
    }
    
    private func fetchDiscoverMovies() {
        APIColler.shared.discoverMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.items = movies
                DispatchQueue.main.async {
                    self?.discoverTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LandscapeItemTableViewCell.identifier, for: indexPath) as? LandscapeItemTableViewCell else { return UITableViewCell()}
        
        let item = items[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
}
