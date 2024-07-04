//
//  CollectionViewTableViewCell.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 25.06.24.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = String(describing: CollectionViewTableViewCell.self)
    
    private var items: [Item] = []
    
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 140, height: 200)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        return collectionView
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //contentView.backgroundColor = .systemPink
        
        contentView.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell else { return UICollectionViewCell()}
        
        guard let posterPath = items[indexPath.row].poster_path else { return UICollectionViewCell()}
        cell.configure(with: posterPath)
        return cell
    }
    
    func configure(with items: [Item]) {
        self.items = items
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let query = items[indexPath.row].name ?? items[indexPath.row].title else { return }
        
        APIColler.shared.getUtubeVideo(query: query + " trailer") { result in
            switch result {
            case .success(let response):
                for item in response.items {
                    if let id = item.id.videoId {
                        print(id)
                        return
                    } else {continue}
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
