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
    func didSelectMovie(_ movie: Movie, at section: Int)
}

protocol HomePresenterOutput {
    func movieSectionsDidLoad(_ sectionList: [Section])
    func movieSectionsDidFail()
}

final class HomePresenter: HomePresenterInput {
    
    // MARK: Dependencies
    let interactor: HomeInteractorProtocol
    let router: HomeRouterProtocol
    var output: HomePresenterOutput?
    
    // MARK: Dispose bag
    var cancellables = Set<AnyCancellable>()
    
    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
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
            .sink { [weak self] completion in
                if case .failure(_) = completion {
                    self?.output?.movieSectionsDidFail()
                    return
                }
            } receiveValue: { [weak self] (sectionList: [Section]) in
                self?.output?.movieSectionsDidLoad(sectionList)
            }
            .store(in: &cancellables)
    }
    
    func didSelectMovie(_ movie: Movie, at section: Int) {
        router.presentDetails(for: movie, withCustomTransition: section == 0 ? false : true)
    }
}
