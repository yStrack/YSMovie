//
//  HomeViewController.swift
//  YSMovie
//
//  Created by ystrack on 07/01/24.
//

import UIKit

// MARK: UICollectionView Section ViewModel
struct Section: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let title: String
    let content: [Movie]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.id == rhs.id
    }
}

class HomeViewController: UIViewController {
    
    // MARK: Views
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        
        collectionView.register(
            CarouselCollectionViewCell.self,
            forCellWithReuseIdentifier: CarouselCollectionViewCell.identifier
        )
        collectionView.register(
            HighlightCollectionViewCell.self,
            forCellWithReuseIdentifier: HighlightCollectionViewCell.identifier
        )
        collectionView.register(
            CarouselSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CarouselSectionHeaderView.identifier
        )
        return collectionView
    }()
    
    // MARK: Collection View DataSource
    private lazy var dataSource = makeDataSource()
    
    // MARK: Dependencies
    let presenter: HomePresenterInput
    
    // MARK: Initializers
    init(presenter: HomePresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = String(localized: "For you")
        showLoading()
        addSubviews()
        setupConstraints()
        setupCollectionViewLayout()
        setupTransparentNavigationBar()
        presenter.getMovieSections()
    }
    
    // MARK: Setup subviews
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func refreshBackground(with colors: [CGColor]) {
        collectionView.backgroundColor = .black
        let backgroundView = UIView()
        let gradientLayer = CAGradientLayer.gradientLayer(colors: colors, in: collectionView.frame)
        backgroundView.layer.addSublayer(gradientLayer)
        collectionView.backgroundView = backgroundView
    }
    
    // MARK: Collection View functions
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Movie> {
        let dataSource = UICollectionViewDiffableDataSource<Section, Movie>.init(
            collectionView: collectionView) { collectionView, indexPath, item in
                
                switch indexPath.section {
                case 0:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HighlightCollectionViewCell.identifier, for: indexPath) as! HighlightCollectionViewCell
                    cell.setup(with: item)
                    cell.delegate = self
                    return cell
                default:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
                    cell.setup(with: item)
                    return cell
                }
                
            }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: CarouselSectionHeaderView.identifier,
                for: indexPath
            ) as? CarouselSectionHeaderView
            
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            headerView?.setup(title: section.title)
            return headerView
        }
        
        return dataSource
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                return self.highlightSection()
            default:
                return self.carouselSection()
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func carouselSection() -> NSCollectionLayoutSection {
        // Item config
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group config
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.28),
            heightDimension: .absolute(160)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 8
        )
        
        // Section config
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 8,
            bottom: 16,
            trailing: 0
        )
        section.orthogonalScrollingBehavior = .continuous
        
        // Section Header config
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func highlightSection() -> NSCollectionLayoutSection {
        // Item config
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group config
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.52)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section config
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 16,
            leading: 0,
            bottom: 16,
            trailing: 0
        )
        section.orthogonalScrollingBehavior = .none
        
        return section
    }
}

// MARK: - HomePresenterOutput
extension HomeViewController: HomePresenterOutput {
    func movieSectionsDidLoad(_ sectionList: [Section]) {
        hideLoading()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections(sectionList)
        
        sectionList.forEach { section in
            snapshot.appendItems(section.content, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func movieSectionsDidFail() {
        self.showError(retryAction: { [weak self] in
            guard let self else { return }
            self.presenter.getMovieSections()
        })
    }
}

// MARK: Highlight CollectionView Cell Delegate
extension HomeViewController: HighlightCellDelegate {
    func didSetImage(avarageColor: UIColor?) {
        guard let avarageColor else {
            return
        }
        let startColor = avarageColor
        refreshBackground(with: [
            startColor.cgColor,
            startColor.cgColor,
            startColor.cgColor,
            startColor.withAlphaComponent(0.5).cgColor,
            startColor.withAlphaComponent(0.25).cgColor,
            startColor.withAlphaComponent(0.1).cgColor]
        )
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalOffset = scrollView.contentOffset.y
        let threshold: CGFloat = scrollView.frame.height / 4.0
        let alpha = (verticalOffset) / threshold
        collectionView.backgroundView?.alpha = (1 - alpha)
    }
}
