//
//  DetailsViewController.swift
//  YSMovie
//
//  Created by ystrack on 09/01/24.
//

import UIKit
import SwiftUI

final class DetailsViewController: UIViewController {
    
    // MARK: Subviews
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: DetailsTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        if let imagePath = movie.backdropPath {
            imageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w780" + imagePath))
        }
        return imageView
    }()
    
    private lazy var backgroundVisualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThickMaterialDark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()
    
    private lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar(frame: .zero)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        let navigationItem = UINavigationItem()
        // Configure SF Symbol with Pallet style and resize to .title2 font.
        let imageConfiguration = UIImage.SymbolConfiguration(paletteColors: [.white, .black.withAlphaComponent(0.6)])
            .applying(UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .title2)))
        // SF Symbol image used on navigation bar right bar button item.
        let rightBarButtonImage = UIImage(systemName: "xmark.circle.fill")?
            .applyingSymbolConfiguration(imageConfiguration)
        // Setup right bar button item.
        let rightBarButtonItem = UIBarButtonItem(image: rightBarButtonImage, style: .plain, target: self, action: #selector(closeView))
        rightBarButtonItem.image?.applyingSymbolConfiguration(imageConfiguration)
        // Set right bar button item.
        navigationItem.rightBarButtonItem = rightBarButtonItem
        // Add configured UINavigationItem to UINavigationBar.
        navigationBar.setItems([navigationItem], animated: true)
        
        // Appearance.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationBar.standardAppearance = appearance
        
        return navigationBar
    }()
    
    // MARK: Dependencies
    let movie: Movie
    let presenter: DetailsPresenterInput
    
    // MARK: Initializers
    init(movie: Movie, presenter: DetailsPresenterInput) {
        self.movie = movie
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        addSubviews()
        setupConstraints()
        presenter.getDetails()
    }
    
    // MARK: Setup Subviews
    private func addSubviews() {
        view.addSubview(backgroundVisualEffectView)
        view.addSubview(headerImageView)
        view.addSubview(tableView)
        view.addSubview(navigationBar)
    }
    
    private func setupSubviews() {
        view.backgroundColor = .clear
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundVisualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundVisualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundVisualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundVisualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    // MARK: Selectors
    @objc func closeView() {
        self.dismiss(animated: true)
    }
}

// MARK: UITableViewDataSource
extension DetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) else {
                fatalError("Failed to dequeueReusableCell - unregistered table view cell")
            }
            
            cell.contentConfiguration = UIHostingConfiguration {
                DetailsTableViewCell(
                    title: movie.title,
                    overview: movie.overview,
                    releaseYear: movie.getReleaseYear(),
                    runtime: movie.runtimeHourAndMinute()
                )
            }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        case 1:
            // TODO: Trailers Section Cell
            let cell = UITableViewCell(frame: .zero)
            cell.backgroundColor = .clear
            return cell
        default:
            return UITableViewCell(frame: .zero)
        }
    }
}

// MARK: UITableViewDelegate
extension DetailsViewController: DetailsPresenterOutput {
    func detailsDidLoad() {
        //
    }
}
