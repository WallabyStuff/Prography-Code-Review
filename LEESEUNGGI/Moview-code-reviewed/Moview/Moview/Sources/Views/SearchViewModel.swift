//
//  SearchViewModel.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import UIKit

import RxSwift
import RxCocoa

class SearchViewModel: ViewModelType {
  
  // MARK: - Properties
  
  struct Input {
    let search = PublishRelay<String>()
    let didSelectItem = PublishRelay<IndexPath>()
  }
  
  struct Output {
    let isLoading = PublishRelay<Bool>()
    let searchResultMovie = BehaviorRelay<[Movie]>(value: [])
    let presentMoviewDetailVC = PublishRelay<Movie>()
    let showToastMessage = PublishRelay<String>()
  }
  
  private(set) var input: Input!
  private(set) var output: Output!
  private(set) var disposeBag = DisposeBag()
  private let ytsApiService = YTSApiService()
  static var fakeMovieItems: [Movie] {
    return Array(repeating: Movie.fakeItem(), count: 10)
  }
  
  
  // MARK: - Initializers
  
  init() {
    setupInputOutput()
  }
  
  
  // MARK: - Setups
  
  private func setupInputOutput() {
    self.input = Input()
    let output = Output()
    
    input.search
      .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .default))
      .observe(on: MainScheduler.instance)
      .map { term in
        output.searchResultMovie.accept(Self.fakeMovieItems)
        output.isLoading.accept(true)
        return term
      }
      .flatMap {
        self.ytsApiService.searchMovie(term: $0)
          .catch { error in
            /// ERROR state
            if let error = error as? YTSApiService.YTSApiServiceError,
               error == .lessThenMinimumTermLength {
              output.showToastMessage.accept("Please enter at least two letter")
            }
            
            return .just([])
          }
      }
      .subscribe(onNext: { movies in
        /// SUCCESS state
        output.isLoading.accept(false)
        output.searchResultMovie.accept(movies)
      })
      .disposed(by: disposeBag)
    
    input.didSelectItem
      .map { output.searchResultMovie.value[$0.row] }
      .subscribe(onNext: { movie in
        output.presentMoviewDetailVC.accept(movie)
      })
      .disposed(by: disposeBag)
    
    self.output = output
  }
}
