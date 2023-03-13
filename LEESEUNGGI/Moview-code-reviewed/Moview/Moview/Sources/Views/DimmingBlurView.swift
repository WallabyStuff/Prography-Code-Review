//
//  DimmingBlurView.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class DimmingBlurView: UIView {
  
  // MARK: - Constants
  
  struct Metric {
    static let gradientLayerHeight = 80.f
  }
  
  
  // MARK: - UI
  
  let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
  }
  var blurView: UIVisualEffectView!
  var gradientLayer = CAGradientLayer()

  
  // MARK: - LifeCycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    updateGradientLayer()
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    setupView()
  }
  
  private func setupView() {
    setupBackground()
    setupImageView()
    setupBlurView()
    setupGradient()
    DispatchQueue.main.async { [weak self] in
      self?.setupGradient()
    }
  }
  
  private func setupBackground() {
    clipsToBounds = false
    backgroundColor = R.color.backgroundBlack()
  }
  
  private func setupImageView() {
    addSubview(imageView)
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func setupBlurView() {
    let blurEffect = UIBlurEffect(style: .regular)
    blurView = UIVisualEffectView(effect: blurEffect)
    addSubview(blurView)
    blurView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func setupGradient() {
    gradientLayer = CAGradientLayer()
    gradientLayer.startPoint = .init(x: 0.5, y: 1)
    gradientLayer.endPoint = .init(x: 0.5, y: 0)
    gradientLayer.colors = [
      R.color.backgroundBlack()!.cgColor,
      R.color.backgroundBlack()!.withAlphaComponent(0).cgColor,
      R.color.backgroundBlack()!.withAlphaComponent(0).cgColor,]
    gradientLayer.locations = [0, 0.2, 1.0]
    gradientLayer.frame = bounds
    blurView.layer.addSublayer(gradientLayer)
  }
  
  
  // MARK: - Methods
  
  public func setImage(_ imageURL: String) {
    let url = URL(string: imageURL)
    self.imageView.kf.setImage(with: url, options: [.transition(.fade(0.5)), .forceTransition])
  }
  
  private func updateGradientLayer() {
    gradientLayer.frame = bounds
  }
}
