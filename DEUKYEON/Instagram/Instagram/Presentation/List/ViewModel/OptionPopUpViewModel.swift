//
//  OptionPopUpViewModel.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import RxSwift
import RxRelay

final class OptionPopUpViewModel {
  
  // MARK: - Input & Output
  
  /// `dimmedViewDidTapEvent` : Background 클릭시
  /// `pickerDidSelectEvent` : Picker에서 선택 시, `Int`: Picker의 row
  /// `doneButtonDidTapEvent` : 팝업의 완료버튼을 누를 때
  struct Input {
    let dimmedViewDidTapEvent = PublishRelay<Void>()
    let pickerDidSelectEvent = PublishRelay<Int>()
    let doneButtonDidTapEvent = PublishRelay<Void>()
  }
  
  struct Output {
    var optionRange = BehaviorRelay<[String]>(value: Option.allCases.map { $0.description })
    var option = BehaviorRelay<Int>(value: 0)
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: ListCoordinator?
  private let disposeBag = DisposeBag()
  weak var delegate: OptionPopupDismissDelegate?
  let input = Input()
  let output = Output()
  
  // MARK: - Life Cycle
  init(coordinator: ListCoordinator?, option: Int) {
    self.coordinator = coordinator
    self.transform(input: self.input, output: self.output, option: option)
  }
  
  func transform(input: Input, output: Output, option: Int) {
    let option = BehaviorRelay<Int>(value: option)
    
    self.bindInput(input: input, option: option)
    self.bindOutput(output: output, option: option)
  }
  
  private func bindInput(input: Input, option: BehaviorRelay<Int>) {
    
    input.dimmedViewDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.hideOptionPopUp()
      })
      .disposed(by: disposeBag)
    
    input.pickerDidSelectEvent
      .bind(to: option)
      .disposed(by: disposeBag)
    
    input.doneButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.delegate?.confirm(option: option.value)
        self?.coordinator?.hideOptionPopUp()
      })
      .disposed(by: disposeBag)
  }
  
  private func bindOutput(output: Output, option: BehaviorRelay<Int>) {
    option
      .bind(to: output.option)
      .disposed(by: self.disposeBag)
  }
}

protocol OptionPopupDismissDelegate: AnyObject {
  func confirm(option: Int)
}
