//
//  DetailsFactory.swift
//  YSMovie
//
//  Created by ystrack on 10/01/24.
//

import UIKit
import Combine

enum DetailsFactory {
    static func build(_ input: Movie) -> UIViewController {
        let service = NetworkService()
        let interactor = DetailsInteractor(service: service)
        let presenter = DetailsPresenter(movie: input, interactor: interactor)
        let viewController = DetailsViewController(movie: input, presenter: presenter)
        
        viewController.modalPresentationStyle = .overCurrentContext
        presenter.output = viewController
        
        return viewController
    }
}
