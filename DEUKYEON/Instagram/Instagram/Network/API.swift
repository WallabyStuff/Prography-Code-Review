//
//  API.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import Moya
import Alamofire

// Moya + Alamofire를 통해 네트워크 통신 구현
enum API {
  case fetchMovieList(limit: Int?, page: Int?, searchWord: String?, sort: String?, order: String?)
}

extension API: TargetType {
  public var baseURL: URL {
    URL(string: "https://yts.lt/api/v2")!
  }
  
  // MARK: - Path
  var path: String {
    switch self {
    case .fetchMovieList:
      return "/list_movies.json"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .fetchMovieList:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case let .fetchMovieList(limit, page, searchWord, sort, order):
      var params: Parameters = [:]
      params["limit"] = limit
      params["page"] = page
      params["query_term"] = searchWord
      params["sort_by"] = sort
      params["order_by"] = order
      return .requestParameters(parameters: params, encoding: URLEncoding.init(destination: .queryString, arrayEncoding: .noBrackets, boolEncoding: .literal))
    }
  }
  
  var headers: [String: String]? {
    return nil
  }
}
