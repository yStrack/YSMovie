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
    
    // MARK: Setup Views
    private func addSubviews() {
        addSubview(imageView)
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

extension UIView {
    func addParallaxToView(amount: Int) {
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        self.addMotionEffect(group)
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension CAGradientLayer {
    static func gradientLayer(colors: [CGColor], in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = colors
        layer.frame = frame
        return layer
    }
}
