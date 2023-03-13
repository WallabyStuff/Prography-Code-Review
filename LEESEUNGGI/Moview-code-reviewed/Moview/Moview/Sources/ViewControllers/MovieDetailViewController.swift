//
//  MovieDetailViewController.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import UIKit
import Then
import SnapKit

import RxSwift
import RxCocoa

import Hero

class MovieDetailViewController: UIViewController {
  
  // MARK: - Constants
  
  struct Metric {
    static let regularInset = 20.f
    static let compactInset = 12.f
    
    static let navigationViewHeight = 48.f
    
    static let closeButtonSize = 32.f
    static let closeButtonImageInset = 6.f
    static let closeButtonShadowRadius = 2.f
    static let closeButtonShadowOpacity: Float = 0.3
    static let closeButtonBottomMargin = 8.f
    
    static let titleLabelFontSize = 24.f
    static let titleLabelMaxLine = 3
    static let titleLabelTopMargin = 28.f
    static let titleLabelRightMargin = -8.f
    
    static let bookmarkButtonSize = 32.f
    
    static let genreChipCollectionViewTopMargin = 16.f
    static let genreChipCollectionViewVerticalInset = 4.f
    static let genreChipCollectionViewEstimatedSize = CGSize(width: 60, height: 26)
    
    static let movieInfoStackViewTopMargin = 24.f
    static let movieInfoStackViewHeight = 84.f
    
    static let summaryHeaderLabelFontSize = 17.f
    static let summaryHeaderLabelTopMargin = 40.f
    
    static let summaryLabelTopMargin = 8.f
    static let summaryLabelBottomMargin = 100.f
    
    /// Dismiss view controller when scrollView is pulled down over 22% area of view
    static let pullDownToDismissThresholdRatio = 0.22.f
    
    static let thumbnailImageEmptyStateImageSize = 44.f
  }
  
  
  // MARK: - Properties
  
  private var viewModel: MovieDetailViewModel
  private var disposeBag = DisposeBag()
  private var genreCollectionViewLayout: UICollectionViewFlowLayout {
    let layout = GenreCollectionFlowLayout()
    layout.estimatedItemSize = Metric.genreChipCollectionViewEstimatedSize
    return layout
  }
  private var thumbnailImageViewTopConstraint: Constraint!
  
  
  // MARK: - UI
  
