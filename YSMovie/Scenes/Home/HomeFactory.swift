//
//  HomeFactory.swift
//  YSMovie
//
//  Created by ystrack on 07/01/24.
//

import UIKit

enum HomeFactory {
    static func build() -> UIViewController {
        let service = NetworkService()
        let interactor = HomeInteractor(service: service)
        let router = HomeRouter()
        let presenter = HomePresenter(interactor: interactor, router: router)
        let viewController = HomeViewController(presenter: presenter)
        
        presenter.output = viewController
        router.viewController = viewController
        
        return viewController
    }
}
