//
//  UIViewController+Extension.swift
//  YSMovie
//
//  Created by ystrack on 09/01/24.
//

import UIKit

/// Set of reusable configuration functions for UIViewControllers.
extension UIViewController {
    // MARK: Navigation Bar Configuration
    /// Configure transparent background navigation bar for scrollEdgeAppearance
    /// and default background for standardAppearance.
    /// This way navigation bar is only transparent when view did not scroll.
    /// Also move navigation bar  title to left.
    func setupTransparentNavigationBar() {
        // Navigation bar title left aligned.
        let titleOffset = UIOffset(
            horizontal: -CGFloat.greatestFiniteMagnitude,
            vertical: 0
        )
        let titleTextAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.preferredFont(forTextStyle: .title2).bold()
        ]
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.configureWithTransparentBackground()
        scrollEdgeAppearance.backgroundColor = .clear
        scrollEdgeAppearance.titlePositionAdjustment = titleOffset
        scrollEdgeAppearance.titleTextAttributes = titleTextAttributes
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithDefaultBackground()
        standardAppearance.titlePositionAdjustment = titleOffset
        standardAppearance.titleTextAttributes = titleTextAttributes
        
        self.navigationItem.scrollEdgeAppearance = scrollEdgeAppearance
        self.navigationItem.standardAppearance = standardAppearance
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: View State Configuration
    /// Display a loading indicator on view's center.
    func showLoading() {
        if #available(iOS 17, *) {
            var config = UIContentUnavailableConfiguration.loading()
            config.text = nil
            config.imageProperties.tintColor = .white
            self.contentUnavailableConfiguration = config
            self.setNeedsUpdateContentUnavailableConfiguration()
        }
    }
    
    /// Hide loading indicator.
    func hideLoading() {
        if #available(iOS 17, *) {
            self.contentUnavailableConfiguration = nil
            self.setNeedsUpdateContentUnavailableConfiguration()
        }
    }
    
    /// Display an error view on ViewController view's center.
    /// The error view contains an image, title and a retry button.
    func showError(retryAction: @escaping () -> Void) {
        if #available(iOS 17, *) {
            var config = UIContentUnavailableConfiguration.empty()
            
            config.image = UIImage(systemName: "network.slash")
            config.imageProperties.tintColor = .white
            config.imageToTextPadding = 8
            config.text = String(localized: "Something went wrong")
            config.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
            config.textToButtonPadding = 8
            
            var retryButton = UIButton.Configuration.filled()
            retryButton.title = String(localized: "Try again")
            retryButton.buttonSize = .mini
            retryButton.cornerStyle = .medium
            retryButton.baseForegroundColor = .black
            retryButton.baseBackgroundColor = .white
            retryButton.imagePadding = 8
            retryButton.image = UIImage(systemName: "arrow.clockwise")
            config.button = retryButton
            config.buttonProperties.primaryAction = UIAction() { [weak self] _ in
                guard let self else { return }
                showLoading()
                retryAction()
            }
            
            self.contentUnavailableConfiguration = config
            self.setNeedsUpdateContentUnavailableConfiguration()
        }
    }
}
