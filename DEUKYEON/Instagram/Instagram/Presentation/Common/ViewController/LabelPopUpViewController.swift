//
//  LabelPopUpViewController.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/05.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then

final class LabelPopUpViewController: UIViewController {
  
  // MARK: - Vars & Lets
  var viewModel: LabelPopUpViewModel!
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let dimmedView = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.3)
  }
  
  private let container = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }
  
  private let contentLabel = UILabel().then {
    $0.textAlignment = .center
    $0.textColor = .black
    $0.numberOfLines = 0
    $0.font = .systemFont(ofSize: 14, weight: .regular)
  }
  
  private lazy var buttonStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    $0.addArrangedSubview(self.cancelButton)
    $0.addArrangedSubview(self.confirmButton)
  }
  
  private let cancelButton = UIButton().then {
    $0.setTitle("취소", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
    $0.backgroundColor = .lightGray
  }
  
  private let confirmButton = UIButton().then {
    $0.setTitle("확인", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
    $0.backgroundColor = .black
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
  }
  
  func setLabel(content: String) {
    self.contentLabel.text = content
  }
  
  func setConfirmLabel(content: String) {
    self.confirmButton.setTitle(content, for: .normal)
  }
  
  // MARK: - Configure UI
  private func configureUI() {
    
    self.view.addSubview(self.dimmedView)
    self.dimmedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.view.addSubview(self.container)
    self.container.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(50)
      $0.centerX.centerY.equalToSuperview()
    }
    
    self.container.addSubview(self.buttonStackView)
    self.buttonStackView.snp.makeConstraints {
      $0.bottom.left.right.equalToSuperview()
      $0.height.equalTo(52)
    }
    
    self.container.addSubview(self.contentLabel)
    self.contentLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(42)
      $0.bottom.equalTo(self.buttonStackView.snp.top).offset(-42)
      $0.left.right.equalToSuperview()
    }
  }

  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    self.bindInput()
  }
  
  private func bindInput() {
    let input = self.viewModel.input
    
    self.cancelButton.rx.tap
      .bind(to: input.cancelButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.confirmButton.rx.tap
      .bind(to: input.confirmButtonDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.dimmedView.rx.tapGesture().when(.recognized).map{ _ in }
      .bind(to: input.dimmedViewDidTapEvent)
      .disposed(by: self.disposeBag)
  }
}
