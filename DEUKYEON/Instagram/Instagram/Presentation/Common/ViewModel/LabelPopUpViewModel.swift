//
//  LabelPopUpViewModel.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/05.
//

import RxSwift
import RxRelay

final class LabelPopUpViewModel {
  
  // MARK: - Input & Output
  
  /// `dimmedViewDidTapEvent` : Background 클릭시
  /// `cancelButtonDidTapEvent` : 팝업의 취소버튼을 누를 때
  /// `confirmButtonDidTapEvent` : 팝업의 확인버튼을 누를 때
  struct Input {
    let dimmedViewDidTapEvent = PublishRelay<Void>()
    let cancelButtonDidTapEvent = PublishRelay<Void>()
    let confirmButtonDidTapEvent = PublishRelay<Void>()
  }
  
  // MARK: - Vars & Lets
  private weak var coordinator: LabelPopUpCoordinator?
  private let disposeBag = DisposeBag()
  weak var delegate: LabelPopupDismissDelegate?
  let input = Input()
  
  // MARK: - Life Cycle
  init(coordinator: LabelPopUpCoordinator) {
    self.coordinator = coordinator
    self.transform(input: self.input)
  }
  
  // MARK: - Binding
  func transform(input: Input) {
    self.bindInput(input: input)
  }
  
  private func bindInput(input: Input) {
    input.dimmedViewDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.hideLabelPopUp()
      })
      .disposed(by: disposeBag)
    
    input.cancelButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.coordinator?.hideLabelPopUp()
      })
      .disposed(by: disposeBag)
    
    input.confirmButtonDidTapEvent
      .subscribe(onNext: { [weak self] in
        self?.delegate?.confirm()
        self?.coordinator?.hideLabelPopUp()
      })
      .disposed(by: disposeBag)
  }
}

protocol LabelPopupDismissDelegate: AnyObject {
  func confirm()
}
