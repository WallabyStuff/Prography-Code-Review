//
//  LargeMovieThumbnailCollectionCell.swift
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

class LargeMovieThumbnailCollectionCell: UICollectionViewCell {
  
  // MARK: - Constants
  
  public static let identifier = "LargeMovieThumbnailCollectionCell"
  
  struct Metric {
    static let estimatedSize = CGSize(width: 279, height: 420)
    
    static let cornerRadius = 6.f
    
    static let shadowOffset = CGSize(width: 0, height: 4)
    static let shadowRadius = 6.f
    static let shadowOpacity = Float(0.8)
    
    static let emptyStateImageViewSize = 44.f
  }
  
  
  // MARK: - Properties
  
  override var isHighlighted: Bool {
    didSet {
      if isHighlighted {
        thumbnailImageView.shrink()
      } else {
        thumbnailImageView.release()
      }
    }
  }
  
  
  // MARK: - UI
  
  let thumbnailImageView = ThumbnailImageView(emptyStateImageSize: Metric.emptyStateImageViewSize).then {
    $0.backgroundColor = R.color.backgroundBlackLight()
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = Metric.cornerRadius
    $0.layer.masksToBounds = true
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
    isHeroEnabled = true
    
    setupBackground()
    setupThumbnailImageView()
  }
  
  private func setupBackground() {
    layer.cornerRadius = Metric.cornerRadius
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = Metric.shadowOffset
    layer.shadowRadius = Metric.shadowRadius
    layer.shadowOpacity = Metric.shadowOpacity
    
    /// Skeleton view
    isSkeletonable = true
    skeletonCornerRadius = Float(Metric.cornerRadius)
  }
  
  private func setupThumbnailImageView() {
    addSubview(thumbnailImageView)
    thumbnailImageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  
  // MARK: - Methods
  
  public func configure(movie: Movie, thumbnailImageViewHeroId: String) {
    thumbnailImageView.configureHero(id: thumbnailImageViewHeroId)
    
    let url = URL(string: movie.large_cover_image)
    thumbnailImageView.kf.setImage(with: url)
  }
}
