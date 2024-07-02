//
//  UpcomingItemTableViewCell.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 1.07.24.
//

import UIKit
import SDWebImage

class UpcomingItemTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: UpcomingItemTableViewCell.self)
    
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = false
        imageView.layer.cornerRadius = 5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let itemLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    let itemTextField: UILabel = {
       let textField = UILabel()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.numberOfLines = 4
        textField.textAlignment = .left
        textField.textColor = .label
        textField.showsExpansionTextWhenTruncated = true
        return textField
    }()
    
//    let horizontalStackView: UIStackView = {
//       let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.distribution = .equalSpacing
//        stackView.backgroundColor = .clear
//        stackView.tintColor = .label
//        return stackView
//    }()
    
    let itemButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "play.square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
      //  button.setTitle("Play", for: .normal)
        button.tintColor = .label
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        selectionStyle = .none
        
        contentView.addSubview(itemImageView)
//        horizontalStackView.addArrangedSubview(itemLabel)
//        horizontalStackView.addArrangedSubview(itemButton)
//        contentView.addSubview(horizontalStackView)
        contentView.addSubview(itemLabel)
        contentView.addSubview(itemButton)
        contentView.addSubview(itemTextField)
    
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        let itemImageViewConstraints = [
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            itemImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            itemImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ]
        
//        let horizontalStackViewConstraints = [
//            horizontalStackView.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 10),
//            horizontalStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
//            horizontalStackView.heightAnchor.constraint(equalToConstant: 100)
//        ]
        
        let itemLabelConstraints = [
            itemLabel.heightAnchor.constraint(equalToConstant: 50),
            itemLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            itemLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 10)
        ]
        
        let itemButtonConstraints = [
            itemButton.leadingAnchor.constraint(equalTo: itemLabel.trailingAnchor, constant: 20),
            //itemButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            itemButton.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 20),
            itemButton.centerYAnchor.constraint(equalTo: itemLabel.centerYAnchor)
        ]
    
        let itemTextFieldConstraints = [
            itemTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            itemTextField.topAnchor.constraint(equalTo: itemLabel.bottomAnchor, constant: 10),
            itemTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9)
        ]
        
        NSLayoutConstraint.activate(itemImageViewConstraints)
//      NSLayoutConstraint.activate(horizontalStackViewConstraints)
        NSLayoutConstraint.activate(itemLabelConstraints)
        NSLayoutConstraint.activate(itemButtonConstraints)
        NSLayoutConstraint.activate(itemTextFieldConstraints)
    }
    
    func configure(with item: Item) {
        guard let path = item.poster_path else {return}
        guard let url = URL(string: "\(Constants.imageBaseUrl)\(path)") else {return}
        itemImageView.sd_setImage(with: url)
        
        itemLabel.text = item.name ?? item.title ?? "unknown"
        itemTextField.text = item.overview ?? ""
    }
}
