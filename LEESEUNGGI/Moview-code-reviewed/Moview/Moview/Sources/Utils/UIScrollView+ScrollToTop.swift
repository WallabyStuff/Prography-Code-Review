//
//  UIScrollView+ScrollToTop.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import UIKit

extension UIScrollView {
  func scrollToTop(animated: Bool = true) {
    let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
    scrollToTop(offset: desiredOffset)
  }
  
  func scrollToTop(animated: Bool = true, offset: CGPoint) {
    setContentOffset(offset, animated: animated)
  }
}
