//
//  HomeViewController.swift
//  YSMovie
//
//  Created by ystrack on 07/01/24.
//

import UIKit

// MARK: UICollectionView Section ViewModel
struct Section: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let content: [Movie]
}

class HomeViewController: UIViewController {
    
    // MARK: Views
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .medium
        indicator.color = .label
        indicator.tintColor = .label
        indicator.backgroundColor = .clear
        indicator.hidesWhenStopped = true
        indicator.contentMode = .scaleToFill
        indicator.startAnimating()
        return indicator
    }()
    
    // MARK: Dependencies
    let presenter: HomePresenterInput
    
    init(presenter: HomePresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        addSubviews()
        setupConstraints()
        presenter.getMovieSections()
    }
    
    // MARK: Setup subviews
    private func addSubviews() {
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

// MARK: - HomePresenterOutput
extension HomeViewController: HomePresenterOutput {
    func movieSectionsDidLoad(_ sectionList: [Section]) {
        print("[movieSectionsDidLoad]")
        sectionList.forEach { section in
            print("Section: \(section.title) - Items: \(section.content.count)")
        }
        
        activityIndicator.stopAnimating()
        view.backgroundColor = .systemGreen
    }
}
