//
//  DetailsPresenter.swift
//  YSMovie
//
//  Created by ystrack on 12/01/24.
//

import Combine

protocol DetailsPresenterInput {
    func getDetails()
}

protocol DetailsPresenterOutput {
    func detailsDidLoad()
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
        interactor.fetchDetails(for: movie.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] movie in
                guard let self else { return }
                self.movie = movie
            }
            .store(in: &cancellables)
    }
}
