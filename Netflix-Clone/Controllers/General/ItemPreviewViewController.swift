//
//  ItemPreviewViewController.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 3.07.24.
//

import UIKit
import WebKit

class ItemPreviewViewController: UIViewController {
    
    private let webView: WKWebView = {
       let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.layer.cornerRadius = 5
        return webView
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingMiddle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.tintColor = .label
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    private var selectedItem: ItemVideoPreview?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .label
        
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(button)
        
        applyConstraints()
        
        button.addTarget(self, action: #selector(downloadButtonClicked), for: .touchUpInside)
    }
    
    @objc func downloadButtonClicked() {
    
        let newItem = Item(id: selectedItem?.id ?? 0, title: selectedItem?.title, name: selectedItem?.name, original_title: nil, original_name: nil, overview: selectedItem?.overview, media_type: nil, poster_path: selectedItem?.poster_path, release_date: nil, vote_count: nil, vote_average: nil)
       
            DataPersistenceManager.shared.saveItemToStorage(itemModel: newItem) { result in
                switch result {
                case .success():
                    print("saved to db")
                    NotificationCenter.default.post(name: .init("Downloaded to DB"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }

    private func applyConstraints() {
        
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        let descriptionLabelConstraints = [
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
           // descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            descriptionLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            //descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ]
        
        let buttonConstraints = [
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 40),
            button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
        NSLayoutConstraint.activate(buttonConstraints)
    }
   
    func configure(with item: ItemVideoPreview) {
    
        guard let url = URL(string: "\(Constants.uTubePreviewBaseUrl)/\(item.url)") else { return }
        titleLabel.text = item.title
        descriptionLabel.text = item.overview
        webView.load(URLRequest(url: url))
        
        selectedItem = item
    }

}
