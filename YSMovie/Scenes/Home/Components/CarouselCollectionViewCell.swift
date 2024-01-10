//
//  CarouselSectionCollectionViewCell.swift
//  YSMovie
//
//  Created by ystrack on 08/01/24.
//

import UIKit
import Kingfisher

final class CarouselCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "CarouselSectionCollectionViewCell"
    
    // MARK: Subviews
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup Views
    private func addSubviews() {
        addSubview(imageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    /// Setup subviews with Movie data.
    /// - Parameter movie: Movie data.
    public func setup(with movie: Movie) {
        let imageURL = URL(string: "https://image.tmdb.org/t/p/w780" + movie.posterPath)
        imageView.kf.setImage(with: imageURL, placeholder: nil)
    }
}
