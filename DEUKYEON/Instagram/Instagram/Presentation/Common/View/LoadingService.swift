//
//  LoadingService.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import UIKit

import Foundation
import UIKit

class LoadingService {
  // 로딩 띄우기
  static func showLoading() {
    DispatchQueue.main.async {
      guard let window = UIApplication.shared.windows.last else { return }
      let loadingIndicatorView: UIActivityIndicatorView
      if let existedView = window.subviews.first(
        where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
        loadingIndicatorView = existedView
      } else {
        loadingIndicatorView = UIActivityIndicatorView(style: .large)
        loadingIndicatorView.frame = window.frame
        loadingIndicatorView.color = .brown
        window.addSubview(loadingIndicatorView)
      }
      loadingIndicatorView.startAnimating()
    }
  }
  
  // 로딩 없애기
  static func hideLoading() {
    DispatchQueue.main.async {
      guard let window = UIApplication.shared.windows.last else { return }
      window.subviews.filter({ $0 is UIActivityIndicatorView })
        .forEach { $0.removeFromSuperview() }
    }
  }
}
