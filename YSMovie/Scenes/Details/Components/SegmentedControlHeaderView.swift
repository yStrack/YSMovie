//
//  SegmentedControl.swift
//  YSMovie
//
//  Created by ystrack on 12/01/24.
//

import UIKit

protocol SegmentedControlDelegate {
    func selectedSegmentedIndexDidChange(_ newValue: Int)
}

final class SegmentedControlHeaderView: UICollectionReusableView {
    static let identifier: String = "SegmentedControlHeaderView"
    
    // MARK: Subviews
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var similarsButton: UIButton = {
        let button = SegmentedControlButton(title: String(localized: "Similars"))
        button.isSelected = true
        button.addAction(UIAction() { _ in
            self.selectedIndex = 0
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var trailersButton: UIButton = {
        let button = SegmentedControlButton(title: String(localized: "Trailers & More"))
        button.isSelected = false
        button.addAction(UIAction() { _ in
            self.selectedIndex = 1
        }, for: .touchUpInside)
        return button
    }()
    
    var selectedIndex: Int = 0 {
        didSet {
            delegate?.selectedSegmentedIndexDidChange(selectedIndex)
            updateSelectedButton()
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    }
    
    // MARK: Delegate
    var delegate: SegmentedControlDelegate?
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup Subviews
    private func addSubviews() {
        stackView.addArrangedSubview(similarsButton)
        stackView.addArrangedSubview(trailersButton)
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    // MARK: View State update functions
    private func updateSelectedButton() {
        if selectedIndex == 0 {
            similarsButton.isSelected = true
            trailersButton.isSelected = false
            return
        }
        
        similarsButton.isSelected = false
        trailersButton.isSelected = true
    }
}

// MARK: SegmentedControlButton
final class SegmentedControlButton: UIButton {
    
    // MARK: Subviews
    private lazy var indicatorView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            updateIndicator()
        }
    }
    
    var indicatorWidthConstraint: NSLayoutConstraint?
    
    // MARK: Initializer
    convenience init(title: String) {
        self.init(frame: .zero)
        self.configuration = makeConfiguration(title: title)
        addSubview(indicatorView)
        setupConstraints()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateIndicator()
    }
    
    // MARK: Button Configuration
    private func makeConfiguration(title: String) -> UIButton.Configuration {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.title = title
        buttonConfig.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .body).bold()])
        )
        buttonConfig.titleAlignment = .leading
        buttonConfig.contentInsets = .init(top: 12, leading: 0, bottom: 0, trailing: 0)
        buttonConfig.baseBackgroundColor = .clear
        buttonConfig.baseForegroundColor = .white
        return buttonConfig
    }
    
    // MARK: Setup Subviews
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: self.topAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 4),
            indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
        indicatorWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: 0)
        indicatorWidthConstraint?.isActive = true
    }
    
    private func updateIndicator() {
        guard let indicatorWidthConstraint else { return }
        if isSelected {
            indicatorWidthConstraint.constant = frame.width
            return
        }
        indicatorWidthConstraint.constant = 0
    }
    
    override func updateConfiguration() {
        guard var config = configuration else { return }
        
        switch isSelected {
        case true:
            config.baseForegroundColor = .white
        case false:
            config.baseForegroundColor = .secondaryLabel
        }
        
        configuration = config
    }
}
