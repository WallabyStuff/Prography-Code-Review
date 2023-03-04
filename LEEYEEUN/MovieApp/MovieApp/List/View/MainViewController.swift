//
//  MainViewController.swift
//  MovieApp
//
//  Created by 이예은 on 2023/02/04.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 130
        tableView.backgroundColor = .boBackground
        tableView.register(MovieCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var movie: [Movie] = []
    private let viewModel = MovieListViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        viewModel.input.viewDidLoad()
        setUpNavigationBar()
        setUpView()
    }
}

// MARK: - Private Actions
private extension MainViewController {
    func bind() {
        viewModel.output._model
            .sink { [weak self] movies in
                guard let self = self else { return }
                
                self.tableView.reloadData()
            }
            .store(in: &cancellable)
    }
    
    func setUpNavigationBar() {
        navigationItem.title = "Movie Office"
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let backButton = UIBarButtonItem(title: "목록", style: .plain, target: self, action: nil)
        backButton.tintColor = .white
        self.navigationItem.backBarButtonItem = backButton
    }
    
    func setUpView() {
        view.backgroundColor = .boBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - TableViewDataSource, TableViewDelegate
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(MovieCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        
        cell.setup(viewModel.model[indexPath.row], index: indexPath.row)
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = MovieDetailViewController(viewModel: MovieDetailViewModel(model: viewModel.model[indexPath.row]))
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
