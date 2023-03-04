//
//  OptionPopupViewController.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then

final class OptionPopupViewController: UIViewController {
  
  var viewModel: OptionPopUpViewModel!
  private var disposeBag = DisposeBag()
  
  private let dimmedView = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.3)
  }
  
  private let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }
  
  private let optionPicker = UIPickerView().then {
    $0.backgroundColor = .white
  }
  
  private let doneButton = UIButton().then {
    $0.setTitle("완료", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = .black
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
  }
  
  private func configureUI() {
    
    self.view.addSubview(self.dimmedView)
    self.dimmedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.view.addSubview(self.containerView)
    self.containerView.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(50)
      $0.centerX.centerY.equalToSuperview()
    }
    
    self.containerView.addSubview(self.optionPicker)
    self.optionPicker.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }
    
    self.containerView.addSubview(self.doneButton)
    self.doneButton.snp.makeConstraints {
      $0.top.equalTo(self.optionPicker.snp.bottom)
      $0.centerX.left.right.bottom.equalToSuperview()
      $0.height.equalTo(52)
    }
  }
  
  private func bindViewModel() {
    self.bindInput()
    self.bindOutput()
  }
  
  private func bindInput() {
    let input = self.viewModel.input
    
    self.dimmedView.rx.tapGesture().when(.recognized).map { _ in }
      .bind(to: input.dimmedViewDidTapEvent)
      .disposed(by: self.disposeBag)
    
    self.optionPicker.rx.itemSelected.map { $0.row }
      .bind(to: input.pickerDidSelectEvent)
      .disposed(by: self.disposeBag)
    
    self.doneButton.rx.tap
      .bind(to: input.doneButtonDidTapEvent)
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput() {
    let output = self.viewModel.output
    self.bindPickerSection(output: output)
  }
  
  private func bindPickerSection(output: OptionPopUpViewModel.Output) {
    output.optionRange
      .asDriver()
      .drive(self.optionPicker.rx.itemTitles) { (_, element) in
        return element
      }
      .disposed(by: self.disposeBag)
    
    output.option
      .asDriver()
      .drive(onNext: { [weak self] idx in
        self?.optionPicker.selectRow(idx, inComponent: 0, animated: false)
      })
      .disposed(by: self.disposeBag)
  }
  
}
