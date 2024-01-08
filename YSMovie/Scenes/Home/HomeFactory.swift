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
        let presenter = HomePresenter(interactor: interactor)
        let viewController = HomeViewController(presenter: presenter)
        
        presenter.output = viewController
        
        return viewController
    }
}
