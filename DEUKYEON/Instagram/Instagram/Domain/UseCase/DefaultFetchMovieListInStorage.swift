//
//  DefaultFetchMoviesInStorage.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/05.
//

import RxSwift

protocol FetchMoviesInStorage {
  func excute() -> Observable<[Movie]>
}

final class DefaultFetchMovieListInStorage: FetchMoviesInStorage {
  
  private let storage: Storage
  
  init(storage: Storage) {
    self.storage = storage
  }
  
  func excute() -> Observable<[Movie]> {
    self.storage.fetchMovieList()
  }
}
