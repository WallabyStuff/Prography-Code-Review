//
//  UIView+BounceAnimation.swift
//  Moview
//
//  Created by Wallaby on 2023/02/08.
//

import UIKit

extension UIView {
  
  static let SHRINK_ANIMATION_DEFAULT_DURATION: CGFloat = 0.22
  static let RELEASE_ANIMATION_DEFAULT_DURATION: CGFloat = 0.25
  
  static let SHRINK_DEFAULT_SCALE: CGFloat = 0.95
  
  func shrink(duration: CGFloat = SHRINK_ANIMATION_DEFAULT_DURATION,
                     scale: CGFloat = SHRINK_DEFAULT_SCALE ) {
    UIView.animate(
      withDuration: duration,
      delay: 0,
      options: [.curveEaseOut],
      animations: {
        self.transform = .init(scaleX: scale, y: scale)
      })
  }
  
  func release(duration: CGFloat = RELEASE_ANIMATION_DEFAULT_DURATION) {
    UIView.animate(
      withDuration: duration,
      delay: 0,
      options: [.curveEaseOut],
      animations: {
        self.transform = .init(scaleX: 1.0, y: 1.0)
      })
  }
}

