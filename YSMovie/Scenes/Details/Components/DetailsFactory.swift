//
//  DetailsFactory.swift
//  YSMovie
//
//  Created by ystrack on 10/01/24.
//

import UIKit

enum DetailsFactory {
    static func build(_ input: Movie) -> UIViewController {
        let viewController = DetailsViewController(movie: input)
        viewController.modalPresentationStyle = .overCurrentContext
        
        return viewController
    }
}
