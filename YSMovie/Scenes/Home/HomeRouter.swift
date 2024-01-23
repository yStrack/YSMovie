//
//  HomeRouter.swift
//  YSMovie
//
//  Created by ystrack on 10/01/24.
//

import UIKit

protocol HomeRouterProtocol {
    var viewController: UIViewController? { get }
    
    func presentDetails(for movie: Movie, withCustomTransition: Bool)
    func presentSettings()
}

final class HomeRouter: HomeRouterProtocol {
    weak var viewController: UIViewController?
    private let transitionManager = TransitionManager()
    
    func presentDetails(for movie: Movie, withCustomTransition: Bool = false) {
        let destination = DetailsFactory.build(movie)
        destination.transitioningDelegate = withCustomTransition ? transitionManager : nil
        
        viewController?.present(destination, animated: true)
    }
    
    func presentSettings() {
        let destination = MenuFactory.build()
        
        viewController?.present(destination, animated: true)
    }
}
