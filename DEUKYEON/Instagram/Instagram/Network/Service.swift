//
//  Service.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import RxSwift
import Moya
import Alamofire

final class Service {
  
  // 싱글톤 구현
  static let shared = Service()
  private let provider = MoyaProvider<API>()

  private init() {}
  
  // Moya + RxSwift
  func requestMovieList(_ target: API) -> Observable<[MovieResponseDTO]> {
    return provider.rx.request(target)
      .asObservable()
      .filterSuccessfulStatusCodes()
      .map { try JSONDecoder().decode(ResponseObject.self, from: $0.data ) }
      .compactMap { $0.data.movies }
  }
}
