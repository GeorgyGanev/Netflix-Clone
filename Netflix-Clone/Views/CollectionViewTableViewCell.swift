//
//  CollectionViewTableViewCell.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 25.06.24.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, model: ItemVideoPreview)
}

class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = String(describing: CollectionViewTableViewCell.self)
    
    private var items: [Item] = []
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
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
        
        contentView.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    private func saveMovieItemToDownaloads(at indexPath: IndexPath) {
        DataPersistenceManager.shared.saveItemToStorage(itemModel: items[indexPath.row]) { result in
            switch result {
            case .success():
                print("saved to DB")
                NotificationCenter.default.post(name: .init("Downloaded to DB"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
        
        let item = items[indexPath.row]
        
        guard let query = item.name ?? item.title else { return }
        
        APIColler.shared.getUtubeVideo(query: query + " trailer") { [weak self] result in
            switch result {
            case .success(let videoResponse):
                for resultItem in videoResponse.items {
                    if let id = resultItem.id.videoId {
                      
                        guard let title = item.title ?? item.name else { return }
                        guard let description = item.overview else { return }
                        let previewModel = ItemVideoPreview(title: title, url: id, overview: description, poster_path: item.poster_path, name: item.name, id: item.id)
                        guard let strongSelf = self else {return}
                        self?.delegate?.CollectionViewTableViewCellDidTapCell(strongSelf, model: previewModel)
                       
                        return
                    } else {continue}
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //ENABLE OPTION MENU DISPLAY WITH DOWNLOAD ACTION OPTION
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    
        let config = UIContextMenuConfiguration(actionProvider:  { [weak self] _ in
            let downloadAction = UIAction(title: "Download", state: .off) { _ in
                self?.saveMovieItemToDownaloads(at: indexPath)
            }
            return UIMenu(options: .displayInline, children: [downloadAction])
        })
        
        return config
    }
    
}
