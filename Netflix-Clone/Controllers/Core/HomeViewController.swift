//
//  HomeViewController.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 25.06.24.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv
    case Popular
    case UpcomingMovies
    case TopRated
    
}

class HomeViewController: UIViewController {
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .systemBackground
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    private let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top Rated"]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        
        let headerView = HeroHeaderUIView(frame: .init(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func configureNavBar() {
        let image = UIImage(named: "netflix-logo")?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil), UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style:.done, target: self, action: nil)]
        
        navigationController?.navigationBar.tintColor = .label
        
    }
    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
            
        case Sections.TrendingMovies.rawValue:
            APIColler.shared.getTrendingMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TrendingTv.rawValue:
            APIColler.shared.getTrendingTv { result in
                switch result {
                case .success(let tvList):
                    cell.configure(with: tvList)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.UpcomingMovies.rawValue:
            APIColler.shared.getUpcomingMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            APIColler.shared.getPopularMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            APIColler.shared.getTopRatedMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default: return UITableViewCell()
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
            
    //SETUP THE HEADER TITLE OF SECTIONS
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
       
        var config = header.defaultContentConfiguration()
        config.text = sectionTitles[section]
        config.textProperties.font = .systemFont(ofSize: 18, weight: .semibold)
        config.textProperties.color = .label
        config.textProperties.transform = .capitalized

        header.contentConfiguration = config
        
//        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//        header.textLabel?.textColor = .black
//        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        
    }
    
    //TO HIDE TOP NAVIGATION WHEN SCROLLING
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let defaultOffset = view.safeAreaInsets.top
        let finalOffset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -finalOffset))
    }
    
}
