//
//  MovieSearchViewModel.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import RxSwift
import RxRelay

final class MovieSearchViewModel {
  
  // MARK: - Input & Output
  
  /// `searchWordDidEditEvent` : 검색어를 입력할 때, `String` : 검색어
  /// `searchButtonDidTapEvent` : 검색버튼을 클릭할 때
  /// `heartButtonDidTapEvent` : 영화 Cell의 하트버튼을 누를 때, `Int` : 옵션의 row
  /// `loadMoreEvent` : 스크롤 내릴 때 새로운 영화리스트를 불러올때
  /// `movieDidTapEvent` : 영화 Cell 클릭할 때, `Int` : 옵션의 row
  struct Input {
    let searchWordDidEditEvent = PublishRelay<String>()
    let searchButtonDidTapEvent = PublishRelay<Void>()
    let heartButtonDidTapEvent = PublishRelay<Int>()
    let loadMoreEvent = PublishRelay<Void>()
    let movieDidTapEvent = PublishRelay<Int>()
  }
  
  /// `movieList`: collection 뷰에 들어갈 영화 리스트
  /// `isLoading` : 로딩창을 띄우기 위해 구현.
  /// `scrollToTop` : 첫번째 페이지 Fetch인 경우 스크롤을 top으로 보내주기 위해 구현.
  struct Output {
    let movieList = BehaviorRelay<[Movie]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let scrollToTop = PublishRelay<Void>()
  }
  
  /// `isLoading`: 동시에 여러 번 통신하는 것을 막기 위함.
  /// `page`: Fetch 해야할 페이지
  /// `limit`: 한번에 불러올 영화 리스트 수
  // MARK: - Vars & Lets
  private weak var coordinator: SearchCoordinator!
  private let fetchMovieListUseCase: FetchMovieListUseCase
  private let addMovieUseCase: AddMovieUseCase
  private let disposeBag = DisposeBag()
  private var movieWillSave: Movie?
  private var editSearchWord = ""
  private var searchWord = ""
  private var isLoading = false
  private var canLoadMore = true
  private var page = 1
  private var limit = 20
  let input = Input()
  let output = Output()
  
  // MARK: - Life Cycle
  init(coordinator: SearchCoordinator, fetchMovieListUseCase: FetchMovieListUseCase, addMovieUseCase: AddMovieUseCase) {
    self.coordinator = coordinator
    self.fetchMovieListUseCase = fetchMovieListUseCase
    self.addMovieUseCase = addMovieUseCase
    self.transform(input: self.input)
  }
  
  // MARK: - Binding
  func transform(input: Input) {
    let movieList = BehaviorRelay<[Movie]>(value: [])
    let isLoading = PublishRelay<Bool>()
    let scrollToTop = PublishRelay<Void>()
    
    self.bindInput(input: input, movieList: movieList, isLoading: isLoading, scrollToTop: scrollToTop)
    self.bindOutput(output: output, movieList: movieList, isLoading: isLoading, scrollToTop: scrollToTop)
  }
  
  private func bindInput(input: Input, movieList: BehaviorRelay<[Movie]>, isLoading: PublishRelay<Bool>, scrollToTop: PublishRelay<Void>) {
    input.searchWordDidEditEvent
      .subscribe(onNext: { [weak self] text in
        self?.editSearchWord = text
      })
      .disposed(by: self.disposeBag)
    
    input.searchButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.searchWord = self?.editSearchWord ?? ""
        self?.page = 1
        self?.canLoadMore = true
        self?.fetchMovieList(movieList: movieList, isLoading: isLoading, scrollToTop: scrollToTop)
      })
      .disposed(by: self.disposeBag)
    
    input.heartButtonDidTapEvent
      .subscribe(onNext: { [weak self] idx in
        self?.movieWillSave = movieList.value[idx]
        self?.coordinator.showLabelPopUp()
      })
      .disposed(by: self.disposeBag)

    input.loadMoreEvent
      .subscribe(onNext: { [weak self] in
        self?.fetchMovieList(movieList: movieList, isLoading: isLoading, scrollToTop: scrollToTop)
      })
      .disposed(by: self.disposeBag)
    
    input.movieDidTapEvent
      .subscribe(onNext: { [weak self] idx in
        self?.coordinator.showMovieDetail(movie: movieList.value[idx])
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput(output: Output, movieList: BehaviorRelay<[Movie]>, isLoading: PublishRelay<Bool>, scrollToTop: PublishRelay<Void>) {
    movieList
      .bind(to: output.movieList)
      .disposed(by: self.disposeBag)
    
    isLoading
      .bind(to: output.isLoading)
      .disposed(by: self.disposeBag)
    
    scrollToTop
      .bind(to: output.scrollToTop)
      .disposed(by: self.disposeBag)
  }
  
  private func fetchMovieList(movieList: BehaviorRelay<[Movie]>, isLoading: PublishRelay<Bool>, scrollToTop: PublishRelay<Void>) {
    
    if self.isLoading || !self.canLoadMore || self.searchWord.count < 2 { return }
    
    self.isLoading = true
    isLoading.accept(true)
    self.fetchMovieListUseCase.excute(limit: self.limit, page: self.page, searchWord: self.searchWord, sort: nil, order: nil)
      .subscribe(onNext: { [weak self] movieListFetched in
        self?.handleMovieListIfSuccess(movieList: movieList, movieListFetched: movieListFetched, isLoading: isLoading, scrollToTop: scrollToTop)
      }, onError: { [weak self] error in
        self?.handleMovieListIfFailure(movieList: movieList, isLoading: isLoading)
      })
      .disposed(by: self.disposeBag)
  }
  
  /// `page == 1`
  ///  1. 처음 첫 검색일 경우
  ///  2. 기존 검색 중에 새로운 SearchWord로 검색하였을 때 기존 movieList 초기화를 위해
  private func handleMovieListIfSuccess(movieList: BehaviorRelay<[Movie]>, movieListFetched: [Movie], isLoading: PublishRelay<Bool>, scrollToTop: PublishRelay<Void>) {
    if self.page == 1 {
      scrollToTop.accept(())
    }
    let original = self.page == 1 ? [] : movieList.value
    movieList.accept(original + movieListFetched)
    self.page += 1
    self.initialLoading(isLoading: isLoading)
  }
  
  /// 네트워크 오류 뿐만 아니라 빈 리스트(결과가 없거나 더 이상 불러온 MovieList가 없을때) 일 경우 처리
  /// `page == 1` - 아예 불러올 MovieList가 없는 경우 이전 검색 MovieList를 제거
  /// `page > 1` - 기존 검색어가 있고 더 이상 부를 MovieList가 없을 때
  private func handleMovieListIfFailure(movieList: BehaviorRelay<[Movie]>, isLoading: PublishRelay<Bool>) {
    self.canLoadMore = false
    self.initialLoading(isLoading: isLoading)
    if page == 1 {
      movieList.accept([])
    }
  }
  
  private func initialLoading(isLoading: PublishRelay<Bool>) {
    self.isLoading = false
    isLoading.accept(false)
  }
}

extension MovieSearchViewModel: LabelPopupDismissDelegate {
  func confirm() {
    guard let movie = self.movieWillSave else { return }
    self.addMovieUseCase.excute(movie: movie)
    NotificationCenter.default.post(name: Notification.Name("addMovie"), object: movie)
  }
}

