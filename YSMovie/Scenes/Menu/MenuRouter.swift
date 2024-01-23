//
//  MenuRouter.swift
//  YSMovie
//
//  Created by ystrack on 23/01/24.
//

import UIKit

protocol MenuRouterProtocol {
    var viewController: UIViewController? { get }
    
    func presentAPIUsage()
}

final class MenuRouter: MenuRouterProtocol {
    var viewController: UIViewController?
    
    func presentAPIUsage() {
        let destination = UIViewController(nibName: nil, bundle: nil)
        destination.view = APIUsageView(frame: .zero)
        if let sheetPresentationController = destination.sheetPresentationController {
            sheetPresentationController.detents = [
                .medium()
            ]
            
            sheetPresentationController.prefersGrabberVisible = true
        }
        
        viewController?.present(destination, animated: true)
    }
}
