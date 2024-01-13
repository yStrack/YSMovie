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
    func updateSelectedSegmentedControlIndex(to index: Int)
}

protocol DetailsPresenterOutput {
    func movieDidLoad(_ movie: Movie)
    func detailsSectionsDidLoad(_ sections: [DetailsCollectionViewSection])
}

// MARK: ViewModels
enum DetailsCollectionViewSection: Hashable {
    /// Movie infos such as title, overview, release date...
    case infos(movie: Movie)
    /// Movie related extras such as trailers, similar movies...
    case extras(items: [AnyHashable])
}

final class DetailsPresenter: DetailsPresenterInput {
    
    // MARK: State control
    var selectedSegmentedControlIndex: Int = 0
    
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
        output?.movieDidLoad(movie)
        interactor.fetchDetails(for: movie.id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] movie in
                guard let self else { return }
                self.movie = movie
                let sections = buildSections(input: movie)
                output?.detailsSectionsDidLoad(sections)
            }
            .store(in: &cancellables)
    }
    
    func updateSelectedSegmentedControlIndex(to index: Int) {
        self.selectedSegmentedControlIndex = index
        let updatedSections = buildSections(input: movie)
        DispatchQueue.main.async {
            self.output?.detailsSectionsDidLoad(updatedSections)
        }
    }
    
    private func buildSections(input: Movie) -> [DetailsCollectionViewSection] {
        var sections: [DetailsCollectionViewSection] = [DetailsCollectionViewSection.infos(movie: movie)]
        
        var extrasSection: DetailsCollectionViewSection = .extras(items: [])
        if selectedSegmentedControlIndex == 0, let similars = input.geSimilars(), !similars.isEmpty {
            extrasSection = .extras(items: similars)
        }
        
        if selectedSegmentedControlIndex == 1, let videos = input.getVideos(), !videos.isEmpty {
            extrasSection = .extras(items: videos)
        }
        
        sections.append(extrasSection)
        return sections
    }
}
