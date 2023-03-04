//
//  FirstCellTableViewCell.swift
//  MovieApp
//
//  Created by 이예은 on 2023/02/05.
//

import UIKit

//
//  FirstCell.swift
//  BoxOffice
//
//  Created by 이예은 on 2023/01/03.
//

import UIKit

class FirstCell: UITableViewCell {
    // MARK: - Views
    private lazy var posterImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .darkGray
        view.heightAnchor.constraint(equalToConstant: 325).isActive = true
        return view
    }()
    
    private lazy var titlegenreStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .leading
        stackview.distribution = .equalSpacing
        stackview.spacing = 2
        return stackview
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.numberOfLines = 2
        label.text = "가디언즈 오브 갤럭시"
        return label
    }()
    
    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .white
        label.text = "호러"
        return label
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // MARK: - Overrides
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        contentView.backgroundColor = .boBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    func transferData(_ movie: Movie) {
        posterImageView.setImage(with: movie.largeCoverImage)
        titleLabel.text = movie.title
        genreLabel.text = movie.genres.first ?? "호러"
    }
}

// MARK: - Private Actions
private extension FirstCell {
    func configure() {
        contentView.addSubviews(posterImageView, titlegenreStackView, shareButton)
        titlegenreStackView.addArrangedSubviews(titleLabel, genreLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 64),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -64)
        ])
        
        NSLayoutConstraint.activate([
            titlegenreStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 29),
            titlegenreStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titlegenreStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            shareButton.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 34),
            shareButton.leadingAnchor.constraint(equalTo: titlegenreStackView.trailingAnchor, constant: 20),
            shareButton.heightAnchor.constraint(equalToConstant: 20),
            shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    func reset() {
        posterImageView.image = nil
        titleLabel.text = nil
        genreLabel.text = nil
    }
}

