//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by 이예은 on 2023/02/05.
//

import UIKit
import Combine

// MARK: - Input, Output
protocol MovieDetailViewModelInput {
    func didTapShareButton()
}

protocol MovieDetailViewModelOutput {
    var model: Movie { get }
    var shareMovieInfoPublisher: AnyPublisher<[String], Never> { get }
}

protocol MovieDetailViewModelInterface {
    var input: MovieDetailViewModelInput { get }
    var output: MovieDetailViewModelOutput { get }
}

class MovieDetailViewModel: MovieDetailViewModelInterface, MovieDetailViewModelInput, MovieDetailViewModelOutput {
    
    // MARK: - Properties
    var input: MovieDetailViewModelInput { self }
    var output: MovieDetailViewModelOutput { self }
    var cancellables = Set<AnyCancellable>()
    var model: Movie
    var _shareMovieInfoPublisher = PassthroughSubject<[String], Never>()
    var shareMovieInfoPublisher: AnyPublisher<[String], Never> {
        _shareMovieInfoPublisher.eraseToAnyPublisher()
    }
    
    init(model: Movie) {
        self.model = model
    }
    
    func didTapShareButton() {
        _shareMovieInfoPublisher.send([
        """
        🍿 Movie Information 🍿
        영화명: \(model.title)
        개봉일: \(model.year)
        상영시간: \(String(describing: model.runtime))
        랭킹: \(String(describing: model.rating))
        장르: \(model.genres.first ?? "장르 없음")
        """
        ])
    }
}
