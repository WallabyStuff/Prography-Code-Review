//
//  DefaultMyPageCoordinator.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/05.
//

import UIKit

protocol MyPageCoordinator: MovieDetailCoordinator, LabelPopUpCoordinator {}

final class DefaultMyPageCoordinator: BaseCoordinator, MyPageCoordinator {
  
  override init(_ navigationController: UINavigationController) {
    super.init(navigationController)
  }
  
  func start() {
    self.showMovieSearch()
  }
  
  private func showMovieSearch() {
    let vc = MyPageViewController()
    vc.viewModel = MyPageViewModel(coordinator: self,
                                   fetchMovieListInStorageUseCase: DefaultFetchMovieListInStorage(storage: DefaultStorage.shared),
                                   deleteMovieUseCase: DefaultDeleteMovieUseCase(storage: DefaultStorage.shared))
    self.navigationController.pushViewController(vc, animated: true)
  }
  
  func showMovieDetail(movie: Movie) {
    let vc = MovieDetailViewController()
    vc.viewModel = MovieDetailViewModel(coordinator: self,
                                        movie: movie)
    vc.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(vc, animated: true)
  }
  
  func showLabelPopUp() {
    guard let pvc = self.navigationController.viewControllers.last as? MyPageViewController else {
      return
    }
    
    let vc = LabelPopUpViewController().then {
      $0.setLabel(content: "해당 영화를 삭제하시겠습니까?")
    }
    vc.viewModel = LabelPopUpViewModel(coordinator: self)
    vc.viewModel?.delegate = pvc.viewModel
    
    vc.modalPresentationStyle = .overFullScreen
    self.navigationController.present(vc, animated: false, completion: nil)
  }
  
  func hideLabelPopUp() {
    self.navigationController.dismiss(animated: false)
  }
}

