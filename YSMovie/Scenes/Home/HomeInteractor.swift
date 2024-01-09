//
//  HomeInteractor.swift
//  YSMovie
//
//  Created by ystrack on 07/01/24.
//

import Foundation
import Combine

protocol HomeInteractorProtocol {
    func fetchNowPlayingMovies() -> AnyPublisher<[Movie], Error>
    func fetchPopularMovies() -> AnyPublisher<[Movie], Error>
    func fetchTopRatedMovies() -> AnyPublisher<[Movie], Error>
    func fetchUpcomingMovies() -> AnyPublisher<[Movie], Error>
    func fetchTrendingMovies() -> AnyPublisher<[Movie], Error>
}

final class HomeInteractor: HomeInteractorProtocol {
    
    let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        self.service = service
    }
    
    func fetchNowPlayingMovies() -> AnyPublisher<[Movie], Error> {
        return self.fetchMovies(MovieListEndpoint.nowPlaying)
    }
    
    func fetchPopularMovies() -> AnyPublisher<[Movie], Error> {
        return self.fetchMovies(MovieListEndpoint.popular)
    }
    
    func fetchTopRatedMovies() -> AnyPublisher<[Movie], Error> {
        return self.fetchMovies(MovieListEndpoint.topRated)
    }
    
    func fetchUpcomingMovies() -> AnyPublisher<[Movie], Error> {
        return self.fetchMovies(MovieListEndpoint.upcoming)
    }
    
    func fetchTrendingMovies() -> AnyPublisher<[Movie], Error> {
        return self.fetchMovies(TrendingEndpoint.movie)
    }
    
    private func fetchMovies(_ endpoint: Endpoint) -> AnyPublisher<[Movie], Error> {
        let subject: PassthroughSubject<[Movie], Error> = .init()
        
        service.sendRequest(endpoint: endpoint) { (result: Result<APIResponse, NetworkError>) in
            switch result {
            case .success(let response):
                let movies = response.results
                subject.send(movies)
                subject.send(completion: .finished)
            case .failure(let error):
                subject.send(completion: .failure(error))
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
}
