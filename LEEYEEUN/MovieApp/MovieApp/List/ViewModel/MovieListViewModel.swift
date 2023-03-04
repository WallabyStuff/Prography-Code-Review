//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by 이예은 on 2023/02/05.
//

import UIKit
import Combine

// MARK: - Input, Output
protocol MovieListViewModelInput {
    func viewDidLoad()
}

protocol MovieListViewModelOutput {
    var model: [Movie] { get }
    var _model: PassthroughSubject<[Movie], Never> { get }
}

protocol MovieListViewModelInterface {
    var input: MovieListViewModelInput { get }
    var output: MovieListViewModelOutput { get }
}

class MovieListViewModel: MovieListViewModelInterface, MovieListViewModelInput, MovieListViewModelOutput {
    // MARK: - Properties
    var input: MovieListViewModelInput { self }
    var output: MovieListViewModelOutput { self }
    var model: [Movie] = []
    var _model = PassthroughSubject<[Movie], Never>()
    
    // MARK: - Life Cycles
    func viewDidLoad() {
        guard let url = URL(string: "https://yts.mx/api/v2/list_movies.json?sort=year&limit=50") else { return }
        
        NetworkManager.shared.execute(url: url) { movies in
            self.model = movies
            self._model.send(movies)
        }
        
    }
}
