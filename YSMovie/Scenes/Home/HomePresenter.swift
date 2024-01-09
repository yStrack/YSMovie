//
//  HomePresenter.swift
//  YSMovie
//
//  Created by ystrack on 07/01/24.
//

import Foundation
import Combine

protocol HomePresenterInput {
    func getMovieSections()
}

protocol HomePresenterOutput {
    func movieSectionsDidLoad(_ sectionList: [Section])
}

final class HomePresenter: HomePresenterInput {
    
    // MARK: Dependencies
    let interactor: HomeInteractorProtocol
    var output: HomePresenterOutput?
    
    // MARK: Dispose bag
    var cancellables = Set<AnyCancellable>()
    
    init(interactor: HomeInteractorProtocol) {
        self.interactor = interactor
    }
    
    func getMovieSections() {
        interactor.fetchTopRatedMovies()
            .zip(interactor.fetchNowPlayingMovies(), interactor.fetchUpcomingMovies(), interactor.fetchPopularMovies()) { topRatedMovies, nowPlayingMovies, upcomingMovies, popularMovies in
                let sectionList: [Section] = [
                    Section(title: "Now Playing", content: nowPlayingMovies),
                    Section(title: "Popular", content: popularMovies),
                    Section(title: "Top rated", content: topRatedMovies),
                    Section(title: "Upcoming", content: upcomingMovies)
                ]
                return sectionList
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(_) = completion {
                    // TODO: Handle error
                    return
                }
            } receiveValue: { [weak self] (sectionList: [Section]) in
                self?.output?.movieSectionsDidLoad(sectionList)
            }
            .store(in: &cancellables)
    }
}
