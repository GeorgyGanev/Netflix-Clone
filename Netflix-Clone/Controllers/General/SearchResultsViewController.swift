//
//  SearchResultsViewController.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 2.07.24.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapCell(item: ItemVideoPreview)
}

class SearchResultsViewController: UIViewController {

    var items: [Item] = []
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }

}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell else { return UICollectionViewCell()}
            
        let item = items[indexPath.row]
        cell.configure(with: item.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        guard let title = item.name ?? item.title else {return}
        APIColler.shared.getUtubeVideo(query: "\(title) trailer") { [weak self] videoSearchResponse in
            switch videoSearchResponse {
            case .success(let response):
                guard let videoPath = response.items[0].id.videoId else {return}
                let previewItem = ItemVideoPreview(title: title, url: videoPath, overview: item.overview ?? "", poster_path: item.poster_path, name: item.name, id: item.id)
                self?.delegate?.searchResultsViewControllerDidTapCell(item: previewItem)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
        
}
