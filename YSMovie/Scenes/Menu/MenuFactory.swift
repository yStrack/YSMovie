//
//  MenuFactory.swift
//  YSMovie
//
//  Created by ystrack on 23/01/24.
//

import UIKit

enum MenuFactory {
    static func build() -> UIViewController {
        let router = MenuRouter()
        let viewController = MenuViewController(router: router)
        router.viewController = viewController
        
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
