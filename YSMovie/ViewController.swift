//
//  ViewController.swift
//  YSMovie
//
//  Created by ystrack on 07/01/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        let endpoint = MovieListEndpoint.nowPlaying
        let service = NetworkService()
        service.sendRequest(endpoint: endpoint) { [weak self] (result: Result<APIResponse, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.view.backgroundColor = .systemGreen
                }
                dump(response)
            case .failure(let failure):
                DispatchQueue.main.async {
                    self.view.backgroundColor = .systemRed
                }
                print("Error - \(failure)")
            }
        }
    }
}
