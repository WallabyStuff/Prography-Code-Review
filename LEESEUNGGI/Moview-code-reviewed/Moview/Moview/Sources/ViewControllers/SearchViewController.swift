//
//  SearchViewController.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import UIKit

import Then
import SnapKit
import Hero
import Toast_Swift

import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
  
  // MARK: - Constants
  
  struct Metric {
    static let regularInset = 20.f
    
    static let navigationViewHeight = 64.f
    
    static let backButtonSize = 32.f
    static let backButtonImageInset = 6.f
    
    static let searchButtonSize = 32.f
    static let searchButtonImageInset = 6.f
    static let searchButtonRightMargin = 6.f
    
    static let navigationBarItemBottomMargin = 16.f
    
    static let searchTextFieldHeight = 44.f
    static let searchTextFieldCornerRadius = 10.f
    static let searchTextFieldLeftPadding = 16.f
    static let searchTextFieldRightPadding = 44.f
    static let searchTextFieldBottomMargin = 8.f
    static let searchTextFieldLeftMargin = 12.f
    
    static let estimatedSearchResultCellHeight = 150.f
    static let searchResultCollectionViewTopInset = 12.f
    static let searchResultCollectionViewBottomInset = 100.f
  }
  
  // MARK: - Properties
  
  private var viewModel = SearchViewModel()
  private var disposeBag = DisposeBag()
  private var searchResultCollectionViewLayout: UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(Metric.estimatedSearchResultCellHeight))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: itemSize,
      subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
  private var searchTerm: String {
    return (searchTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  
  // MARK: - UI
  
  let navigationView = NavigationView()
  let backButton = UIButton().then {
    $0.setImage(R.image.back(), for: .normal)
    $0.tintColor = R.color.iconWhite()
    $0.imageEdgeInsets = .init(common: Metric.backButtonImageInset)
  }
  let searchTextField = UITextField().then {
    $0.attributedPlaceholder = NSAttributedString(
      string: "Quick search",
      attributes: [NSAttributedString.Key.foregroundColor: R.color.textGrayDarker()!]
    )
    $0.backgroundColor = R.color.backgroundBlackLight()
    $0.layer.cornerRadius = Metric.searchTextFieldCornerRadius
    $0.returnKeyType = .search
    $0.tintColor = R.color.accentRed()
  }
  let searchButton = UIButton().then {
    $0.hero.id = "SearchButton"
    $0.setImage(R.image.loupe(), for: .normal)
    $0.tintColor = R.color.iconWhite()
    $0.imageEdgeInsets = .init(common: Metric.searchButtonImageInset)
    $0.backgroundColor = .clear
    $0.layer.cornerRadius = Metric.searchTextFieldCornerRadius
  }
  var searchResultCollectionView: UICollectionView!
  var searchResultPlaceholder = UILabel().then {
    $0.textColor = R.color.textGrayDarker()
  }
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchTextField.becomeFirstResponder()
  }
  
  // MARK: - Initializers
  
  init(viewModel: SearchViewModel) {
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
    isHeroEnabled = true
    
    setupBackground()
    setupNavigationView()
    setupSearchButton()
    setupSearchResultCollectionView()
    bindSearchResultPlaceholder()
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
    
    navigationView.addSubview(backButton)
    backButton.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(Metric.regularInset)
      $0.bottom.equalToSuperview().inset(Metric.navigationBarItemBottomMargin)
      $0.width.height.equalTo(Metric.backButtonSize)
    }
    
    navigationView.addSubview(searchTextField)
    searchTextField.snp.makeConstraints {
      $0.leading.equalTo(backButton.snp.trailing).offset(Metric.searchTextFieldLeftMargin)
      $0.bottom.equalToSuperview().inset(Metric.searchTextFieldBottomMargin)
      $0.height.equalTo(Metric.searchTextFieldHeight)
      $0.trailing.equalToSuperview().inset(Metric.regularInset)
    }
    
    let leftPadding = UIView(frame: .init(x: 0, y: 0, width: Metric.searchTextFieldLeftPadding, height: Metric.searchTextFieldHeight))
    searchTextField.leftView = leftPadding
    searchTextField.leftViewMode = .always
    
    let rightPadding = UIView(frame: .init(x: 0, y: 0, width: Metric.searchTextFieldRightPadding, height: Metric.searchTextFieldHeight))
    searchTextField.rightView = rightPadding
    searchTextField.rightViewMode = .always
  }
  
  private func setupSearchButton() {
    searchButton.hero.id = "SearchButton"
    view.addSubview(searchButton)
    searchButton.snp.makeConstraints {
      $0.trailing.equalTo(searchTextField).inset(Metric.searchButtonRightMargin)
      $0.centerY.equalTo(searchTextField)
      $0.width.height.equalTo(Metric.searchButtonSize)
    }
  }
  
  private func setupSearchResultCollectionView() {
    /// Register cell
    searchResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: searchResultCollectionViewLayout)
    searchResultCollectionView.register(SearchResultCollectionCell.self, forCellWithReuseIdentifier: SearchResultCollectionCell.identifier)
    
    /// Setup constraints
    view.insertSubview(searchResultCollectionView, at: 0)
    searchResultCollectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    /// Setup insets
    searchResultCollectionView.contentInset = .init(
      top: Metric.navigationViewHeight + Metric.searchResultCollectionViewTopInset,
      bottom: Metric.searchResultCollectionViewBottomInset)
    searchResultCollectionView.scrollIndicatorInsets = .init(
      top: Metric.navigationViewHeight + Metric.searchResultCollectionViewTopInset)
    
    /// Configure navigation bar opaque threshold
    navigationView.configureScrollView(
      searchResultCollectionView,
      threshold: Metric.navigationViewHeight + SafeAreaGuide.top)
    
    // Etc
    searchResultCollectionView.delaysContentTouches = false
  }
  
  private func bindSearchResultPlaceholder() {
    view.addSubview(searchResultPlaceholder)
    searchResultPlaceholder.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
  }
  
  
  // MARK: - Binds
  
  private func bind() {
    bindInputs()
    bindOutputs()
    bindCollectionViewScrollToEndEditing()
  }
  
  private func bindInputs() {
    backButton.rx.tap
      .asDriver()
      .drive(with: self, onNext: { vc, _ in
        vc.dismiss()
      })
      .disposed(by: disposeBag)
    
    searchTextField.rx.controlEvent([.editingDidEndOnExit])
      .map { self.searchTerm }
      .bind(to: viewModel.input.search)
      .disposed(by: disposeBag)
    
    searchButton.rx.tap
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .map { self.searchTerm }
      .bind(to: viewModel.input.search)
      .disposed(by: disposeBag)
    
    searchResultCollectionView.rx.itemSelected
      .map { [weak self] indexPath in
        self?.searchResultCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        return indexPath
      }
      .bind(to: viewModel.input.didSelectItem)
      .disposed(by: disposeBag)
    searchResultCollectionView.backgroundColor = .clear
  }
  
  private func bindOutputs() {
    /// Show skeleton views when loading search results
    viewModel.output.isLoading
      .asDriver(onErrorDriveWith: .empty())
      .drive(with: self, onNext: { vc, isLoading in
        vc.searchResultCollectionView.scrollToTop(animated: false, offset: .init(x: 0, y: -(Metric.searchResultCollectionViewTopInset + Metric.navigationViewHeight + vc.view.safeAreaInsets.top)))
        vc.searchResultCollectionView.isUserInteractionEnabled = !isLoading
        vc.searchResultCollectionView.layoutIfNeeded()
        
        for cell in vc.searchResultCollectionView.visibleCells {
          guard let cell = cell as? SearchResultCollectionCell else { continue }
          
          if isLoading {
            cell.showSkeleton()
          } else {
            cell.hideSkeleton()
          }
        }
      })
      .disposed(by: disposeBag)
    
    /// Disable search button when loading search results
    viewModel.output.isLoading
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { isLoading in
        self.searchButton.isEnabled = !isLoading
      })
      .disposed(by: disposeBag)
    
    viewModel.output.searchResultMovie
      .asDriver(onErrorDriveWith: .empty())
      .drive(with: self, onNext: { vc, movies in
        if movies.isEmpty {
          vc.searchResultCollectionView.isHidden = true
          vc.searchResultPlaceholder.isHidden = false
          vc.searchResultPlaceholder.text = "No search result"
        } else {
          vc.searchResultCollectionView.isHidden = false
          vc.searchResultPlaceholder.isHidden = true
          vc.view.endEditing(true)
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output.searchResultMovie
      .bind(to: searchResultCollectionView.rx.items(
        cellIdentifier: SearchResultCollectionCell.identifier,
        cellType: SearchResultCollectionCell.self)) { index, movie, cell in
          cell.configure(movie: movie, thumbnailImageViewHeroId: movie.id)
        }
        .disposed(by: disposeBag)
    
    viewModel.output.presentMoviewDetailVC
      .asDriver(onErrorDriveWith: .empty())
      .drive(with: self, onNext: { vc, movie in
        vc.presentMovieDetailVC(movie: movie)
      })
      .disposed(by: disposeBag)
    
    viewModel.output.showToastMessage
      .asDriver(onErrorDriveWith: .empty())
      .drive(with: self, onNext: { vc, message in
        vc.view.makeToast(message, position: .center)
      })
      .disposed(by: disposeBag)
  }
  
  private func bindCollectionViewScrollToEndEditing() {
    searchResultCollectionView.rx.didScroll
      .subscribe(with: self, onNext: { vc, _  in
        vc.view.endEditing(true)
      })
      .disposed(by: disposeBag)
  }
  
  
  // MARK: - Methods
  
  private func dismiss() {
    heroModalAnimationType = .zoomOut
    dismiss(animated: true)
  }
  
  private func presentMovieDetailVC(movie: Movie) {
    let viewModel = MovieDetailViewModel(movie: movie)
    let vc = MovieDetailViewController(
      viewModel: viewModel,
      thumbnailImageViewHeroId: movie.id)
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }
}
