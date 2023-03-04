//
//  MovieCell.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/05.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Kingfisher

final class MovieCell: UICollectionViewCell {
  
  // MARK: - Var $ Let
  static let description = "MovieCell"
  private var isExpaneded = false
  var disposeBag = DisposeBag()
  
  // MARK: - UI
  private let imageView = UIImageView().then { $0.contentMode = .scaleAspectFit}
  private let titleLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 25, weight: .bold)
  }
  
  private let heartButton = UIButton().then {
    $0.setImage(UIImage(named: "heart"), for: .normal)
  }
  
  private let contentLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 16, weight: .regular)
    $0.numberOfLines = 3
  }
  
  private let readMoreButton = UIButton().then {
    $0.setTitle("더보기", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.backgroundColor = .white.withAlphaComponent(0.5)
  }
  
  private let dateLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
  }
  
  private let dividerView = UIView().then {$0.backgroundColor = .black }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
    self.bindUI()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.disposeBag = DisposeBag()
    self.isExpaneded = false
    self.bindUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Configure
  private func configureUI() {
    
    self.contentView.layer.borderWidth = 1
    self.contentView.layer.borderColor = UIColor.lightGray.cgColor
    
    self.contentView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints {
      $0.top.left.equalToSuperview().inset(20)
    }
    
    self.contentView.addSubview(self.heartButton)
    self.heartButton.snp.makeConstraints {
      $0.centerY.equalTo(self.titleLabel)
      $0.right.equalToSuperview().offset(-20)
      $0.size.equalTo(24)
    }
    
    self.contentView.addSubview(self.imageView)
    self.imageView.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(20)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(400)
    }

    self.contentView.addSubview(self.contentLabel)
    self.contentLabel.snp.makeConstraints {
      $0.top.equalTo(self.imageView.snp.bottom).offset(10)
      $0.left.right.equalToSuperview().inset(20)
    }
    
    self.contentView.addSubview(self.readMoreButton)
    self.readMoreButton.snp.makeConstraints {
      $0.top.equalTo(self.contentLabel.snp.bottom).offset(-7)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(30)
    }

    self.contentView.addSubview(self.dateLabel)
    self.dateLabel.snp.makeConstraints {
      $0.top.equalTo(self.readMoreButton.snp.bottom).offset(10)
      $0.left.right.equalTo(self.titleLabel)
      $0.bottom.equalToSuperview().offset(-20)
    }
  }
  
  func updateUI(movie: Movie) {
    self.imageView.kf.setImage(with: URL(string: movie.imageURL), placeholder: UIImage(named: "noImage"))
    self.titleLabel.text = movie.title
    self.dateLabel.text = movie.diff
    self.contentLabel.text = movie.summary
    self.readMoreButton.setTitle("더보기", for: .normal)
    self.contentLabel.numberOfLines = 3
  }
  
  private func bindUI() {
    self.readMoreButton.rx.tap.asObservable()
      .subscribe(onNext: { [weak self] in
        self?.updateDescriptionLabel()
      })
      .disposed(by: self.disposeBag)
  }
  
  // 더보기 또는 숨기기 눌렀을때 Label의 numberOfLines의 변화에 따른 로직
  private func updateDescriptionLabel() {
    self.contentLabel.numberOfLines = self.isExpaneded == true ? 3 : 0
    self.contentLabel.sizeToFit()
    self.isExpaneded = !self.isExpaneded
    self.readMoreButton.snp.updateConstraints {
      $0.top.equalTo(self.contentLabel.snp.bottom).offset(self.isExpaneded ? 0 : -7)
    }
    self.readMoreButton.setTitle(self.isExpaneded ? "숨기기" : "더보기" , for: .normal)
    self.invalidateIntrinsicContentSize()
    self.layoutIfNeeded()
  }
  
  // Cell의 Heart를 누를 시
  func clickHeart() -> Observable<Void> {
    self.heartButton.rx.tap.asObservable()
  }
  
}
