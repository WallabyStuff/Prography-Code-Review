//
//  SectionHeaderCollectionReusableView.swift
//  Moview
//
//  Created by Wallaby on 2023/02/04.
//

import UIKit
import Then
import SnapKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {
  
  // MARK: - Constants
  
  static let identifier = "SectionHeaderCollectionReusableView"
  
  struct Metric {
    static let commonInset = 20.f
    static let titleLabelFontSize = 17.f
  }
  
  
  // MARK: - UI
  
  let titleLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: Metric.titleLabelFontSize, weight: .bold)
    $0.textColor = R.color.textWhite()
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
    setupTitleLabel()
  }
  
  private func setupTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(Metric.commonInset)
      $0.centerY.equalToSuperview()
    }
  }
  
  
  // MARK: - Methods
  
  public func configure(title: String) {
    titleLabel.text = title
  }
}
