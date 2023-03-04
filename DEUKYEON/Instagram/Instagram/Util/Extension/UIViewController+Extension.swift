//
//  UIViewController+Extension.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import UIKit

extension UIViewController {
  
  /// Navigation Bar Back Button 설정
  func setBackButton() {
    let backImage = UIImage(named: "btnBack")
    let backBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: nil, action: nil)
    backBarButtonItem.tintColor = .black
    self.navigationItem.backBarButtonItem = backBarButtonItem
  }
  
  /// Navigation Bar title 설정
  func setNavigationTitle(title: String) {
    let titleLabel = UILabel().then {
      $0.text = title
      $0.font = .systemFont(ofSize: 25, weight: .bold)
    }
    let titleButtonItem = UIBarButtonItem(customView: titleLabel)
    self.navigationItem.leftBarButtonItem = titleButtonItem
    self.navigationItem.leftItemsSupplementBackButton = true
  }
}
