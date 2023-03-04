//
//  DefaultTabCoordinator.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import UIKit

protocol TabCoordinator: Coordinator {
  func showTabBar()
}

final class DefaultTabCoordinator: BaseCoordinator, TabCoordinator {
    
  var tabBarController: UITabBarController
  
  // MARK: - Life Cycle
  override init(_ navigationController: UINavigationController) {
    self.tabBarController = UITabBarController()
    super.init(navigationController)
  }
  
  func start() {
    self.showTabBar()
  }
  
  func showTabBar() {
    let pages: [Tab] = Tab.allCases
    let controllers: [UINavigationController] = pages.map {
      self.setTabNavigationController(of: $0)
    }
    self.configureTabBarController(with: controllers)
  }

  // 탭 정보 세팅
  private func configureTabBarController(with tabViewControllers: [UIViewController]) {
    self.tabBarController.setViewControllers(tabViewControllers, animated: false)
    self.tabBarController.selectedIndex = Tab.list.pageOrderNumber()
    self.tabBarController.view.backgroundColor = .white
    self.tabBarController.tabBar.backgroundColor = .white
    self.tabBarController.tabBar.tintColor = .black
    self.tabBarController.tabBar.isTranslucent = false
    
    self.navigationController.pushViewController(self.tabBarController, animated: false)
    self.navigationController.isNavigationBarHidden = true
  }
  
  // 각각의 Coordinator에 들어갈 navigationController 세팅
  private func setTabNavigationController(of page: Tab) -> UINavigationController {
    let tabNavigationController = BaseNavigationController()
    tabNavigationController.setNavigationBarHidden(false, animated: false)
    tabNavigationController.tabBarItem = self.configureTabBarItem(of: page)
    self.startTabCoordinator(of: page, to: tabNavigationController)
    return tabNavigationController
  }
  
  // 각각의 탭에 Coordinator 붙이기
  private func configureTabBarItem(of page: Tab) -> UITabBarItem {
    return UITabBarItem(title: page.tabName(),
                        image: UIImage(named: page.tabIconUnselected()),
                        selectedImage: UIImage(named: page.tabIconSelected()))
  }
  
  private func startTabCoordinator(of page: Tab, to tabNavigationController: UINavigationController) {
    switch page {
    case .list:
      let coordinator = DefaultListCoordinator(tabNavigationController)
      self.addDependency(coordinator)
      coordinator.start()
    case .search:
      let coordinator = DefaultSearchCoordinator(tabNavigationController)
      self.addDependency(coordinator)
      coordinator.start()
    case .mypage:
      let coordinator = DefaultMyPageCoordinator(tabNavigationController)
      self.addDependency(coordinator)
      coordinator.start()
    }
  }
}
