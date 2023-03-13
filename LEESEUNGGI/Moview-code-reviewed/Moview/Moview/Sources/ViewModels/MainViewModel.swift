//
//  MainViewModel.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

class MainViewModel: ViewModelType {
  
  // MARK: - Properties
  
  struct Input {
    let viewDidLoad = PublishRelay<Void>()
    let didMovieItemSelected = PublishRelay<IndexPath>()
  }
  
  struct Output {
    let movieList = BehaviorRelay<[MovieDataSection]>(value: fakeMovieItems)
    let presentMovieDetail = PublishRelay<Movie>()
    let isLoading = BehaviorRelay<Bool>(value: true)
  }
  
  private(set) var input: Input!
  private(set) var output: Output!
  private(set) var disposeBag = DisposeBag()
  private let ytsApiService = YTSApiService()
  static var fakeMovieItems: [MovieDataSection] {
    let newMovieSection = MovieDataSection(
      items: [Movie.fakeItem(),
              Movie.fakeItem()])
    let recommendedMovieSection = MovieDataSection(
      items: [
        Movie.fakeItem(),
        Movie.fakeItem(),
        Movie.fakeItem()
      ])
    return [newMovieSection, recommendedMovieSection]
  }
  
  
  // MARK: - Initializers
  
  init() {
    setupInputOutput()
  }
  
  
  // MARK: - Setups
  
  private func setupInputOutput() {
    self.input = Input()
    let output = Output()
    
    input.viewDidLoad
      .flatMap { self.ytsApiService.getMovieList() }
      .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .default))
      .observe(on: MainScheduler.instance)
      .subscribe(with: self, onNext: { strongSelf, movies in
        let newMovieSection = MovieDataSection(items: Array(movies[...10]))
        let recommendedMovieSection = MovieDataSection(items: Array(movies[11...]))
        
        output.movieList.accept([newMovieSection, recommendedMovieSection])
        output.isLoading.accept(false)
      })
      .disposed(by: disposeBag)
    
    input.didMovieItemSelected
      .map { output.movieList.value[$0.section].items[$0.row] }
      .subscribe(with: self, onNext: { vc, selectedMovie in
        output.presentMovieDetail.accept(selectedMovie)
      })
      .disposed(by: disposeBag)
    
    self.output = output
  }
}
