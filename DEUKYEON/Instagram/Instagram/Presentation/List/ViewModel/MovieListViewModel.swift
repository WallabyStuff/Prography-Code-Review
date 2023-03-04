//
//  MovieListViewModel.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import RxSwift
import RxRelay

final class MovieListViewModel {
  
  // MARK: - Input & Output
  
  /// `optionButtonDidTapEvent` : 옵션 버튼을 누를 때
  /// `optionDidUpdateEvent` : 옵션이 업데이트 됐을 때, `Int` : 옵션의 row
  /// `movieDidTapEvent` : 영화 Cell 클릭할 때, `Int` : 영화의 row
  /// `movieHeartDidTapEvent` : 영화 Cell의 하트버튼을 누를 때, `Int` : 영화의 row
  /// `loadMoreEvent` : 스크롤 내릴 때 새로운 영화리스트를 불러올때
  struct Input {
    let optionButtonDidTapEvent = PublishRelay<Void>()
    let optionDidUpdateEvent = PublishRelay<Int>()
    let movieDidTapEvent = PublishRelay<Int>()
    let movieHeartDidTapEvent = PublishRelay<Int>()
    let loadMoreEvent = PublishRelay<Void>()
  }
  
  struct Output {
    let option = BehaviorRelay<Int>(value: 0)
    let movieList = BehaviorRelay<[Movie]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let scrollToTop = PublishRelay<Void>()
  }
  
  /// `isLoading`: 동시에 여러 번 통신하는 것을 막기 위함.
  /// `page`: Fetch 해야할 페이지
  /// `limit`: 한번에 불러올 영화 리스트 수
  // MARK: - Vars & Lets
  private weak var coordinator: ListCoordinator!
  private let fetchMovieListUseCase: FetchMovieListUseCase
  private let addMovieUseCase: AddMovieUseCase
  private let disposeBag = DisposeBag()
  private var movieWillSave: Movie?
  private var isLoading = false
  private var page = 1
  private var limit = 15
  let input = Input()
  let output = Output()
  var movies = [Movie]()
  
  // MARK: - Life Cycle
  init(coordinator: ListCoordinator,
       fetchMovieListUseCase: FetchMovieListUseCase,
       addMovieUseCase: AddMovieUseCase) {
    self.coordinator = coordinator
    self.fetchMovieListUseCase = fetchMovieListUseCase
    self.addMovieUseCase = addMovieUseCase
    self.transform(input: self.input)
  }
  
  
  // MARK: - Binding
  func transform(input: Input) {
    // Input, Output, FetchDatas를 연결해주는 변수
    let movieList = BehaviorRelay<[Movie]>(value: [])
    let isLoading = PublishRelay<Bool>()
    let option = BehaviorRelay<Int>(value: 0)
    let scrollToTop = PublishRelay<Void>()
    
    self.bindInput(input: input, movieList: movieList, isLoading: isLoading, option: option, scrollToTop: scrollToTop)
    self.bindOutput(output: output, movieList: movieList, isLoading: isLoading, option: option, scrollToTop: scrollToTop)
    self.fetchDatas(movieList: movieList, isLoading: isLoading, option: option, scrollToTop: scrollToTop)
  }
  
