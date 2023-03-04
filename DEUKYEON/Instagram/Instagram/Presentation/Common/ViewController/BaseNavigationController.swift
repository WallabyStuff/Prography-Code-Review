//
//  BaseNavigationController.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//


import UIKit
import Then

// 기본 NavigationController 설정
class BaseNavigationController: UINavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setNavigationBarHidden(true, animated: false)
    self.interactivePopGestureRecognizer?.delegate = nil
    self.navigationBar.barTintColor = .white
    self.navigationBar.backIndicatorImage = UIImage()
    self.navigationBar.backIndicatorTransitionMaskImage = UIImage()
    self.navigationController?.navigationBar.titleTextAttributes = [
      .foregroundColor: UIColor.black
    ]
  }
}
