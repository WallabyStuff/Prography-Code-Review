//
//  SecondCell.swift
//  MovieApp
//
//  Created by 이예은 on 2023/02/05.
//

import UIKit

class SecondCell: UITableViewCell {
    // MARK: - Views
    private lazy var rankingattendancestarsStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .fill
        stackview.spacing = 60
        return stackview
    }()
    
    private lazy var releaseYearStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .center
        stackview.distribution = .fill
        stackview.spacing = 4
        return stackview
    }()
    
    private lazy var releaseYearLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.text = "2020년"
        return label
    }()
    
    private lazy var yearInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .gray
        label.text = "개봉년도"
        return label
    }()
    
    private lazy var runningTimeStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .center
        stackview.distribution = .fill
        stackview.spacing = 4
        return stackview
    }()
    
    private lazy var runningTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.text = "100분"
        return label
    }()
    
    private lazy var runningTimeInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .gray
        label.text = "상영 시간"
        return label
    }()
    
    private lazy var rankingStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .center
        stackview.distribution = .fill
        stackview.spacing = 4
        return stackview
    }()
    
    private lazy var rankingLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.text = "5.0"
        return label
    }()
    
    private lazy var rankingInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .gray
        label.text = "랭킹"
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
        releaseYearLabel.text = "\(movie.year)"
        runningTimeLabel.text = "\(movie.runtime)분"
        rankingLabel.text = "\(movie.rating)"
    }
}

// MARK: - Private Actions
private extension SecondCell {
    func configure() {
        contentView.addSubviews(rankingattendancestarsStackView)
        
        releaseYearStackView.addArrangedSubviews(releaseYearLabel, yearInfoLabel)
        runningTimeStackView.addArrangedSubviews(runningTimeLabel, runningTimeInfoLabel)
        rankingStackView.addArrangedSubviews(rankingLabel, rankingInfoLabel)
        rankingattendancestarsStackView.addArrangedSubviews(releaseYearStackView, runningTimeStackView, rankingStackView)
        
        NSLayoutConstraint.activate([
            rankingattendancestarsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            rankingattendancestarsStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            rankingattendancestarsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func reset() {
        releaseYearLabel.text = nil
        runningTimeLabel.text = nil
        rankingLabel.text = nil
    }
}

