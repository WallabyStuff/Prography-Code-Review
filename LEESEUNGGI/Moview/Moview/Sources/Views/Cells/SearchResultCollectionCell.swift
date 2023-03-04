//
//  SearchResultCollectionCell.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import UIKit
import Then
import SnapKit

import Hero

import RxSwift
import RxCocoa

class SearchResultCollectionCell: UICollectionViewCell {
  
  // MARK: - Constants
  
  static let identifier = "SearchResultCollectionCell"
  
  struct Metric {
    static let verticalInset = 12.f
    static let horizontalInset = 20.f
    
    static let thumbnailImageViewCornerRadius = 4.f
    static let thumbnailImageViewWidth = 84.f
    static let thumbnailImageViewRightMargin = 16.f
    
    static let titleLabelNumberOfLines = 3
    static let titleLabelTopMargin = 16.f
    
    static let ratingStarImageViewSize = 14.f
    static let ratingStarImageViewTopMargin = 6.f
    
    static let ratingLabelLeftMargin = 4.f
    
    static let genreChipCollectionViewTopMargin = 20.f
    static let genreChipCollectionViewVerticalInset = 4.f
    static let genreChipCollectionViewEstimatedSize = CGSize(width: 60, height: 26)
    static let genreChipFontSize = 13.f
    
    static let selectedViewCornerRadius = 10.f
  }
  
  
  // MARK: - Properties
  
  private var disposeBag = DisposeBag()
  private var genreCollectionViewLayout: UICollectionViewFlowLayout {
    let layout = GenreCollectionFlowLayout()
    layout.sectionInset = .zero
    layout.estimatedItemSize = Metric.genreChipCollectionViewEstimatedSize
    return layout
  }
  private var skeletonableViews = [UIView?]()
  
  override var isHighlighted: Bool {
    didSet {
      if isHighlighted {
        self.shrink()
      } else {
        self.release()
      }
    }
  }
  
  
  // MARK: - UI
  
