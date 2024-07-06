//
//  DownloadsViewController.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 25.06.24.
//

import UIKit

class DownloadsViewController: UIViewController {

    var items: [MediaItem] = []
    
    private let downloadsTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(LandscapeItemTableViewCell.self, forCellReuseIdentifier: LandscapeItemTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        downloadsTableView.delegate = self
        downloadsTableView.dataSource = self
        
        NotificationCenter.default.addObserver(forName: .init("Downloaded to DB"), object: nil, queue: nil) { [weak self] _ in
            self?.downloadItemsFromStorage()
        }
        
        view.addSubview(downloadsTableView)
        
        downloadItemsFromStorage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTableView.frame = view.bounds
    }
    
    private func downloadItemsFromStorage() {
        DataPersistenceManager.shared.fetchItemsFromStorage { [weak self] result in
            switch result {
            case .success(let dbItems):
                self?.items = dbItems
                DispatchQueue.main.async {
                    self?.downloadsTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LandscapeItemTableViewCell.identifier, for: indexPath) as? LandscapeItemTableViewCell else { return UITableViewCell()}
        
        
        let item = Item(id: Int(items[indexPath.row].id), title: items[indexPath.row].title, name: items[indexPath.row].name, original_title: items[indexPath.row].original_title, original_name: items[indexPath.row].original_name, overview: items[indexPath.row].overview, media_type: items[indexPath.row].media_type, poster_path: items[indexPath.row].poster_path, release_date: items[indexPath.row].release_date, vote_count: Int(items[indexPath.row].vote_count), vote_average: items[indexPath.row].vote_average)
        
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
                    let previewItem = ItemVideoPreview(title: previewItemTitle, url: videoPath, overview: item.overview ?? "", poster_path: item.poster_path, name: item.name, id: Int(item.id))
                    let vc = ItemPreviewViewController()
                    vc.configure(with: previewItem)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            DataPersistenceManager.shared.deleteMediaItem(item: items[indexPath.row]) { result in
                switch result {
                case .success():
                    print("Deleted Item from DB")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            items.remove(at: indexPath.row)
            downloadsTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
