//
//  UpcomingViewController.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 25.06.24.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    var items: [Item] = []
    
    let upcomingTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(UpcomingItemTableViewCell.self, forCellReuseIdentifier: UpcomingItemTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTableView)
    
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        
        fetchUpcomingMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTableView.frame = view.bounds
    }
    
    private func fetchUpcomingMovies() {
        APIColler.shared.getUpcomingMovies { result in
            switch result {
            case .success(let movies):
                self.items = movies
                
                DispatchQueue.main.async { [weak self] in
                    self?.upcomingTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingItemTableViewCell.identifier, for: indexPath) as? UpcomingItemTableViewCell else {return UITableViewCell()}
        let item = items[indexPath.row]
        cell.configure(with: item)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.height * 0.8
    }
    
    
}
