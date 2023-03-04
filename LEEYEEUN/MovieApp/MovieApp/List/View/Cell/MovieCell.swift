//
//  MovieCell.swift
//  MovieApp
//
//  Created by 이예은 on 2023/02/04.
//

import UIKit
import Combine

class MovieCell: UITableViewCell {
    // MARK: - Views
    private lazy var backgroundStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .center, distribution: .fill, spacing: 20)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
        stackView.addArrangedSubviews(sequenceLabel, movieInfoView, posterView)
        return stackView
    }()
    
    private lazy var sequenceLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .preferredFont(for: .title2, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.widthAnchor.constraint(equalToConstant: 30).isActive = true
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var movieInfoView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 20)
        stackView.addArrangedSubviews(titleLabel, movieOtherView)
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "가디언즈 오브 갤럭시"
        label.numberOfLines = 2
        label.font = .preferredFont(for: .body, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var movieOtherView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 2)
        stackView.addArrangedSubviews(openDateLabel, runningTimeLabel)
        return stackView
    }()
    
    private lazy var openDateLabel: UILabel = {
        let label = UILabel()
        label.text = "개봉 2023"
        label.font = .preferredFont(for: .footnote, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var runningTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "120분"
        label.font = .preferredFont(for: .footnote, weight: .regular)
        label.textColor = .white
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private lazy var posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    
    // MARK: - override
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Set UI
    func setup(_ movie: Movie?, index: Int) {
        guard let movie = movie else {
            return
        }
        
        titleLabel.text = movie.title
        openDateLabel.text = "개봉 \(movie.year)"
        sequenceLabel.text = "\(index + 1)"
        posterView.setImage(with: movie.smallCoverImage)
        
        if movie.runtime == 0 {
            runningTimeLabel.text = "-"
        } else {
            runningTimeLabel.text = "\(movie.runtime)분"
        }
    }
}

// MARK: - Private Actions
private extension MovieCell {
    func configure() {
        selectionStyle = .none
        contentView.backgroundColor = .boBackground
        contentView.addSubviews(backgroundStackView)
        
        NSLayoutConstraint.activate([
            backgroundStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func reset() {
        sequenceLabel.text = nil
        titleLabel.text = nil
        openDateLabel.text = nil
        runningTimeLabel.text = nil
        posterView.image = nil
    }
}

