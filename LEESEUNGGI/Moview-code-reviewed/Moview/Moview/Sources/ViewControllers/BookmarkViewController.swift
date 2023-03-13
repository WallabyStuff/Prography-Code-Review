//
//  BookmarkViewController.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import UIKit
import Then
import SnapKit

import RxSwift
import RxCocoa
import RxDataSources

class BookmarkViewController: UIViewController {
  
  // MARK: - Constants
  
  struct Metric {
    static let regularInset = 20.f
    static let compactInset = 12.f
    
    static let navigationViewHeight = 48.f
    static let navigationTitleFontSize = 20.f
    static let navigationTitleBottomInset = 12.f
    
    static let bookmarkMovieItemSpacing = 8.f
    
    static let collectionViewTopInset = 20.f
    static let collectionViewBottomInset = 100.f
  }
  
  // MARK: - Properties
  
  private var viewModel: BookmarkViewModel
  private var disposeBag = DisposeBag()
  private var bookmarkMovieCollectionViewLayout: UICollectionViewCompositionalLayout {
    let itemWidth = floor((view.frame.width - (Metric.compactInset * 2) - (Metric.bookmarkMovieItemSpacing * 2)) / 3)
    
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .absolute(itemWidth),
      heightDimension: .estimated(220))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(220))
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item])
    group.interItemSpacing = .flexible(Metric.bookmarkMovieItemSpacing)
    group.contentInsets = .init(
      top: 0,
      leading: Metric.compactInset,
      bottom: 0,
      trailing: Metric.compactInset)
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = Metric.bookmarkMovieItemSpacing
    section.boundarySupplementaryItems = [
      .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .absolute(Metric.bookmarkMovieItemSpacing)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)]
    
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
  
  private var dataSource: RxCollectionViewSectionedReloadDataSource<MovieDataSection> {
    return .init(configureCell: { dataSource, collectionView, indexPath, item in
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: MediumThumbnailMovieCollectionCell.identifier, for: indexPath)
              as? MediumThumbnailMovieCollectionCell else {
        return UICollectionViewCell()
      }
    
      cell.configure(movie: item, thumbnailImageViewHeroId: item.id)
      return cell
    })
  }
  
  
  // MARK: - UI
  
  let navigationView = NavigationView().then {
    $0.backgroundColor = .clear
  }
  let navigationTitleLabel = UILabel().then {
    $0.text = "Bookmarks"
    $0.textColor = R.color.textWhite()
    $0.font = UIFont.systemFont(ofSize: Metric.navigationTitleFontSize, weight: .heavy)
  }
  var collectionView: UICollectionView!
  let placeholderLabel = UILabel().then {
    $0.text = "There is no bookmark yet"
    $0.textColor = R.color.textGrayDarker()
  }
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    configure()
  }
  
  
  // MARK: - Initializers
  
  init(viewModel: BookmarkViewModel) {
    self.viewModel = viewModel
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
    setupNavigationView()
    setupBookmarkCollectionView()
    setupPlaceholderLabel()
  }
  
  private func setupNavigationView() {
    view.addSubview(navigationView)
    navigationView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(Metric.navigationViewHeight + SafeAreaGuide.top)
    }
    
    /// Navigation title
    navigationView.addSubview(navigationTitleLabel)
    navigationTitleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(Metric.regularInset)
      $0.bottom.equalToSuperview().inset(Metric.navigationTitleBottomInset)
    }
  }
  
  private func setupBookmarkCollectionView() {
    /// Registration
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: bookmarkMovieCollectionViewLayout)
    collectionView.register(MediumThumbnailMovieCollectionCell.self, forCellWithReuseIdentifier: MediumThumbnailMovieCollectionCell.identifier)
    
    /// Contratins
    view.insertSubview(collectionView, at: 0)
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    /// Insets
    collectionView.contentInset = .init(
      top: Metric.navigationViewHeight + Metric.collectionViewTopInset,
      bottom: Metric.collectionViewBottomInset)
    collectionView.scrollIndicatorInsets = .init(top: Metric.navigationViewHeight + Metric.collectionViewTopInset)
    
    /// Etc
    collectionView.delaysContentTouches = false
  }
  
  private func setupPlaceholderLabel() {
    view.addSubview(placeholderLabel)
    placeholderLabel.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
  }
  
  
  // MARK: - Configuration
  
  private func configure() {
    configureView()
  }
  
  private func configureView() {
    configureNavigationViewOpaqueThreshold()
  }
  
  private func configureNavigationViewOpaqueThreshold() {
    navigationView.configureScrollView(
      collectionView,
      threshold: Metric.navigationViewHeight + Metric.collectionViewTopInset + SafeAreaGuide.top)
  }
  
  
  // MARK: - Binds
  
  private func bind() {
    bindInputs()
    bindOutputs()
  }
  
  private func bindInputs() {
    self.rx.viewWillAppear
      .map { _ in }
      .bind(to: viewModel.input.viewWillAppear)
      .disposed(by: disposeBag)
    
    collectionView.rx.itemSelected
      .map { [weak self] indexPath in
        self?.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        return indexPath
      }
      .bind(to: viewModel.input.bookmarkMovieItemSelected)
      .disposed(by: disposeBag)
  }
  
  private func bindOutputs() {
    viewModel.output.bookmarkMovies
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    viewModel.output.bookmarkMovies
      .subscribe(with: self, onNext: { vc, bookmarkMovies in
        if bookmarkMovies.first?.items.isEmpty ?? false {
          vc.placeholderLabel.isHidden = false
          vc.collectionView.isHidden = true
        } else {
          vc.placeholderLabel.isHidden = true
          vc.collectionView.isHidden = false
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output.presentMovieDetail
      .subscribe(with: self, onNext: { vc, movie in
        vc.presentMovieDetailVC(movie: movie)
      })
      .disposed(by: disposeBag)
  }
  
  
  // MARK: - Methods
  
  private func presentMovieDetailVC(movie: Movie) {
    let viewModel = MovieDetailViewModel(movie: movie)
    let vc = MovieDetailViewController(
      viewModel: viewModel,
      thumbnailImageViewHeroId: movie.id)
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true)
  }
}

