//
//  MovieDetailViewModel.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import UIKit

import RxSwift
import RxCocoa

class MovieDetailViewModel: ViewModelType {
  
  // MARK: - Properties
  
  struct Input {
    let viewDidLoad = PublishRelay<Void>()
    let didTapBookmarkButton = PublishRelay<Bool>()
    let didMovieItemSelected = PublishRelay<IndexPath>()
  }
  
  struct Output {
    let currentMovie = BehaviorRelay<Movie>(value: Movie.fakeItem())
    let bookmarkState = BehaviorRelay<Bool>(value: false)
  }
  
  private(set) var input: Input!
  private(set) var output: Output!
  private(set) var disposeBag = DisposeBag()
  private var bookmarkManager = BookmarkManager()
  
  
  // MARK: - Initializers
  
  init(movie: Movie) {
    setupInputOutput(movie: movie)
  }
  
  
  // MARK: - Setups
  
  private func setupInputOutput(movie: Movie) {
    self.input = Input()
    let output = Output()
    
    input.viewDidLoad
      .subscribe(with: self, onNext: { stringSelf, _ in
        output.currentMovie.accept(movie)
        
        /// Update initial bookmark state
        let isBookmarked = stringSelf.bookmarkManager.isBookmarked(id: movie.id)
        output.bookmarkState.accept(isBookmarked)
      })
      .disposed(by: disposeBag)
    
    input.didTapBookmarkButton
      .flatMap { [weak self] isBookmarked -> Completable in
        guard let self = self else { return .empty() }
        if isBookmarked {
          output.bookmarkState.accept(false)
          return self.bookmarkManager.deleteData(id: output.currentMovie.value.id)
        } else {
          output.bookmarkState.accept(true)
          return self.bookmarkManager.addData(output.currentMovie.value)
        }
      }
      .subscribe()
      .disposed(by: disposeBag)

    self.output = output
  }
}
