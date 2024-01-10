//
//  HomeRouter.swift
//  YSMovie
//
//  Created by ystrack on 10/01/24.
//

import UIKit

protocol HomeRouterProtocol {
    var viewController: UIViewController? { get }
    
    func presentDetails(for movie: Movie)
}

final class HomeRouter: HomeRouterProtocol {
    weak var viewController: UIViewController?
    
    func presentDetails(for movie: Movie) {
        let destination = DetailsFactory.build(movie)
        viewController?.present(destination, animated: true)
    }
}
