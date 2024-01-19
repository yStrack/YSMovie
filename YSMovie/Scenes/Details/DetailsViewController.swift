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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        collectionView.register(
            SegmentedControlHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
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
        view.addSubview(headerImageView)
        view.addSubview(collectionView)
        view.addSubview(navigationBar)
    }
    
    private func setupSubviews() {
        if transitioningDelegate == nil {
            view.backgroundColor = .black
            return
        }
        view.backgroundColor = .clear
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
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
    let infosCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, AnyHashable> { (cell, indexPath, item) in
        guard let movie = item as? Movie else {
            fatalError("Unkown Details CollectionView item for section 0.")
        }
        
        cell.contentConfiguration = UIHostingConfiguration {
            InfosCell(
                title: movie.title,
                overview: movie.overview,
                certification: movie.getAgeRating(),
                releaseYear: movie.getReleaseYear(),
                runtime: movie.runtimeHourAndMinute()
            )
        }
        .margins(.all, 0) // Pin to edges.
    }
    
    let videosCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, AnyHashable> { (cell, indexPath, item) in
        guard let video = item as? Video else {
            fatalError("Unkown Details CollectionView item for section 0.")
        }
        
        let text: String = "\(video.type): \(video.name)"
        cell.contentConfiguration = UIHostingConfiguration {
            HStack {
                VStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color.secondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 176)
                    Text(text)
                }
                Spacer()
            }
        }
        .margins(.horizontal, 0) // Pin to edges.
    }
    
    let similarsCellRegistration = UICollectionView.CellRegistration<CarouselCollectionViewCell, AnyHashable> { (cell, indexPath, item) in
        guard let movie = item as? Movie else {
            fatalError("Unkown Details CollectionView item for section 0.")
        }
        cell.setup(with: movie)
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<DetailsCollectionViewSection, AnyHashable> {
        let dataSource = UICollectionViewDiffableDataSource<DetailsCollectionViewSection, AnyHashable>(collectionView: collectionView) { collectionView, indexPath, item in
            let section = indexPath.section
            
            switch section {
            case 0:
                return collectionView.dequeueConfiguredReusableCell(using: self.infosCellRegistration, for: indexPath, item: item)
            case 1:
                // Config section using Video Cell.
                if let _ = item as? Video {
                    return collectionView.dequeueConfiguredReusableCell(using: self.videosCellRegistration, for: indexPath, item: item)
                }
                
                // Config section using Movie Cell.
                if let _ = item as? Movie {
                    return collectionView.dequeueConfiguredReusableCell(using: self.similarsCellRegistration, for: indexPath, item: item)
                }
                
                fatalError("Unkown Details CollectionView item for section 1.")
            default:
                fatalError("Unkown Details CollectionView section.")
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionFooter else {
                return nil
            }
            
            let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: SegmentedControlHeaderView.identifier,
                for: indexPath
            ) as? SegmentedControlHeaderView
            footerView?.delegate = self
            
            return footerView
        }
        
        return dataSource
    }
    
    // MARK: CollectionView Layout
    private func setupCollectionViewLayout(selectedSegmentedControlIndex: Int) {
        collectionView.setContentOffset(.zero, animated: true)
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            if sectionIndex == 1, selectedSegmentedControlIndex == 0 {
                return self.similarsLayout()
            }
            
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.showsSeparators = false
            configuration.backgroundColor = .clear
            configuration.footerMode = sectionIndex == 0 ? .supplementary : .none
            
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            return section
        }
        
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func similarsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(176))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 0, trailing: 8)
        section.interGroupSpacing = 12
        return section
    }
}

// MARK: Presenter Output Extension
extension DetailsViewController: DetailsPresenterOutput {
    func movieDidLoad(_ movie: Movie) {
        // Update header image view.
        if let imagePath = movie.backdropPath {
            headerImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w780" + imagePath))
        }
    }
    
    func detailsSectionsDidLoad(_ sections: [DetailsCollectionViewSection], for selectedSegmentedControlIndex: Int) {
        // Update layout.
        setupCollectionViewLayout(selectedSegmentedControlIndex: selectedSegmentedControlIndex)
        // Apply data changes.
        var snapshot = NSDiffableDataSourceSnapshot<DetailsCollectionViewSection, AnyHashable>()
        snapshot.appendSections(sections)
        sections.forEach { section in
            switch section {
            case .infos(let movie):
                snapshot.appendItems([movie], toSection: section)
            case .extras(let items):
                snapshot.appendItems(items, toSection: section)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: SegmentedControl Delegate Extension
extension DetailsViewController: SegmentedControlDelegate {
    func selectedSegmentedIndexDidChange(_ newValue: Int) {
        presenter.updateSelectedSegmentedControlIndex(to: newValue)
    }
}
