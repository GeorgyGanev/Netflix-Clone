//
//  LandscapeItemTableViewCell.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 2.07.24.
//

import UIKit
import SDWebImage

class LandscapeItemTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: LandscapeItemTableViewCell.self)

    let cellImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let cellTitleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    let cellButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellImageView)
        contentView.addSubview(cellTitleLabel)
        contentView.addSubview(cellButton)
    
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func applyConstraints() {
        let cellImageViewConstraints = [
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 15),
            cellImageView.widthAnchor.constraint(equalToConstant: 100),
            
        ]
        
        let cellTitleLabelConstraints = [
            cellTitleLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 20),
            cellTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellTitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6)
        ]
        
        let cellButtonConstraints = [
            cellButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cellButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        
        NSLayoutConstraint.activate(cellImageViewConstraints)
        NSLayoutConstraint.activate(cellTitleLabelConstraints)
        NSLayoutConstraint.activate(cellButtonConstraints)
    }
    
    func configure(with item: Item) {
        guard let path = item.poster_path else {return}
        guard let url = URL(string: "\(Constants.imageBaseUrl)\(path)") else {return}
        cellImageView.sd_setImage(with: url)
        cellTitleLabel.text = item.name ?? item.title ?? "unknown"
        
    }

}
