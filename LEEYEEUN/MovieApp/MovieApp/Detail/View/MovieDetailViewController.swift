//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by 이예은 on 2023/02/05.
//

import UIKit
import Combine

class MovieDetailViewController: UIViewController {
    // MARK: - Properties
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .boBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return tableView
    }()
    let viewModel: MovieDetailViewModel
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind()
    }
}

// MARK: - Private Actions
private extension MovieDetailViewController {
    func setup() {
        self.view.backgroundColor = .boBackground
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FirstCell)
        tableView.register(SecondCell)
        tableView.register(ThirdCell)
//        tableView.register(FirstCell.self, forCellReuseIdentifier: "FirstCell")
//        tableView.register(SecondCell.self, forCellReuseIdentifier: "SecondCell")
//        tableView.register(ThirdCell.self, forCellReuseIdentifier: "ThirdCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func bind() {
        viewModel.output.shareMovieInfoPublisher
            .sink { [weak self] information in
                guard let self = self else { return }
                let activityController = UIActivityViewController(
                    activityItems: information,
                    applicationActivities: nil
                )
                self.present(activityController, animated: true)
            }
            .store(in: &cancellable)
    }
    
    func setUpShareButton(_ cell: FirstCell) {
        cell.shareButton.addTarget(self, action: #selector(didTapShareButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTapShareButton(_ sender: UIButton) {
        viewModel.input.didTapShareButton()
    }
}

// MARK: - TableViewDataSource, TableViewDelegate
extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(FirstCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            cell.transferData(viewModel.model)
            setUpShareButton(cell)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(SecondCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            cell.transferData(viewModel.model)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(ThirdCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            cell.transferData(viewModel.model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
