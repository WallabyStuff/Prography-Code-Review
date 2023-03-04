//
//  UIEdgeInset+Shortcut.swift
//  Moview
//
//  Created by Wallaby on 2023/02/04.
//

import UIKit

extension UIEdgeInsets {
  init(common: CGFloat) {
    self.init(top: common, left: common, bottom: common, right: common)
  }
  
  init(vertical: CGFloat, horizontal: CGFloat) {
    self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
  }
  
  init(horizontal: CGFloat) {
    self.init(horizontal: horizontal, top: 0, bottom: 0)
  }
  
  init(vertical: CGFloat) {
    self.init(vertical: vertical, left: 0, right: 0)
  }
  
  init(horizontal: CGFloat, top: CGFloat, bottom: CGFloat) {
    self.init(top: top, left: horizontal, bottom: bottom, right: horizontal)
  }
  
  init(vertical: CGFloat, left: CGFloat, right: CGFloat) {
    self.init(top: vertical, left: left, bottom: vertical, right: right)
  }
  
  init(top: CGFloat) {
    self.init(top: top, left: 0, bottom: 0, right: 0)
  }
  
  init(top: CGFloat, bottom: CGFloat) {
    self.init(top: top, left: 0, bottom: bottom, right: 0)
  }
}
