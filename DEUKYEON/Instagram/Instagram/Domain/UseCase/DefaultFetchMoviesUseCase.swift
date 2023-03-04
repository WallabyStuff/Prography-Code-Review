//
//  DefaultFetchMovieListUseCase.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import RxSwift

protocol FetchMovieListUseCase {
  func excute(limit: Int?, page: Int?, searchWord: String?, sort: String?, order: String?) -> Observable<[Movie]>
}

final class DefaultFetchMovieListUseCase: FetchMovieListUseCase {
  
  private let repository: Repository
  
  init(repository: Repository) {
    self.repository = repository
  }
  
  func excute(limit: Int?, page: Int?, searchWord: String?, sort: String?, order: String?) -> Observable<[Movie]> {
    self.repository.fetchMovieList(limit: limit, page: page, searchWord: searchWord, sort: sort, order: order)
  }
}
