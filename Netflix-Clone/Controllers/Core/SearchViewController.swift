//
//  SearchViewController.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 25.06.24.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var items: [Item] = []
    
    private let discoverTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(LandscapeItemTableViewCell.self, forCellReuseIdentifier: LandscapeItemTableViewCell.identifier)
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search Movies and TV Series"
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.tintColor = .label
  
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(discoverTableView)
        navigationItem.searchController = searchController
        
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        
        guard let previewItemTitle = item.title ?? item.name else { return }
       
        APIColler.shared.getUtubeVideo(query: "\(previewItemTitle) trailer") { result in
            switch result {
            case .success(let videoSearchResult):
                guard let videoPath = videoSearchResult.items[0].id.videoId else {return}
                
                DispatchQueue.main.async { [weak self] in
                    let previewItem = ItemVideoPreview(title: previewItemTitle, url: videoPath, overview: item.overview ?? "")
                    let vc = ItemPreviewViewController()
                    vc.configure(with: previewItem)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
       
    }
    
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {return}
            
        resultsController.delegate = self
        
        APIColler.shared.search(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    resultsController.items = items
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    func searchResultsViewControllerDidTapCell(item: ItemVideoPreview) {
        DispatchQueue.main.async { [weak self] in
            let vc = ItemPreviewViewController()
            vc.configure(with: item)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}


