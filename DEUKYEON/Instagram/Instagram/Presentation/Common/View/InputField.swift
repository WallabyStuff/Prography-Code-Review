//
//  InputField.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import UIKit
import SnapKit
import Then

// UITextField 커스텀. Placeholder Text 설정
class InputField: UITextField {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setPlaceholder(string: String) {
    let font: UIFont = .systemFont(ofSize: 18, weight: .regular)
    self.attributedPlaceholder = NSAttributedString(
      string: string,
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font : font]
    )
  }
}
