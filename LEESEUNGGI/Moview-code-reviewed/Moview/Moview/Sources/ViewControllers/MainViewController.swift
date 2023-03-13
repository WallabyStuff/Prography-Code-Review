//
//  ViewController.swift
//  Moview
//
//  Created by Wallaby on 2023/02/04.
//

import UIKit
import Then
import SnapKit

import RxSwift
import RxCocoa
import RxDataSources

import RealmSwift

class MainViewController: UIViewController {
  
  // MARK: - Constants
  
  struct Metric {
    static let regularInset = 20.f
    static let compactInset = 12.f
    
    static let navigationViewHeight = 48.f
    static let navigationTitleFontSize = 20.f
    static let navigationTitleBottomInset = 12.f
    
    static let searchButtonSize = 32.f
    static let searchButtonImageInset = 6.f
    static let searchButtonBottomInset = 8.f
    
    static let collectionViewBottomInset = 100.f
    
    static let newMovieCollectionViewVerticalInset = 12.f
    static let newMovieItemSpacing = 12.f
    static let newMovieTotalItemInset = 96.f
    
    static let recommendedMovieItemSpacing = 8.f
    static let recommendedMovieGroupSpacing = 12.f
    static let recommendedMovieTopInset = 20.f
    static let recommendedMovieSectionHeaderHeight = 52.f
  }
  
  
  // MARK: - Properties
  
  private var viewModel: MainViewModel
  private var disposeBag = DisposeBag()
  
  private var newMovieItemWidth: CGFloat {
    return view.frame.width - Metric.newMovieTotalItemInset
  }
  
  private var newMovieItemHeight: CGFloat {
    return newMovieItemWidth * 1.5
  }
  
  private var collectionViewLayout: UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
      guard let self = self else { return nil }
      
