//
//  SettingsFactory.swift
//  YSMovie
//
//  Created by ystrack on 23/01/24.
//

import UIKit

enum SettingsFactory {
    static func build() -> UIViewController {
        let viewController = SettingsViewController()
        if let sheetPresentationController = viewController.sheetPresentationController {
            sheetPresentationController.detents = [
                .custom(resolver: { context in
                    return context.maximumDetentValue * 0.2
                })
            ]
            
            sheetPresentationController.preferredCornerRadius = 12
            sheetPresentationController.prefersGrabberVisible = false
        }
        
        return viewController
    }
}
