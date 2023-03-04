//
//  MovieListCell.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Kingfisher

/// `Search`, `MyPage` 탭의 Movie Cell
final class MovieListCell: UICollectionViewCell {
  
  // MARK: - Var $ Let
  static let description = "MovieListCell"
  var disposeBag = DisposeBag()
  
  // MARK: - UI
  private let imageView = UIImageView().then { $0.contentMode = .scaleAspectFit}
  private let titleLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 20, weight: .bold)
  }
  
  private let contentLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 13, weight: .regular)
    $0.numberOfLines = 4
  }
  
  private let scoreLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 14, weight: .regular)
  }
  
  private let optionButton = UIButton().then { $0.setImage(UIImage(named: "btnClose"), for: .normal) }

  private let dividerView = UIView().then {$0.backgroundColor = .black }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.disposeBag = DisposeBag()
  }
  
  // MARK: Configure
  private func configureUI() {
    
    self.contentView.addSubview(self.imageView)
    self.imageView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(20)
      $0.left.equalToSuperview()
      $0.height.equalTo(160)
      $0.width.equalTo(100)
    }
    
    self.contentView.addSubview(self.optionButton)
    self.optionButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.right.equalToSuperview().offset(-10)
      $0.size.equalTo(24)
    }
    
    self.contentView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.optionButton.snp.bottom)
      $0.left.equalTo(self.imageView.snp.right).offset(10)
      $0.right.equalToSuperview().offset(-10)
    }
    
    self.contentView.addSubview(self.scoreLabel)
    self.scoreLabel.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(10)
      $0.left.right.equalTo(self.titleLabel)
    }
    
    self.contentView.addSubview(self.contentLabel)
    self.contentLabel.snp.makeConstraints {
      $0.top.equalTo(self.scoreLabel.snp.bottom).offset(10)
      $0.left.right.equalTo(self.titleLabel)
    }
    
    self.contentView.addSubview(self.dividerView)
    self.dividerView.snp.makeConstraints {
      $0.left.right.bottom.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
  
  func updateUI(movie: Movie, canDelete: Bool) {
    self.imageView.kf.setImage(with: URL(string: movie.imageURL), placeholder: UIImage(named: "noImage"))
    self.titleLabel.text = movie.title
    self.scoreLabel.text = "Score : \(movie.rating)"
    self.contentLabel.text = movie.summary
    self.optionButton.setImage(UIImage(named: canDelete ? "btnClose" : "heart"), for: .normal)
  }
  
  func clickOption() -> Observable<Void> {
    self.optionButton.rx.tap.asObservable()
  }
}
