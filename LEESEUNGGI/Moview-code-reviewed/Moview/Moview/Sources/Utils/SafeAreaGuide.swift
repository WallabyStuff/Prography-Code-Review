//
//  SafeAreaGuide.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import UIKit

struct SafeAreaGuide {
  static var top: CGFloat {
    let window = UIApplication.shared.windows.first!
    let topHeight = window.safeAreaInsets.top
    return topHeight
  }
}
