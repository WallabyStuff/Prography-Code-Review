//
//  NavigationView.swift
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

class NavigationView: UIView {
  
  // MARK: - Constans
  
  struct Metric {
    static let separatorWidth = 1.f
  }
  
  
  // MARK: - Properties
  
  private var disposeBag = DisposeBag()
  private var targetScrollView: UIScrollView?
  
  
  // MARK: - UI
  
  let separatorLine = UIView().then {
    $0.backgroundColor = R.color.lineGrayDark()
    $0.alpha = 0
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
    setupSeparatorLine()
  }
  
  private func setupSeparatorLine() {
    addSubview(separatorLine)
    separatorLine.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(Metric.separatorWidth)
    }
  }
  
  
  // MARK: - Methods
  
  public func configureScrollView(_ scrollView: UIScrollView, threshold: CGFloat) {
    scrollView.rx.contentOffset
      .asDriver()
      .drive(with: self, onNext: { vc, offset in
        let alphaDelay = 10.f
        let alpha = (threshold + offset.y) / alphaDelay
        
        vc.separatorLine.alpha = alpha
        vc.backgroundColor = R.color.backgroundBlack()?.withAlphaComponent(alpha)
      })
      .disposed(by: disposeBag)
  }
}
