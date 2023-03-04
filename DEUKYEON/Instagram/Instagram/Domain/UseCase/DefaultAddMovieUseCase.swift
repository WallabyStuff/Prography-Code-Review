//
//  DefaultAddMovieUseCase.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/05.
//

protocol AddMovieUseCase {
  func excute(movie: Movie)
}

final class DefaultAddMovieUseCase: AddMovieUseCase {
  
  private let storage: Storage
  
  init(storage: Storage) {
    self.storage = storage
  }
  
  func excute(movie: Movie) {
    self.storage.addMovie(movie: movie)
  }
}
