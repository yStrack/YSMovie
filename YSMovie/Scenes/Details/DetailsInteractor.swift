//
//  DetailsInteractor.swift
//  YSMovie
//
//  Created by ystrack on 12/01/24.
//

import Combine

protocol DetailsInteractorInput {
    func fetchDetails(for movieId: Int) -> AnyPublisher<Movie, Error>
}

final class DetailsInteractor: DetailsInteractorInput {
    
    let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        self.service = service
    }
    
    func fetchDetails(for movieId: Int) -> AnyPublisher<Movie, Error> {
        let subject = PassthroughSubject<Movie, Error>()
        let endpoint = MovieEndpoint.details(movieId: movieId)
        service.sendRequest(endpoint: endpoint) { (result: Result<Movie, NetworkError>) in
            switch result {
            case .success(let movie):
                subject.send(movie)
                subject.send(completion: .finished)
            case .failure(let error):
                subject.send(completion: .failure(error))
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
}
