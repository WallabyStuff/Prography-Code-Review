//
//  MyPageViewController.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/05.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class MyPageViewController: UIViewController {
  
  // MARK: - Vars & Lets
  var viewModel: MyPageViewModel!
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayout.listLayoutInSearch).then {
    $0.register(MovieListCell.self, forCellWithReuseIdentifier: String(describing: MovieListCell.description))
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  
  // MARK: - Configure UI
  private func configureUI() {
    self.configureNavigation()
    self.view.backgroundColor = .white
    
    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func configureNavigation() {
    self.setBackButton()
    self.setNavigationTitle(title: "보관함")
  }
  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    self.bindInput()
    self.bindOutput()
  }
  
  private func bindInput() {
    let input = self.viewModel.input
    
    self.collectionView.rx.itemSelected.map { $0.row}
      .bind(to: input.movieDidTapEvent)
      .disposed(by: self.disposeBag)
  }
  
  private func bindOutput() {
    let input = self.viewModel.input
    let output = self.viewModel.output
    
    output.movieList
      .bind(to: self.collectionView.rx.items(cellIdentifier: MovieListCell.description, cellType: MovieListCell.self)) { row, movie, cell in
        cell.updateUI(movie: movie, canDelete: true)
        cell.clickOption()
          .subscribe(onNext: {
            input.deleteButtonDidTapEvent.accept(row)
          })
          .disposed(by: cell.disposeBag)
      }
      .disposed(by: self.disposeBag)
  }
}