  let thumbnailImageView = ThumbnailImageView().then {
    $0.backgroundColor = R.color.backgroundBlackLight()
    $0.layer.cornerRadius = Metric.thumbnailImageViewCornerRadius
    $0.clipsToBounds = true
  }
  let titleLabel = UILabel().then {
    $0.text = "title"
    $0.textColor = R.color.textWhite()
    $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .bold)
    $0.numberOfLines = Metric.titleLabelNumberOfLines
  }
  let ratingStarImageView = UIImageView().then {
    $0.image = R.image.starFilled()
    $0.tintColor = R.color.iconWhite()
  }
  let ratingLabel = UILabel().then {
    $0.textColor = R.color.textWhite()
    $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .medium)
  }
  var genreChipCollectionView: UICollectionView!
  
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: - Setups
  
  private func setup() {
    setupView()
  }
  
  private func setupView() {
    setupSkeleton()
    setupSelectedView()
    setupThumbnailImageView()
    setupTitleLabel()
    setupRatingStarImageView()
    setupRatingLabel()
    setupGenreChipCollectionView()
  }
  
  private func setupSkeleton() {
    skeletonableViews.append(thumbnailImageView)
    thumbnailImageView.isSkeletonable = true
    thumbnailImageView.skeletonCornerRadius = Float(Metric.thumbnailImageViewCornerRadius)

    skeletonableViews.append(titleLabel)
    titleLabel.isSkeletonable = true
    titleLabel.skeletonTextNumberOfLines = 2
    titleLabel.skeletonCornerRadius = Float(Metric.thumbnailImageViewCornerRadius)
    
    skeletonableViews.append(ratingStarImageView)
    ratingStarImageView.isSkeletonable = true
    ratingStarImageView.isHiddenWhenSkeletonIsActive = true
    
    skeletonableViews.append(ratingLabel)
    ratingLabel.isSkeletonable = true
    ratingLabel.isHiddenWhenSkeletonIsActive = true
    
    skeletonableViews.append(genreChipCollectionView)
    genreChipCollectionView?.isSkeletonable = true
    genreChipCollectionView?.isHiddenWhenSkeletonIsActive = true
  }
  
  private func setupSelectedView() {
    let selectedView = UIView(frame: bounds)
    selectedView.backgroundColor = R.color.backgroundBlackLighter()
    selectedView.layer.cornerRadius = Metric.selectedViewCornerRadius
    selectedBackgroundView = selectedView
  }
  
  private func setupThumbnailImageView() {
    addSubview(thumbnailImageView)
    thumbnailImageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(Metric.verticalInset)
      $0.leading.equalToSuperview().inset(Metric.horizontalInset)
      $0.width.equalTo(Metric.thumbnailImageViewWidth)
      $0.height.equalTo(thumbnailImageView.snp.width).multipliedBy(1.5)
    }
  }
  
  private func setupTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(Metric.titleLabelTopMargin)
      $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(Metric.thumbnailImageViewRightMargin)
      $0.trailing.equalToSuperview().inset(Metric.horizontalInset)
    }
  }
  
  private func setupRatingStarImageView() {
    addSubview(ratingStarImageView)
    ratingStarImageView.snp.makeConstraints {
      $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(Metric.thumbnailImageViewRightMargin)
      $0.top.equalTo(titleLabel.snp.bottom).offset(Metric.ratingStarImageViewTopMargin)
      $0.width.height.equalTo(Metric.ratingStarImageViewSize)
    }
  }
  
  private func setupRatingLabel() {
    addSubview(ratingLabel)
    ratingLabel.snp.makeConstraints {
      $0.leading.equalTo(ratingStarImageView.snp.trailing).offset(Metric.ratingLabelLeftMargin)
      $0.centerY.equalTo(ratingStarImageView)
    }
  }
  
  private func setupGenreChipCollectionView() {
    genreChipCollectionView = UICollectionView(frame: .zero, collectionViewLayout: genreCollectionViewLayout)
    genreChipCollectionView.register(GenreChipCollectionCell.self, forCellWithReuseIdentifier: GenreChipCollectionCell.identifier)
    
    addSubview(genreChipCollectionView)
    genreChipCollectionView.snp.makeConstraints {
      $0.top.equalTo(ratingLabel.snp.bottom).offset(Metric.genreChipCollectionViewTopMargin)
      $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(Metric.thumbnailImageViewRightMargin)
      $0.trailing.equalToSuperview().inset(Metric.horizontalInset)
      $0.bottom.equalToSuperview().inset(Metric.verticalInset)
    }
    
    genreChipCollectionView.contentInset = .zero
    genreChipCollectionView.backgroundColor = .clear
    genreChipCollectionView.isUserInteractionEnabled = false
  }
  
  
  // MARK: - Methods
  
  public func configure(movie: Movie, thumbnailImageViewHeroId: String) {
    titleLabel.text = movie.title
    ratingLabel.text = movie.rating.description
    thumbnailImageView.configureHero(id: thumbnailImageViewHeroId)
    
    let url = URL(string: movie.large_cover_image)
    thumbnailImageView.kf.setImage(with: url, options: [.transition(.fade(0.3))])
    
    /// Genre chip collectionView
    genreChipCollectionView.delegate = nil
    genreChipCollectionView.dataSource = nil
    Observable.just(movie.genres)
      .bind(to: genreChipCollectionView.rx.items(cellIdentifier: GenreChipCollectionCell.identifier, cellType: GenreChipCollectionCell.self)) { index, genreTitle, cell in
        cell.configure(genreTitle: genreTitle, fontSize: Metric.genreChipFontSize)
      }
      .disposed(by: disposeBag)
  }
  
  /// Skeleton view does not work as well for some reason so need to call showSkeleton() manually
  public func showSkeleton() {
    skeletonableViews.forEach { view in
      view?.showCustomSkeleton()
    }
  }
  
  public func hideSkeleton() {
    skeletonableViews.forEach { view in
      view?.hideSkeleton()
    }
  }
}
