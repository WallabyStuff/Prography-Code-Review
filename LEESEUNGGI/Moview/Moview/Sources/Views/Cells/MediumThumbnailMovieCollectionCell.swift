//
//  MediumThumbnailMovieCollectionCell.swift
//  Moview
//
//  Created by Wallaby on 2023/02/04.
//

import UIKit
import Then
import SnapKit

import Kingfisher
import SkeletonView

import Hero

class MediumThumbnailMovieCollectionCell: UICollectionViewCell {
    
  // MARK: - Constants
  
  public static let identifier = "MediumMovieThumbnailCollectionCell"
  
  struct Metric {
    static let commonInset = 4.f
    
    static let thumbnailImageCornerRadius = 6.f
    
    static let titleLabelFontSize = 13.f
    static let titleLabelMaxLineNumber = 3
    static let titleLabelTopMargin = 8.f
    
    static let ratingStartSize = 12.f
    static let ratingLabelFontSize = 13.f
    static let ratingLabelTopMargin = 10.f
    static let ratingLabelBottomMargin = 8.f
  }
  
  
  // MARK: - Properties
  
  override var isHighlighted: Bool {
    didSet {
      if isHighlighted {
        thumbnailPlaceholderView.shrink()
      } else {
        thumbnailPlaceholderView.release()
      }
    }
  }
  
  
  // MARK: - UI
  
  let thumbnailPlaceholderView = UIView().then {
    $0.backgroundColor = R.color.backgroundBlackLight()
    $0.layer.cornerRadius = Metric.thumbnailImageCornerRadius
  }
  let thumbnailImageView = ThumbnailImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = Metric.thumbnailImageCornerRadius
    $0.clipsToBounds = true
  }
  let titleLabel = UILabel().then {
    $0.textColor = R.color.textWhite()
    $0.font = UIFont.systemFont(ofSize: Metric.titleLabelFontSize, weight: .bold)
    $0.numberOfLines = Metric.titleLabelMaxLineNumber
  }
  let ratingStarImageView = UIImageView().then {
    $0.image = R.image.starFilled()
    $0.tintColor = R.color.iconWhite()
  }
  let ratingLabel = UILabel().then {
    $0.textColor = R.color.textWhite()
    $0.font = UIFont.systemFont(ofSize: Metric.ratingLabelFontSize, weight: .medium)
  }
  
  
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
    setupHero()
    setupSkeleton()
    setupThumbnailPlaceholderView()
    setupThumbnailImageView()
    setupTitleLabel()
    setupStarImageView()
    setupRatingLabel()
  }
  
  private func setupHero() {
    isHeroEnabled = true
  }
  
  private func setupSkeleton() {
    isSkeletonable = true
    skeletonCornerRadius = Float(Metric.thumbnailImageCornerRadius)
  }
  
  private func setupThumbnailPlaceholderView() {
    addSubview(thumbnailPlaceholderView)
    thumbnailPlaceholderView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(thumbnailPlaceholderView.snp.width).multipliedBy(1.5)
    }
  }
  
  private func setupThumbnailImageView() {
    thumbnailPlaceholderView.addSubview(thumbnailImageView)
    thumbnailImageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func setupTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(thumbnailPlaceholderView.snp.bottom).offset(Metric.titleLabelTopMargin)
      $0.leading.trailing.equalToSuperview().inset(Metric.commonInset)
    }
  }
  
  private func setupStarImageView() {
    addSubview(ratingStarImageView)
    ratingStarImageView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(Metric.ratingLabelTopMargin)
      $0.leading.equalToSuperview().offset(Metric.commonInset)
      $0.width.height.equalTo(Metric.ratingStartSize)
    }
  }
  
  private func setupRatingLabel() {
    addSubview(ratingLabel)
    ratingLabel.snp.makeConstraints {
      $0.leading.equalTo(ratingStarImageView.snp.trailing).offset(Metric.commonInset)
      $0.bottom.equalToSuperview().inset(Metric.ratingLabelBottomMargin)
      $0.centerY.equalTo(ratingStarImageView)
    }
  }
  
  
  // MARK: - Methods
  
  public func configure(movie: Movie, thumbnailImageViewHeroId: String) {
    titleLabel.text = movie.title
    ratingLabel.text = movie.rating.description
    thumbnailImageView.configureHero(id: thumbnailImageViewHeroId)
    
    let url = URL(string: movie.large_cover_image)
    thumbnailImageView.kf.setImage(with: url, options: [.transition(.fade(0.3))])
  }
}
