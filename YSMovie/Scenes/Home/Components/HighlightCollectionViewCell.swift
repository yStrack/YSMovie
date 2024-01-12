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
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12
        view.layer.shadowOpacity = 0.25
        view.layer.shadowRadius = 6.0
        return view
    }()
    
    var delegate: HighlightCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
        shadowView.addParallaxToView(amount: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: shadowView.layer.cornerRadius).cgPath
    }
    
    // MARK: Setup Views
    private func addSubviews() {
        shadowView.addSubview(imageView)
        addSubview(shadowView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: self.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            shadowView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            shadowView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.88),
            
            imageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
        ])
    }
    
    private func setupGradientColors(avarageColor: UIColor?) {
        let endColor = avarageColor?.withAlphaComponent(0.5).cgColor ?? UIColor.lightGray.withAlphaComponent(0.2).cgColor
        let colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, endColor]
        let gradientLayer = CAGradientLayer.gradientLayer(colors: colors, in: imageView.bounds)
        imageView.layer.addSublayer(gradientLayer)
    }
    
    public func setup(with movie: Movie) {
        guard let posterPath = movie.posterPath else { return }
        let imageURL = URL(string: "https://image.tmdb.org/t/p/original" + posterPath)
        imageView.kf.setImage(with: imageURL, placeholder: nil) { [weak self] result in
            switch result {
            case .success(let imageResult):
                guard let self else { return }
                setupGradientColors(avarageColor: imageResult.image.averageColor)
                delegate?.didSetImage(avarageColor: imageResult.image.averageColor)
            case .failure(_):
                return
            }
        }
        
    }
}
