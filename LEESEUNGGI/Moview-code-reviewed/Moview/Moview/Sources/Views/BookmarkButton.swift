//
//  BookmarkButton.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import UIKit

class BookmarkButton: UIButton {
  
  // MARK: - Constants
  
  struct Metric {
    static let imageEdgeInsets = 4.f
    static let unBookmarkedAlpha = 0.3.f
  }
  
  
  // MARK: - Properties
  
  public var isBookmarked = false {
    didSet {
      if isBookmarked {
        bookmark()
      } else {
        unBookmark()
      }
    }
  }
  
  
  // MARK: - Initializers
  
  convenience init(isBookmarked: Bool) {
    self.init(frame: .zero)
    self.isBookmarked = isBookmarked
  }
  
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
    setImage(R.image.bookmarkFilled(), for: .normal)
    imageEdgeInsets = .init(common: Metric.imageEdgeInsets)
    tintColor = R.color.iconWhite()?.withAlphaComponent(Metric.unBookmarkedAlpha)
  }
  
  
  // MARK: - Methods
  
  private func bookmark() {
    tintColor = R.color.accentRed()
  }
  
  private func unBookmark() {
    tintColor = R.color.iconWhite()?.withAlphaComponent(Metric.unBookmarkedAlpha)
  }
}
