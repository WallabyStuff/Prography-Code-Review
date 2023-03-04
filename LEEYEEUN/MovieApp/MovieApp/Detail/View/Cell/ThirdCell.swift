//
//  ThirdCell.swift
//  MovieApp
//
//  Created by 이예은 on 2023/02/05.
//

import UIKit

class ThirdCell: UITableViewCell {
    // MARK: - Views
    private lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .white
        label.text = "영화의 줄거리입니다."
        label.numberOfLines = 0
        return label
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
        summaryLabel.text = movie.descriptionFull
    }
}

// MARK: - Private Actions
private extension ThirdCell {
    func configure() {
        contentView.addSubviews(summaryLabel)
        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            summaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            summaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    func reset() {
        summaryLabel.text = nil
    }
}

