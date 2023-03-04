//
//  OptionPopUpCoordinator.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/05.
//

protocol OptionPopUpCoordinator: AnyObject {
  
  // 옵션 팝업 띄우기
  func showOptionPopUp(with: Int)
  
  // 옵션 팝업 없애기
  func hideOptionPopUp()
}
