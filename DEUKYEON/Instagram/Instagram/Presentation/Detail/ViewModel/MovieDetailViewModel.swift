//
//  MovieDetailViewModel.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import RxSwift
import RxRelay

final class MovieDetailViewModel {
  
  // MARK: - Output
  struct Output {
    let movieDetail = BehaviorRelay<Movie>(value: Movie.empty)
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: MovieDetailCoordinator?
  private let disposeBag = DisposeBag()
  let output = Output()
  
  // MARK: - Life Cycle
  init(coordinator: MovieDetailCoordinator,
       movie: Movie) {
    self.coordinator = coordinator
    self.transform(output: self.output, movie: movie)
  }
  
  
  // MARK: - Binding
  func transform(output: Output, movie: Movie) {
    self.bindOutput(output: output, movie: movie)
  }
  
  private func bindOutput(output: Output, movie: Movie) {
    output.movieDetail.accept(movie)
  }
}
