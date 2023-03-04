//
//  MainTabBarController.swift
//  Moview
//
//  Created by Wallaby on 2023/02/04.
//

import UIKit

class MainTabBarController: UITabBarController {
  
  // MARK: - Properties
  
  enum tabBarItem: CaseIterable {
    case home
    case bookmark
    
    var title: String {
      switch self {
      case .home:
        return "Home"
      case .bookmark:
        return "Bookmark"
      }
    }
    
    var image: UIImage {
      switch self {
      case .home:
        return R.image.tabbarHome()!
      case .bookmark:
        return R.image.tabbarBookmark()!
      }
    }
    
    var selectedImage: UIImage {
      switch self {
      case .home:
        return R.image.tabbarHomeFilled()!
      case .bookmark:
        return R.image.tabbarBookmarkFilled()!
      }
    }
  }
  
  private var mainViewController: UIViewController {
    let viewModel = MainViewModel()
    return MainViewController(viewModel: viewModel)
  }
  
  private var bookmarkViewController: UIViewController {
    let viewModel = BookmarkViewModel()
    return BookmarkViewController(viewModel: viewModel)
  }
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    setupViewControllers()
    setupTabBarItems()
    setupTabBarAppearance()
  }
  
  private func setupViewControllers() {
    setViewControllers(
      [mainViewController,
       bookmarkViewController
      ],
      animated: true)
  }
  
  private func setupTabBarItems() {
    guard let items = tabBar.items else { return }
    
    for (index, item) in items.enumerated() {
      let tabBarItem = tabBarItem.allCases[index]
      item.title = tabBarItem.title
      item.image = tabBarItem.image
      item.selectedImage = tabBarItem.selectedImage
    }
  }
  
  private func setupTabBarAppearance() {
    UITabBar.appearance().barTintColor = R.color.iconGrayDark()
    UITabBar.appearance().tintColor = R.color.iconWhite()
    UITabBar.appearance().isTranslucent = true
    
    if #available(iOS 15.0, *) {
      let appearance = UITabBarAppearance()
      appearance.configureWithOpaqueBackground()
      appearance.backgroundColor = R.color.backgroundBlack()
      appearance.backgroundEffect = .init(style: .regular)
      UITabBar.appearance().standardAppearance = appearance
      UITabBar.appearance().scrollEdgeAppearance = appearance
    }
  }
}