  let navigationView = NavigationView()
  let closeButton = UIButton().then {
    $0.setImage(R.image.close(), for: .normal)
    $0.tintColor = R.color.iconWhite()
    $0.imageEdgeInsets = .init(common: Metric.closeButtonImageInset)
    $0.layer.shadowColor = UIColor.black.cgColor
    $0.layer.shadowOffset = .zero
    $0.layer.shadowRadius = Metric.closeButtonShadowRadius
    $0.layer.shadowOpacity = Metric.closeButtonShadowOpacity
    $0.alpha = 0
  }
  let scrollView = UIScrollView()
  let scrollContentView = UIView()
  let thumbnailImageContainerView = UIView().then {
    $0.backgroundColor = R.color.backgroundBlackLight()
  }
  let thumbnailImageView = ThumbnailImageView(emptyStateImageSize: Metric.thumbnailImageEmptyStateImageSize).then {
    $0.backgroundColor = R.color.backgroundBlackLight()
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  let titleLabel = UILabel().then {
    $0.textColor = R.color.textWhite()
    $0.numberOfLines = Metric.titleLabelMaxLine
    $0.font = UIFont.systemFont(ofSize: Metric.titleLabelFontSize, weight: .heavy)
  }
  let bookmarkButton = BookmarkButton(isBookmarked: false)
  var genreChipCollectionView: DynamicHeightCollectionView!
  let movieInfoStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
  }
  let runtimeInfoItem = MovieInfoStackViewItem()
  let likesInfoItem = MovieInfoStackViewItem()
  let ratingsInfoItem = MovieInfoStackViewItem()
  let summaryHeaderLabel = UILabel().then {
    $0.text = "Plot Summary"
    $0.textColor = R.color.textWhite()
    $0.font = UIFont.systemFont(ofSize: Metric.summaryHeaderLabelFontSize, weight: .bold)
  }
  let summaryLabel = UILabel().then {
    $0.textColor = R.color.textGray()
    $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .medium)
    $0.numberOfLines = 0
  }
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    /// ThumbnailImageView hero transition overlays the close button temporarily so this close button fade in animation is needed to make better animation looks
    showCloseButton()
  }
  
  
  // MARK: - Initializers
  
  init(viewModel: MovieDetailViewModel, thumbnailImageViewHeroId: String) {
    self.viewModel = viewModel
    self.thumbnailImageView.configureHero(id: thumbnailImageViewHeroId)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    setupView()
    bind()
  }
  
  private func setupView() {
    setupHero()
    setupBackground()
    setupScrollView()
    setupThumbnailImageContainerView()
    setupThumbnailImageView()
    setupBookmarkButton()
    setupTitleLabel()
    setupGenreChipCollectionView()
    setupMovieInfoStackView()
    setupSummaryHeaderLabel()
    setupSummaryLabel()
    setupNavigationView()
  }
  
  private func setupHero() {
    isHeroEnabled = true
  }
  
  private func setupBackground() {
    view.backgroundColor = R.color.backgroundBlack()
  }
  
  private func setupScrollView() {
    view.insertSubview(scrollView, at: 0)
    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    scrollView.contentInsetAdjustmentBehavior = .never
    
    /// ContentView
    scrollView.addSubview(scrollContentView)
    scrollContentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalToSuperview()
      $0.height.greaterThanOrEqualTo(scrollView.snp.height).priority(.low)
    }
  }
  
  private func setupThumbnailImageContainerView() {
    scrollContentView.addSubview(thumbnailImageContainerView)
    thumbnailImageContainerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(thumbnailImageContainerView.snp.width).multipliedBy(1.5)
    }
  }
  
  private func setupThumbnailImageView() {
    scrollView.addSubview(thumbnailImageView)
    thumbnailImageView.snp.makeConstraints {
      thumbnailImageViewTopConstraint = $0.top.equalTo(view).constraint
      $0.width.equalTo(thumbnailImageContainerView)
      $0.bottom.equalTo(thumbnailImageContainerView)
    }
  }

  private func setupBookmarkButton() {
    scrollContentView.addSubview(bookmarkButton)
    bookmarkButton.snp.makeConstraints {
      $0.top.equalTo(thumbnailImageContainerView.snp.bottom).offset(Metric.titleLabelTopMargin)
      $0.trailing.equalToSuperview().inset(Metric.regularInset)
      $0.width.height.equalTo(Metric.bookmarkButtonSize)
    }
  }
  
  private func setupTitleLabel() {
    scrollContentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(thumbnailImageContainerView.snp.bottom).offset(Metric.titleLabelTopMargin)
      $0.leading.equalToSuperview().inset(Metric.regularInset)
      $0.trailing.equalTo(bookmarkButton.snp.leading).offset(Metric.titleLabelRightMargin)
    }
  }
  
  private func setupGenreChipCollectionView() {
    genreChipCollectionView = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: genreCollectionViewLayout)
    genreChipCollectionView.register(GenreChipCollectionCell.self, forCellWithReuseIdentifier: GenreChipCollectionCell.identifier)
    
    scrollContentView.addSubview(genreChipCollectionView)
    genreChipCollectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(Metric.genreChipCollectionViewTopMargin)
      $0.leading.trailing.equalToSuperview().inset(Metric.regularInset)
    }
    genreChipCollectionView.backgroundColor = .clear
  }
  
  private func setupMovieInfoStackView() {
    scrollContentView.addSubview(movieInfoStackView)
    movieInfoStackView.snp.makeConstraints {
      $0.top.equalTo(genreChipCollectionView.snp.bottom).offset(Metric.movieInfoStackViewTopMargin)
      $0.leading.trailing.equalToSuperview().inset(Metric.regularInset)
      $0.height.equalTo(Metric.movieInfoStackViewHeight)
    }
    
    /// Info items
    movieInfoStackView.addArrangedSubview(runtimeInfoItem)
    movieInfoStackView.addArrangedSubview(likesInfoItem)
    movieInfoStackView.addArrangedSubview(ratingsInfoItem)
  }
  
  private func setupSummaryHeaderLabel() {
    scrollContentView.addSubview(summaryHeaderLabel)
    summaryHeaderLabel.snp.makeConstraints {
      $0.top.equalTo(movieInfoStackView.snp.bottom).offset(Metric.summaryHeaderLabelTopMargin)
      $0.leading.trailing.equalToSuperview().inset(Metric.regularInset)
    }
  }
  
  private func setupSummaryLabel() {
    scrollContentView.addSubview(summaryLabel)
    summaryLabel.snp.makeConstraints {
      $0.top.equalTo(summaryHeaderLabel.snp.bottom).offset(Metric.summaryLabelTopMargin)
      $0.leading.trailing.equalToSuperview().inset(Metric.regularInset)
      $0.bottom.equalToSuperview().inset(Metric.summaryLabelBottomMargin)
    }
  }
  
  private func setupNavigationView() {
    view.addSubview(navigationView)
    navigationView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(Metric.navigationViewHeight + SafeAreaGuide.top)
    }
    
    /// Configure navigation opaque threshol
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.navigationView.configureScrollView(
        self.scrollView,
        threshold: -self.view.frame.width * 1.5 + Metric.navigationViewHeight + SafeAreaGuide.top)
    }
    
    /// Navigation Item
    navigationView.addSubview(closeButton)
    closeButton.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(Metric.compactInset)
      $0.width.height.equalTo(Metric.closeButtonSize)
      $0.bottom.equalToSuperview().inset(Metric.closeButtonBottomMargin)
    }
  }
  
  
  // MARK: - Binds
  
  private func bind() {
    bindInputs()
    bindOutputs()
    bindThumbnailImageView()
    bindPullDownToDismiss()
  }
  
  private func bindInputs() {
    Observable.just(Void())
      .bind(to: viewModel.input.viewDidLoad)
      .disposed(by: disposeBag)
    
    closeButton.rx.tap
      .asDriver()
      .drive(with: self, onNext: { vc, _ in
        vc.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
    
    bookmarkButton.rx.tap
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .map { self.bookmarkButton.isBookmarked }
      .bind(to: viewModel.input.didTapBookmarkButton)
      .disposed(by: disposeBag)
  }
  
  private func bindOutputs() {
    viewModel.output.currentMovie
      .asDriver(onErrorDriveWith: .empty())
      .drive(with: self, onNext: { vc, movie in
        /// Title
        vc.titleLabel.text = movie.title
        
        /// Movie infos
        vc.runtimeInfoItem.configure(
          icon: R.image.clock(),
          title: "Runtime",
          description: movie.runtime.description)
        /// 사이트에는 좋아요 수가 있길래 API에도 당연히 있는 줄 알고 착각했음..🥹 그래서 랜덤 숫자ㅎ
        vc.likesInfoItem.configure(
          icon: R.image.heart(),
          title: "Likes",
          description: Array(0...10000).randomElement()?.description ?? "0")
        vc.ratingsInfoItem.configure(
          icon: R.image.starFilled(),
          title: "Ratings",
          description: movie.rating.description,
          tintColor: R.color.accentYellow())
        
        /// Thumbnail image
        let url = URL(string: movie.large_cover_image)
        vc.thumbnailImageView.kf.setImage(with: url, options: [.transition(.fade(0.3))])
        
        /// Summary
        vc.summaryLabel.text = movie.description_full
      })
      .disposed(by: disposeBag)
    
    viewModel.output.currentMovie
      .map { $0.genres }
      .bind(to: genreChipCollectionView.rx.items(cellIdentifier: GenreChipCollectionCell.identifier, cellType: GenreChipCollectionCell.self)) { index, genreTitle, cell in
        cell.configure(genreTitle: genreTitle)
      }
      .disposed(by: disposeBag)
    
    viewModel.output.bookmarkState
      .asDriver()
      .drive(with: self, onNext: { vc, isBookmarked in
        vc.bookmarkButton.isBookmarked = isBookmarked
      })
      .disposed(by: disposeBag)
  }
  
  /// This function is needed to prevent the thumbnailImageView from shrinking when the scroll view is scrolled up
  private func bindThumbnailImageView() {
    scrollView.rx.contentOffset
      .asDriver()
      .drive(with: self, onNext: { vc, offset in
        if offset.y > 0 {
          vc.thumbnailImageViewTopConstraint.update(inset: -offset.y)
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func bindPullDownToDismiss() {
    scrollView.rx.contentOffset
      .asDriver()
      .drive(with: self, onNext: { vc, offset in
        if offset.y > 0 { return }
        let dismissThreshold = vc.view.frame.height * Metric.pullDownToDismissThresholdRatio
        
        if abs(offset.y) > dismissThreshold {
          vc.dismiss(animated: true)
        }
      })
      .disposed(by: disposeBag)
  }
  
  
  // MARK: - Methods
  
  private func showCloseButton() {
    UIView.animate(withDuration: 0.3, delay: 0, animations: {
      self.closeButton.alpha = 1.0
    })
  }
}
