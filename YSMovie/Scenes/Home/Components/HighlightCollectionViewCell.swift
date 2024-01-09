//
//  HighlightCollectionViewCell.swift
//  YSMovie
//
//  Created by ystrack on 09/01/24.
//

import UIKit

protocol HighlightCellDelegate {
    func didSetImage(avarageColor: UIColor?)
}

final class HighlightCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "HighlightCollectionViewCell"
    
    // MARK: Subviews
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        imageView.layer.borderWidth = 1.0
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var foregroundView: UIView = {
        let view = UIView()
        view.backgroundColor = nil
        return view
    }()
    
    var didSetGradient: Bool = false
    var delegate: HighlightCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
        imageView.addParallaxToView(amount: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !didSetGradient {
            let colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.lightGray.withAlphaComponent(0.2).cgColor]
            let gradientLayer = CAGradientLayer.gradientLayer(colors: colors, in: imageView.frame)
            foregroundView.layer.addSublayer(gradientLayer)
            didSetGradient = true
        }
    }
    
    // MARK: Setup Views
    private func addSubviews() {
        addSubview(imageView)
        addSubview(foregroundView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.88),
        ])
    }
    
    public func setup(with movie: Movie) {
        let imageURL = URL(string: "https://image.tmdb.org/t/p/original" + movie.posterPath)
        imageView.kf.setImage(with: imageURL, placeholder: nil) { [weak self] result in
            switch result {
            case .success(_):
                self?.delegate?.didSetImage(avarageColor: self?.imageView.image?.averageColor)
            case .failure(_):
                return
            }
        }
        
    }
}
