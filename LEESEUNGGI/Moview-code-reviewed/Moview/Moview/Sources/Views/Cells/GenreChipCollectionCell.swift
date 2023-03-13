//
//  GenreChipCollectionCell.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import UIKit
import Then
import SnapKit

class GenreChipCollectionCell: UICollectionViewCell {
  
  // MARK: - Constants
  
  static let identifier = "GenreChipCollectionCell"
  
  struct Metric {
    static let labelVerticalInset = 4.f
    static let labelHorizontalInset = 12.f
    
    static let borderWidth = 1.f
    static let cornerRadius = 9.f
    
    static let defaultFontSize = 15.f
  }
  
  
  // MARK: - UI
  
  let genreLabel = UILabel().then {
    $0.textColor = R.color.textWhite()
    $0.font = UIFont.systemFont(ofSize: Metric.defaultFontSize, weight: .medium)
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
    backgroundColor = R.color.backgroundBlackLight()
    layer.cornerRadius = Metric.cornerRadius
    layer.borderWidth = Metric.borderWidth
    layer.borderColor = R.color.lineGray()?.cgColor
    
    setupGenreLabel()
  }
  
  private func setupGenreLabel() {
    addSubview(genreLabel)
    genreLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(Metric.labelVerticalInset)
      $0.leading.trailing.equalToSuperview().inset(Metric.labelHorizontalInset)
    }
  }
  
  
  // MARK: - Methods
  
  public func configure(genreTitle: String, fontSize: CGFloat = Metric.defaultFontSize) {
    genreLabel.text = genreTitle
    genreLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
  }
}
