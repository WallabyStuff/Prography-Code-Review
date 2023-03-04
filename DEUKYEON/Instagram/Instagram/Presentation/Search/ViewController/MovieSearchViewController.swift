//
//  MovieSearchViewController.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class MovieSearchViewController: UIViewController {

  var viewModel: MovieSearchViewModel!
  private let disposeBag = DisposeBag()
  private let prefetchHeight: CGFloat = 600

  // MARK: - UI
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayout.listLayoutInSearch).then {
    $0.register(MovieListCell.self, forCellWithReuseIdentifier: String(describing: MovieListCell.description))
  }
  
  private let loadingView = UIActivityIndicatorView(style: .large)
  private let searchTextField = InputField().then { $0.setPlaceholder(string: "두 글자 이상 검색어를 입력해주세요") }
  private let searchButton = UIButton().then { $0.setImage(UIImage(named: "searchActive"), for: .normal)}
  private let stateLabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 25, weight: .bold)
    $0.text = "검색 결과가 없습니다."
    $0.textColor = .black
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.configureDelegate()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  // MARK: - Configure UI
  private func configureUI() {
    self.configureNavigation()
    self.view.backgroundColor = .white
    
    self.view.addSubview(self.loadingView)
    self.loadingView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.view.addSubview(self.searchTextField)
    self.view.addSubview(self.searchButton)
    self.searchTextField.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
      $0.right.equalTo(self.searchButton.snp.left).offset(-10)
      $0.left.equalToSuperview().offset(10)
    }
    
    self.view.addSubview(self.searchButton)
    self.searchButton.snp.makeConstraints {
      $0.centerY.equalTo(self.searchTextField)
      $0.right.equalToSuperview().offset(-10)
    }
    
    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.top.equalTo(self.searchTextField.snp.bottom).offset(20)
      $0.left.right.bottom.equalToSuperview()
    }
    
    self.view.addSubview(self.stateLabel)
    self.stateLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
  
  private func configureNavigation() {
    self.setBackButton()
    self.setNavigationTitle(title: "검색")
  }
  
  private func configureDelegate() {
    self.collectionView.delegate = self
  }
  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    self.bindInput()
    self.bindOutput()
  }
  
  private func bindInput() {
    let input = self.viewModel.input
    
    self.searchTextField.rx.text.orEmpty
      .bind(to: input.searchWordDidEditEvent)
      .disposed(by: self.disposeBag)
    
    self.searchButton.rx.tap
      .bind(to: input.searchButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.collectionView.rx.itemSelected.map { $0.item }
      .bind(to: input.movieDidTapEvent)
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput() {
    let input = self.viewModel.input
    let output = self.viewModel.output
    
    output.movieList
      .bind(to: self.collectionView.rx.items(cellIdentifier: MovieListCell.description, cellType: MovieListCell.self)) { row, movie, cell in
        cell.updateUI(movie: movie, canDelete: false)
        cell.clickOption()
          .subscribe(onNext: {
            input.heartButtonDidTapEvent.accept(row)
          })
          .disposed(by: cell.disposeBag)
      }
      .disposed(by: self.disposeBag)
    
    output.movieList
      .subscribe(onNext: { [weak self] movieList in
        self?.stateLabel.isHidden = movieList.count > 0
      })
      .disposed(by: self.disposeBag)
    
    output.isLoading
      .asDriver()
      .drive(onNext: { isLoading in
        if isLoading { LoadingService.showLoading() }
        else { LoadingService.hideLoading() }
      })
      .disposed(by: self.disposeBag)
    
    output.scrollToTop
      .asDriver(onErrorJustReturn: ())
      .drive(onNext: { [weak self] in
        self?.collectionView.setContentOffset(.zero, animated: false)
      })
      .disposed(by: self.disposeBag)
  }
}

extension MovieSearchViewController: UIScrollViewDelegate, UICollectionViewDelegate {
  
  /// 스크롤이 최하단으로 부터  `prefetchHeight`만큼 떨어져있는 경우 다음 page를 Fetch (무한 스크롤)
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == self.collectionView {

      let input = self.viewModel.input
      let offsetY = scrollView.contentOffset.y
      let contentHeight = scrollView.contentSize.height
      let height = scrollView.frame.height
      if height + self.prefetchHeight > contentHeight - offsetY {
        input.loadMoreEvent.accept(())
      }
    }
  }
}
