//
//  MovieListViewController.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class MovieListViewController: UIViewController {
  // MARK: - Vars & Lets
  var viewModel: MovieListViewModel!
  private let disposeBag = DisposeBag()
  private let prefetchHeight: CGFloat = 600
  
  // MARK: - UI
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayout.listLayoutInList).then {
    $0.register(MovieCell.self, forCellWithReuseIdentifier: String(describing: MovieCell.description))
  }
  
  private let optionButton = UIButton().then {
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
    $0.layer.cornerRadius = 4
    $0.backgroundColor = .black
  }
  
  private let loadingView = UIActivityIndicatorView(style: .large)
  
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
    
    self.view.addSubview(self.optionButton)
    self.optionButton.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
      $0.right.equalToSuperview().inset(10)
      $0.width.equalTo(100)
      $0.height.equalTo(30)
    }
    
    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.top.equalTo(self.optionButton.snp.bottom).offset(20)
      $0.left.right.bottom.equalToSuperview()
    }
  }
  
  private func configureNavigation() {
    self.setBackButton()
    self.setNavigationTitle(title: "목록")
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
    
    self.optionButton.rx.tap
      .bind(to: input.optionButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.collectionView.rx.itemSelected.map { $0.row}
      .bind(to: input.movieDidTapEvent)
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput() {
    let input = self.viewModel.input
    let output = self.viewModel.output
    
    output.movieList
      .bind(to: self.collectionView.rx.items(cellIdentifier: MovieCell.description, cellType: MovieCell.self)) { row, movie, cell in
        cell.updateUI(movie: movie)
        cell.clickHeart()
          .subscribe(onNext: {
            input.movieHeartDidTapEvent.accept(row)
          })
          .disposed(by: cell.disposeBag)
      }
      .disposed(by: self.disposeBag)
    
    output.isLoading
      .asDriver()
      .drive(onNext: { isLoading in
        if isLoading { LoadingService.showLoading() }
        else { LoadingService.hideLoading() }
      })
      .disposed(by: self.disposeBag)
    
    output.option
      .asDriver()
      .drive(onNext: { [weak self] idx in
        self?.updateOption(idx: idx)
      })
      .disposed(by: self.disposeBag)
    
    output.scrollToTop
      .asDriver(onErrorJustReturn: ())
      .drive(onNext: { [weak self] in
        self?.collectionView.setContentOffset(.zero, animated: false)
      })
      .disposed(by: self.disposeBag)
    
  }
  
  private func updateOption(idx: Int) {
    self.optionButton.setTitle(Option.allCases[idx].description, for: .normal)
  }
 
}

extension MovieListViewController: UIScrollViewDelegate, UICollectionViewDelegate {
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
