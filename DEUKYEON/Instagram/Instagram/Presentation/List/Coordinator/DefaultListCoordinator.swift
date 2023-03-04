//
//  DefaultListCoordinator.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import UIKit

protocol ListCoordinator: MovieDetailCoordinator, OptionPopUpCoordinator, LabelPopUpCoordinator {}

final class DefaultListCoordinator: BaseCoordinator, ListCoordinator {
  
  override init(_ navigationController: UINavigationController) {
    super.init(navigationController)
  }
  
  func start() {
    self.showMovieList()
  }
  
  private func showMovieList() {
    let vc = MovieListViewController()
    vc.viewModel = MovieListViewModel(coordinator: self,
                                      fetchMovieListUseCase: DefaultFetchMovieListUseCase(repository: DefaultRepository.shared),
                                      addMovieUseCase: DefaultAddMovieUseCase(storage: DefaultStorage.shared))
    self.navigationController.pushViewController(vc, animated: true)
  }
  
  
  func showMovieDetail(movie: Movie) {
    let vc = MovieDetailViewController()
    vc.viewModel = MovieDetailViewModel(coordinator: self,
                                        movie: movie)
    vc.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(vc, animated: true)
  }
  
  func showOptionPopUp(with option: Int) {
    guard let pvc = self.navigationController.viewControllers.last as? MovieListViewController else {
      return
    }
    
    let vc = OptionPopupViewController()
    vc.viewModel = OptionPopUpViewModel(coordinator: self, option: option)
    vc.viewModel?.delegate = pvc.viewModel
    
    vc.modalPresentationStyle = .overFullScreen
    self.navigationController.present(vc, animated: false, completion: nil)
  }
  
  func hideOptionPopUp() {
    self.navigationController.dismiss(animated: false)
  }
  
  func showLabelPopUp() {
    guard let pvc = self.navigationController.viewControllers.last as? MovieListViewController else {
      return
    }
    
    let vc = LabelPopUpViewController().then {
      $0.setLabel(content: "해당 영화를 보관하시겠습니까?")
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
