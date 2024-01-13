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
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.showsSeparators = false
            configuration.backgroundColor = .clear
//            configuration.headerTopPadding = 0
            configuration.headerMode = sectionIndex == 1 ? .supplementary : .none
            
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            section.boundarySupplementaryItems.forEach { element in
                // Adjust header alignment.
                element.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
                // Avoid pinning header.
                element.pinToVisibleBounds = false
            }
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            return section
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: InfosCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "VideoCell")
        collectionView.register(
            SegmentedControlHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SegmentedControlHeaderView.identifier
        )
        return collectionView
    }()
    
    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
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
    private lazy var dataSource = makeDataSource()
    let presenter: DetailsPresenterInput
    
    // MARK: Initializers
    init(presenter: DetailsPresenterInput) {
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
        view.addSubview(collectionView)
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
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    // MARK: Selectors
    @objc func closeView() {
        self.dismiss(animated: true)
    }
    
    // MARK: CollectionView Data Source
    func makeDataSource() -> UICollectionViewDiffableDataSource<DetailsCollectionViewSection, AnyHashable> {
        let dataSource = UICollectionViewDiffableDataSource<DetailsCollectionViewSection, AnyHashable>(collectionView: collectionView) { collectionView, indexPath, item in
            let section = indexPath.section
            
            switch section {
            case 0:
                guard let movie = item as? Movie else {
                    fatalError("Unkown Details CollectionView item for section 0.")
                }
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfosCell.identifier, for: indexPath)
                cell.contentConfiguration = UIHostingConfiguration {
                    InfosCell(
                        title: movie.title,
                        overview: movie.overview,
                        certification: movie.getAgeRating() ?? "L",
                        releaseYear: movie.getReleaseYear(),
                        runtime: movie.runtimeHourAndMinute()
                    )
                }
                .margins(.all, 0) // Pin to edges.
                
                return cell
            case 1:
                guard let video = item as? Video else {
                    fatalError("Unkown Details CollectionView item for section 1.")
                }
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath)
                let text: String = "\(video.type): \(video.name)"
                cell.contentConfiguration = UIHostingConfiguration {
                    HStack {
                        Text(text)
                        Spacer()
                    }
                }
                .margins(.horizontal, 0) // Pin to edges.
                
                return cell
            default:
                fatalError("Unkown Details CollectionView section.")
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SegmentedControlHeaderView.identifier,
                for: indexPath
            ) as? SegmentedControlHeaderView
            
            return headerView
        }
        
        return dataSource
    }
}

// MARK: Presenter Output Extension
extension DetailsViewController: DetailsPresenterOutput {
    func detailsDidLoad(_ movie: Movie) {
        if let imagePath = movie.backdropPath {
            headerImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w780" + imagePath))
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<DetailsCollectionViewSection, AnyHashable>()
        snapshot.appendSections([.infos])
        snapshot.appendItems([movie], toSection: .infos)
        
        if let videos = movie.getVideos() {
            snapshot.appendSections([.extras])
            snapshot.appendItems(videos, toSection: .extras)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
