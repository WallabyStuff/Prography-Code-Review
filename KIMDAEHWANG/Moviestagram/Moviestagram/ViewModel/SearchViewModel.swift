//
//  SearchViewModel.swift
//  Moviestagram
//
//  Created by Mason Kim on 2023/02/06.
//

import Foundation

final class SearchViewModel: MovieListViewModelProtocol {
    // MARK: - Properties
    var movies: Observable<[Movie]> = Observable([])
    var networkError: Observable<NetworkError?> = Observable(nil)

    private let movieRemoteRepository: MovieRemoteRepositoryProtocol

    init(movieRemoteRepository: MovieRemoteRepositoryProtocol) {
        self.movieRemoteRepository = movieRemoteRepository
    }

    // MARK: - API
    func searchMovie(with keyword: String) {
        Task {
            let movies = try await movieRemoteRepository.fetchMovie(with: [.search(keyword), .sortByLike])
            self.movies.value = movies
        }
    }
}
