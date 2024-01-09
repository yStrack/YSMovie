//
//  UIViewController+Extension.swift
//  YSMovie
//
//  Created by ystrack on 09/01/24.
//

import UIKit

extension UIViewController {
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
}
