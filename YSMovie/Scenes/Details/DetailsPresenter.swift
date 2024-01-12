//
//  DetailsPresenter.swift
//  YSMovie
//
//  Created by ystrack on 12/01/24.
//

import Foundation
import Combine

protocol DetailsPresenterInput {
    func getDetails()
}

protocol DetailsPresenterOutput {
    func detailsDidLoad(_ movie: Movie)
}

// MARK: ViewModels
enum DetailsCollectionViewSection {
    /// Movie infos such as title, overview, release date...
    case infos
    /// Movie related extras such as trailers, similar movies...
    case extras
}

final class DetailsPresenter: DetailsPresenterInput {
    
    // MARK: Dispose bag
    var cancellables = Set<AnyCancellable>()
    
    // MARK: Dependencies
    var movie: Movie
    let interactor: DetailsInteractorInput
    var output: DetailsPresenterOutput?
    
    init(movie: Movie, interactor: DetailsInteractorInput) {
        self.movie = movie
        self.interactor = interactor
    }
    
    func getDetails() {
        output?.detailsDidLoad(movie)
        interactor.fetchDetails(for: movie.id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] movie in
                guard let self else { return }
                self.movie = movie
                output?.detailsDidLoad(movie)
            }
            .store(in: &cancellables)
    }
}