      if sectionNumber == 0 {
        return self.newMovieLayoutSection
      } else {
        return self.recommendedMovieLayoutSection
      }
    }
  }
  
  private var newMovieCurrentIndex = -1
  private var newMovieLayoutSection: NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(newMovieItemHeight))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.8),
      heightDimension: .fractionalWidth(1.2))
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item])
    group.interItemSpacing = .fixed(Metric.newMovieItemSpacing)
    group.contentInsets = .init(top: 0, leading: Metric.newMovieItemSpacing, bottom: 0, trailing: Metric.newMovieItemSpacing)
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPagingCentered
    section.visibleItemsInvalidationHandler = { [weak self] (items, offset, env) -> Void in
      guard let self = self else { return }
      
      let page = Int(round(offset.x / (self.view.bounds.width - Metric.newMovieTotalItemInset)))
      
      if page < self.viewModel.output.movieList.value[0].items.count && page >= 0 {
        if self.newMovieCurrentIndex != page  {
          let movie = self.viewModel.output.movieList.value[0].items[page]
          
          /// Skip the process on isLoading state
          if movie.large_cover_image.isEmpty {
            return
          } else {
            self.dimmingBlurView.setImage(movie.large_cover_image)
            self.newMovieCurrentIndex = page
          }
        }
      }
    }
    return section
  }
  
  private var recommendedMovieLayoutSection: NSCollectionLayoutSection {
    let itemWidth = floor((view.frame.width - (Metric.compactInset * 2) - (Metric.recommendedMovieItemSpacing * 2)) / 3)
    
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
    group.interItemSpacing = .flexible(Metric.recommendedMovieItemSpacing)
    group.contentInsets = .init(
      top: 0,
      leading: Metric.compactInset,
      bottom: 0,
      trailing: Metric.compactInset)
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = Metric.recommendedMovieGroupSpacing
    section.boundarySupplementaryItems = [
      .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .absolute(Metric.recommendedMovieSectionHeaderHeight)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)]
    return section
  }
  
  private var dataSource: RxCollectionViewSectionedReloadDataSource<MovieDataSection> {
    return .init(configureCell: { dataSource, collectionView, indexPath, item in
      if indexPath.section == 0 {
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: LargeMovieThumbnailCollectionCell.identifier, for: indexPath)
                as? LargeMovieThumbnailCollectionCell else {
          return UICollectionViewCell()
        }
        
        cell.configure(movie: item, thumbnailImageViewHeroId: item.id)
        return cell
      } else {
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: MediumThumbnailMovieCollectionCell.identifier, for: indexPath)
                as? MediumThumbnailMovieCollectionCell else {
          return UICollectionViewCell()
        }
      
        cell.configure(movie: item, thumbnailImageViewHeroId: item.id)
        return cell
      }
    }, configureSupplementaryView: { section, collectionView, _, indexPath in
      if indexPath.section == 1 {
        guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
          ofKind: UICollectionView.elementKindSectionHeader,
          withReuseIdentifier: SectionHeaderCollectionReusableView.identifier,
          for: indexPath)
                as? SectionHeaderCollectionReusableView else {
          return .init()
        }
        supplementaryView.configure(title: "Recommended")
        return supplementaryView
      } else {
        return .init()
      }
    })
  }
  private var dimmingViewTopConstraint: Constraint!
  
  
  // MARK: - UI
  
  let navigationView = NavigationView().then {
    $0.backgroundColor = .clear
  }
  let navigationTitleLabel = UILabel().then {
    $0.text = "Moview"
    $0.font = UIFont.systemFont(
      ofSize: Metric.navigationTitleFontSize,
      weight: .heavy)
  }
  let searchButton = UIButton().then {
    $0.hero.id = "SearchButton"
    $0.setImage(R.image.loupe(), for: .normal)
    $0.imageEdgeInsets = .init(common: Metric.searchButtonImageInset)
    $0.tintColor = R.color.iconWhite()
  }
  var collectionView: UICollectionView!
  var dimmingBlurView = DimmingBlurView()

  
  // MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  
  // MARK: - Initializers
  
  init(viewModel: MainViewModel) {
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
    setupBackground()
    setupNavigationView()
    setupCollectionView()
    setupDimmingBlurView()
  }
  
  private func setupBackground() {
    view.backgroundColor = R.color.backgroundBlack()
  }
  
  private func setupNavigationView() {
    view.addSubview(navigationView)
    navigationView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(Metric.navigationViewHeight + SafeAreaGuide.top)
    }
    
    /// Navigation Items
    navigationView.addSubview(searchButton)
    searchButton.snp.makeConstraints {
      $0.trailing.equalTo(navigationView.safeAreaLayoutGuide).inset(Metric.regularInset)
      $0.bottom.equalToSuperview().inset(Metric.searchButtonBottomInset)
      $0.width.height.equalTo(Metric.searchButtonSize)
    }
    
    navigationView.addSubview(navigationTitleLabel)
    navigationTitleLabel.snp.makeConstraints {
      $0.leading.equalTo(navigationView.safeAreaLayoutGuide).inset(Metric.regularInset)
      $0.bottom.equalToSuperview().inset(Metric.navigationTitleBottomInset)
    }
  }
  
  private func setupCollectionView() {
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    
    collectionView.register(LargeMovieThumbnailCollectionCell.self,
                            forCellWithReuseIdentifier: LargeMovieThumbnailCollectionCell.identifier)
    collectionView.register(MediumThumbnailMovieCollectionCell.self,
                            forCellWithReuseIdentifier: MediumThumbnailMovieCollectionCell.identifier)
    collectionView.register(SectionHeaderCollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: SectionHeaderCollectionReusableView.identifier)
    
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.delaysContentTouches = false
    collectionView.backgroundColor = .clear
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.navigationView.configureScrollView(
        self.collectionView,
        threshold: Metric.navigationViewHeight + self.view.safeAreaInsets.top)
    }

    collectionView.contentInset = .init(
      top: Metric.navigationViewHeight + Metric.compactInset,
      left: 0,
      bottom: Metric.collectionViewBottomInset,
      right: 0)
    collectionView.scrollToTop(animated: false)
    
    view.insertSubview(collectionView, at: 0)
    collectionView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func setupDimmingBlurView() {
    view.insertSubview(dimmingBlurView, at: 0)
    dimmingBlurView.snp.makeConstraints {
      self.dimmingViewTopConstraint = $0.top.equalToSuperview().inset(0).constraint
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(dimmingBlurView.snp.width).multipliedBy(1.8)
    }
  }
  
  
  // MARK: - Binds
  
  private func bind() {
    bindInputs()
    bindOutputs()
  }
  
  private func bindInputs() {
    Observable.just(Void())
      .bind(to: viewModel.input.viewDidLoad)
      .disposed(by: disposeBag)
    
    collectionView.rx.itemSelected
      .map { [weak self] indexPath in
        let scrollPosition: UICollectionView.ScrollPosition = indexPath.section == 0 ? .top : .centeredVertically
        self?.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: true)
        return indexPath
      }
      .bind(to: viewModel.input.didMovieItemSelected)
      .disposed(by: disposeBag)
    
    collectionView.rx.contentOffset
      .subscribe(with: self, onNext: { vc, offset in
        let offsetY = offset.y + vc.collectionView.contentInset.top + Metric.navigationViewHeight + Metric.newMovieCollectionViewVerticalInset
        if offsetY > 0 {
          vc.dimmingViewTopConstraint.update(inset: -offsetY)
        } else {
          vc.dimmingViewTopConstraint.update(inset: 0)
        }
      })
      .disposed(by: disposeBag)
    
    searchButton.rx.tap
      .asDriver()
      .drive(with: self, onNext: { vc, _ in
        vc.presentSearchVC()
      })
      .disposed(by: disposeBag)
  }
  
  private func bindOutputs() {
    viewModel.output.movieList
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    viewModel.output.presentMovieDetail
      .asDriver(onErrorDriveWith: .empty())
      .drive(with: self, onNext: { vc, movie in
        vc.presentMovieDetailVC(movie: movie)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.isLoading
      .asDriver()
      .drive(with: self, onNext: { vc, isLoading in
        /// To invoke visible cells immediately
        vc.collectionView.layoutIfNeeded()
        
        if isLoading {
          vc.collectionView.isUserInteractionEnabled = false
          vc.dimmingBlurView.alpha = 0
          vc.collectionView.visibleCells.forEach { cell in
            cell.showCustomSkeleton()
          }
        } else {
          vc.collectionView.isUserInteractionEnabled = true
          UIView.animate(
            withDuration: 1,
            delay: 0,
            animations: {
              vc.dimmingBlurView.alpha = 1
            })
          
          /// Stop skeleton animation
          for cell in vc.collectionView.visibleCells {
            cell.hideSkeleton()
          }
        }
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
  
  private func presentSearchVC() {
    let viewModel = SearchViewModel()
    let vc = SearchViewController(viewModel: viewModel)
    vc.modalPresentationStyle = .fullScreen
    vc.heroModalAnimationType = .zoom
    present(vc, animated: true)
  }
}