  private func bindInput(input: Input, movieList: BehaviorRelay<[Movie]>, isLoading: PublishRelay<Bool>, option: BehaviorRelay<Int>, scrollToTop: PublishRelay<Void>) {
    input.optionButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.showOptionPopUp(with: option.value)
      })
      .disposed(by: self.disposeBag)
    
    input.optionDidUpdateEvent
      .subscribe(onNext: { [weak self] idx in
        option.accept(idx)
        // 옵션 선택시 무조건 첫 번째 페이지부터 Fetch이기 때문
        self?.page = 1
        self?.fetchMovieList(movieList: movieList, isLoading: isLoading, option: option, scrollToTop: scrollToTop)
      })
      .disposed(by: self.disposeBag)
    
    input.movieDidTapEvent
      .subscribe(onNext: { [weak self] idx in
        self?.coordinator.showMovieDetail(movie: movieList.value[idx])
      })
      .disposed(by: self.disposeBag)
    
    input.movieHeartDidTapEvent
      .subscribe(onNext: { [weak self] idx in
        self?.movieWillSave = movieList.value[idx]
        self?.coordinator.showLabelPopUp()
      })
      .disposed(by: self.disposeBag)
    
    input.loadMoreEvent
      .subscribe(onNext: { [weak self] in
        self?.fetchMovieList(movieList: movieList, isLoading: isLoading, option: option, scrollToTop: scrollToTop)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput(output: Output, movieList: BehaviorRelay<[Movie]>, isLoading: PublishRelay<Bool>, option: BehaviorRelay<Int>, scrollToTop: PublishRelay<Void>) {
    movieList
      .subscribe(onNext: { [weak self] movies in
        self?.movies = movies
        output.movieList.accept(movies)
      })
      .disposed(by: self.disposeBag)
    
    isLoading
      .bind(to: output.isLoading)
      .disposed(by: self.disposeBag)
    
    option
      .bind(to: output.option)
      .disposed(by: self.disposeBag)
    
    scrollToTop
      .bind(to: output.scrollToTop)
      .disposed(by: self.disposeBag)
  }
  
  private func fetchDatas(movieList: BehaviorRelay<[Movie]>, isLoading: PublishRelay<Bool>, option: BehaviorRelay<Int>, scrollToTop: PublishRelay<Void>) {
    self.fetchMovieList(movieList: movieList, isLoading: isLoading, option: option, scrollToTop: scrollToTop)
  }
  
  /// `isLoading: Bool` : 스크롤시 동시에 많은 함수 Call이 발생하는데 하나만 통과하게 끔 구현.
  /// `isLoading: PublishRelay<Bool>` : 로딩창을 띄우기 위해 구현.
  /// `option: BehaviorRelay<Int>`: 옵션 팝업에서 선택된 옵션
  /// `scrollToTop: PublishRelay<Void>` : 첫번째 페이지 Fetch인 경우 스크롤을 top으로 보내주기 위해 구현.
  private func fetchMovieList(movieList: BehaviorRelay<[Movie]>, isLoading: PublishRelay<Bool>, option: BehaviorRelay<Int>, scrollToTop: PublishRelay<Void>) {
    if self.isLoading { return }
    self.isLoading = true
    isLoading.accept(true)
    self.fetchMovieListUseCase.excute(limit: self.limit, page: self.page, searchWord: nil, sort: Option.allCases[option.value].sort, order: Option.allCases[option.value].order )
      .subscribe(onNext: { [weak self] movieListFetched in
        self?.handleMovieListIfSuccess(movieList: movieList, movieListFetched: movieListFetched, isLoading: isLoading, scrollToTop: scrollToTop)
      }, onError: { [weak self] error in
        print(error)
        self?.handleMovieListIfFailure(movieList: movieList, isLoading: isLoading)
      })
      .disposed(by: self.disposeBag)
  }
  
  /// `page == 1`
  ///  1. 처음 첫 검색일 경우
  ///  2. 필터를 바꾼 경우
  private func handleMovieListIfSuccess(movieList: BehaviorRelay<[Movie]>, movieListFetched: [Movie], isLoading: PublishRelay<Bool>, scrollToTop: PublishRelay<Void>) {
    if self.page == 1 {
      scrollToTop.accept(())
    }
    let original = self.page == 1 ? [] : movieList.value
    movieList.accept(original + movieListFetched)
    self.page += 1
    self.initialLoading(isLoading: isLoading)
  }
  
  // 더이상 부를 리스트가 없으면 오류처리돼서 오기때문에 그에 대한 핸들링
  private func handleMovieListIfFailure(movieList: BehaviorRelay<[Movie]>, isLoading: PublishRelay<Bool>) {
    self.initialLoading(isLoading: isLoading)
  }
  
  private func initialLoading(isLoading: PublishRelay<Bool>) {
    self.isLoading = false
    isLoading.accept(false)
  }
}

// 옵션 팝업에서 Picker를 통해 선택 후 확인를 누를 시에 옵션 적용
extension MovieListViewModel: OptionPopupDismissDelegate {
  func confirm(option: Int) {
    self.input.optionDidUpdateEvent.accept(option)
  }
}

// 보관함 추가 팝업에서 저장을 누를 시에 Realm에 저장과 동시에 NotificationCenter을 이용한 보관함 페이지의 리스트 업데이트
extension MovieListViewModel: LabelPopupDismissDelegate {
  func confirm() {
    guard let movie = self.movieWillSave else { return }
    self.addMovieUseCase.excute(movie: movie)
    NotificationCenter.default.post(name: Notification.Name("addMovie"), object: movie)
  }
}
