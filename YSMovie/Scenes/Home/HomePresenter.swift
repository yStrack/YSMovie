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
        interactor.fetchTrendingMovies()
            .zip(interactor.fetchNowPlayingMovies()) { trendingMovies, nowPlayingMovies in
                var sectionList: [Section] = []
                
                if !trendingMovies.isEmpty, let trendingMovie = trendingMovies.sorted(by: { $0.popularity > $1.popularity }).first {
                    sectionList.append(Section(title: "", content: [trendingMovie]))
                }
                sectionList.append(Section(title: String(localized: "Now Playing"), content: nowPlayingMovies))
                return sectionList
            }
            .zip(interactor.fetchPopularMovies(), interactor.fetchTopRatedMovies(),  interactor.fetchUpcomingMovies()) { (initialSectionList: [Section], popularMovies, topRatedMovies, upcomingMovies) in
                var finalSectionList = initialSectionList
                let newSectionList: [Section] = [
                    Section(title: String(localized: "Popular"), content: popularMovies),
                    Section(title: String(localized: "Top rated"), content: topRatedMovies),
                    Section(title: String(localized: "Upcoming"), content: upcomingMovies)
                ]
                finalSectionList.append(contentsOf: newSectionList)
                return finalSectionList
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
