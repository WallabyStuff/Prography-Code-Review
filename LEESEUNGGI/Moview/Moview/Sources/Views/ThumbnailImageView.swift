//
//  ThumbnailImageView.swift
//  Moview
//
//  Created by Wallaby on 2023/02/12.
//

import UIKit
import Then
import SnapKit

import Hero

class ThumbnailImageView: UIImageView {
  
  // MARK: - Constants
  
  struct Metric {
    static let defaultEmptyStateImageSize = 28.f
  }
  
  // MARK: - Properties

  var emptyStateImageSize = Metric.defaultEmptyStateImageSize
  override var image: UIImage? {
    didSet {
      if image == nil {
        emptyStateImageView.isHidden = false
      } else {
        emptyStateImageView.isHidden = true
      }
    }
  }
  
  
  // MARK: - UI
  
  let emptyStateImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = R.image.empty()
    $0.tintColor = R.color.iconGrayDark()
    $0.isHidden = true
  }
  
  
  // MARK: - Initializers
  
  convenience init(emptyStateImageSize: CGFloat = Metric.defaultEmptyStateImageSize) {
    self.init(frame: .zero)
    self.emptyStateImageSize = emptyStateImageSize
    setup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    setupView()
  }
  
  private func setupView() {
    setupEmptyStateImageView()
  }
  
  private func setupEmptyStateImageView() {
    addSubview(emptyStateImageView)
    emptyStateImageView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.height.equalTo(emptyStateImageSize)
    }
  }
  
  
  // MARK: - Methods
  
  public func configureHero(id: String) {
    hero.id = id
    
    if emptyStateImageView.image == nil {
      emptyStateImageView.hero.id = "\(id)emptyStateImageView"
    }
  }
}

