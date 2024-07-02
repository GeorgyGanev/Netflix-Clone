//
//  ItemCollectionViewCell.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 1.07.24.
//

import UIKit
import SDWebImage
import SDWebImageMapKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: ItemCollectionViewCell.self)
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    func configure(with imageUrl: String) {
        guard let url = URL(string: "\(Constants.imageBaseUrl)\(imageUrl)") else { return }
        posterImageView.sd_setImage(with: url)
        
        
    }
}
