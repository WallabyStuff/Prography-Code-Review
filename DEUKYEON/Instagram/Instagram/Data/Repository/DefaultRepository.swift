//
//  DefaultRepository.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import RxSwift

protocol Repository {
  func fetchMovieList(limit: Int?, page: Int?, searchWord: String?, sort: String?, order: String?) -> Observable<[Movie]>
}

final class DefaultRepository: Repository {
  
  // 싱글톤 구현
  static let shared = DefaultRepository(service: Service.shared)
  private let service: Service
  
  private init(service: Service) {
    self.service = service
  }
  
  // 매핑
  func fetchMovieList(limit: Int?, page: Int?, searchWord: String?, sort: String?, order: String?) -> Observable<[Movie]> {
    self.service.requestMovieList(.fetchMovieList(limit: limit, page: page, searchWord: searchWord, sort: sort, order: order))
      .map { $0.map { $0.toDomain() } }
  }
}
