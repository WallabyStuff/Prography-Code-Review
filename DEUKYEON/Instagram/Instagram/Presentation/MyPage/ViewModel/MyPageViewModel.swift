//
//  MyPageViewModel.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/05.
//

import RxSwift
import RxRelay

final class MyPageViewModel {
  
  // MARK: - Input & Output
  
  /// `deleteButtonDidTapEvent` : 영화 Cell의 삭제버튼을 누를때, `Int` : 영화의 row
  /// `movieDidTapEvent` : 영화 Cell을 클릭했을 때
  /// `movieDidDeleteEvent` : 영화가 삭제되었을때 (팝업에서 삭제 확인)
  /// `movieDidAddEvent` : 영화가 추가되었을때 (목록, 또는 검색에서 하트 누를 시)
  struct Input {
    let deleteButtonDidTapEvent = PublishRelay<Int>()
    let movieDidTapEvent = PublishRelay<Int>()
    let movieDidDeleteEvent = PublishRelay<Movie>()
    let movieDidAddEvent = PublishRelay<Movie>()
  }
  
  struct Output {
    let movieList = BehaviorRelay<[Movie]>(value: [])
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: MyPageCoordinator?
  private let fetchMovieListInStorageUseCase: DefaultFetchMovieListInStorage
  private let deleteMovieUseCase: DeleteMovieUseCase
  private let disposeBag = DisposeBag()
  private var movieWillDelete: Movie?
  private var movieList = [Movie]()
  let input = Input()
  let output = Output()
  
  // MARK: - Life Cycle
  init(coordinator: MyPageCoordinator, fetchMovieListInStorageUseCase: DefaultFetchMovieListInStorage, deleteMovieUseCase: DeleteMovieUseCase) {
    self.coordinator = coordinator
    self.fetchMovieListInStorageUseCase = fetchMovieListInStorageUseCase
    self.deleteMovieUseCase = deleteMovieUseCase
    self.transform(input: self.input)
    NotificationCenter.default.addObserver(self, selector: #selector(handleAddMovieEvent(_:)), name: Notification.Name("addMovie"), object: nil)
  }
  
  
  // MARK: - Binding
  func transform(input: Input) {
    let movieList = BehaviorRelay<[Movie]>(value: [])
    let scrollToTop = PublishRelay<Void>()
    
    self.bindInput(input: input, movieList: movieList)
    self.bindOutput(output: output, movieList: movieList)
    self.fetchDatas(movieList: movieList, scrollToTop: scrollToTop)
  }
  
  private func bindInput(input: Input, movieList: BehaviorRelay<[Movie]>) {
    input.deleteButtonDidTapEvent
      .subscribe(onNext: { [weak self] idx in
        self?.movieWillDelete = self?.movieList[idx]
        self?.coordinator?.showLabelPopUp()
      })
      .disposed(by: self.disposeBag)
    
    input.movieDidTapEvent
      .subscribe(onNext: { [weak self] idx in
        self?.coordinator?.showMovieDetail(movie: movieList.value[idx])
      })
      .disposed(by: self.disposeBag)
    
    input.movieDidDeleteEvent
      .subscribe(onNext: { movie in
        let movieListWillUpdate = movieList.value
        let movieListUpdated = movieListWillUpdate.filter { $0.id != movie.id }
        movieList.accept(movieListUpdated)
      })
      .disposed(by: self.disposeBag)
    
    input.movieDidAddEvent
      .subscribe(onNext: { movie in
        let movieListUpdated = [movie] + movieList.value
        movieList.accept(movieListUpdated)
      })
      .disposed(by: self.disposeBag)

  }
  
  private func bindOutput(output: Output, movieList: BehaviorRelay<[Movie]>) {
    movieList
      .subscribe(onNext: { [weak self] movieListUpdated in
        self?.movieList = movieListUpdated
        output.movieList.accept(movieListUpdated)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func fetchDatas(movieList: BehaviorRelay<[Movie]>, scrollToTop: PublishRelay<Void>) {
    self.fetchMovieList(movieList: movieList, scrollToTop: scrollToTop)
  }
  
  private func fetchMovieList(movieList: BehaviorRelay<[Movie]>, scrollToTop: PublishRelay<Void>) {
    self.fetchMovieListInStorageUseCase.excute()
      .subscribe(onNext: { movieListFetched in
        movieList.accept(movieListFetched.reversed())
      })
      .disposed(by: self.disposeBag)
  }

  // List & Search 탭에서 영화가 추가될 때 실행
  @objc private func handleAddMovieEvent(_ notification: Notification) {
    let movie = notification.object as! Movie
    self.input.movieDidAddEvent.accept(movie)
  }
}

extension MyPageViewModel: LabelPopupDismissDelegate {
  func confirm() {
    guard let movie = self.movieWillDelete else { return }
    self.deleteMovieUseCase.excute(movie: movie)
    self.input.movieDidDeleteEvent.accept(movie)
  }
}
