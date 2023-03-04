//
//  MovieDetailViewController.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import UIKit
import RxSwift
import SnapKit
import Then
import Kingfisher

final class MovieDetailViewController: UIViewController {
  // MARK: - Vars & Lets
  var viewModel: MovieDetailViewModel!
  let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let scrollView = UIScrollView().then {
    $0.showsVerticalScrollIndicator = false
  }
  
  private let containerView = UIView()
  private let imageView = UIImageView().then { $0.contentMode = .scaleAspectFit }
  private let scoreLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 20, weight: .regular)
  }
  private let runtimeLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 20, weight: .regular)
  }
  private let yearLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 20, weight: .regular)
  }
  private let genresLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 20, weight: .regular)
    $0.numberOfLines = 2
  }
  private let descriptionLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 18, weight: .regular)
    $0.numberOfLines = 0
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
    
    self.view.addSubview(self.scrollView)
    self.scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.scrollView.addSubview(self.containerView)
    self.containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalToSuperview()
    }
    
    self.containerView.addSubview(self.imageView)
    self.imageView.snp.makeConstraints {
      $0.left.right.top.equalToSuperview()
      $0.height.equalTo(400)
    }
    
    self.containerView.addSubview(self.scoreLabel)
    self.scoreLabel.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(20)
      $0.top.equalTo(self.imageView.snp.bottom).offset(10)
    }
    
    self.containerView.addSubview(self.yearLabel)
    self.yearLabel.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(20)
      $0.top.equalTo(self.scoreLabel.snp.bottom).offset(20)
    }
    
    self.containerView.addSubview(self.runtimeLabel)
    self.runtimeLabel.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(20)
      $0.top.equalTo(self.yearLabel.snp.bottom).offset(20)
    }
    
    self.containerView.addSubview(self.genresLabel)
    self.genresLabel.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(20)
      $0.top.equalTo(self.runtimeLabel.snp.bottom).offset(20)
    }
    
    self.containerView.addSubview(self.descriptionLabel)
    self.descriptionLabel.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(20)
      $0.top.equalTo(self.genresLabel.snp.bottom).offset(20)
      $0.bottom.equalToSuperview().offset(-20)
    }
  }
  
  private func configureNavigation() {
    self.setBackButton()
  }
  
  // MARK: - Bind ViewModel
  private func bindViewModel() {
    self.bindOutput()
  }
  
  private func bindOutput() {
    let output = self.viewModel.output
    
    output.movieDetail
      .subscribe(onNext: { [weak self] movieDetail in
        self?.configureUIContent(movieDetail: movieDetail)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func configureUIContent(movieDetail: Movie) {
    self.navigationItem.title = movieDetail.title
    self.imageView.kf.setImage(with: URL(string: movieDetail.imageURL), placeholder: UIImage(named: "noImage"))
    self.scoreLabel.text = "Score: \(movieDetail.rating)"
    self.runtimeLabel.text = "Runtime: \(movieDetail.runtime) minutes"
    self.yearLabel.text = "Year: \(movieDetail.year)"
    self.genresLabel.text = "Genres: \(movieDetail.genres)"
    self.descriptionLabel.text = movieDetail.description
  }
}
