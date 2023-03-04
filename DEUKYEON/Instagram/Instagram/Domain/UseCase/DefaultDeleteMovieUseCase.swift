//
//  DefaultDeleteMovieUseCase.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/05.
//

protocol DeleteMovieUseCase {
  func excute(movie: Movie)
}

final class DefaultDeleteMovieUseCase: DeleteMovieUseCase {
  
  private let storage: Storage
  
  init(storage: Storage) {
    self.storage = storage
  }
  
  func excute(movie: Movie) {
    self.storage.deleteMovie(movie: movie)
  }
}
