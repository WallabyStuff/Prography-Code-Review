//
//  MovieInfoStackViewItem.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import UIKit
import Then
import SnapKit

class MovieInfoStackViewItem: UIView {
  
  
  // MARK: - Constants
  
  struct Metric {
    static let iconSize = 28.f
    
    static let iconImageViewTopMargin = 8.f
    
    static let titleLabelTopMargin = 8.f
    
    static let descriptionLabelBottomMargin = 4.f
  }
  
  
  // MARK: - UI
  
  let iconImageView = UIImageView().then {
    $0.tintColor = R.color.iconWhite()
  }
  let titleLabel = UILabel().then {
    $0.textColor = R.color.textGray()
    $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .medium)
    $0.textAlignment = .center
  }
  let descriptionLabel = UILabel().then {
    $0.textColor = R.color.textWhite()
    $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .medium)
    $0.textAlignment = .center
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
    setupIconImageView()
    setupTitleLabel()
    setupDescriptionLabel()
  }
  
  private func setupIconImageView() {
    addSubview(iconImageView)
    iconImageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(Metric.iconImageViewTopMargin)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(Metric.iconSize)
    }
  }
  
  private func setupTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(iconImageView.snp.bottom).offset(Metric.titleLabelTopMargin)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  private func setupDescriptionLabel() {
    addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().inset(Metric.descriptionLabelBottomMargin)
    }
  }
  
  
  // MARK: - Methods
  
  public func configure(icon: UIImage?, title: String, description: String, tintColor: UIColor? = R.color.iconWhite()) {
    self.iconImageView.image = icon
    self.titleLabel.text = title
    self.descriptionLabel.text = description
    self.iconImageView.tintColor = tintColor
  }
}
