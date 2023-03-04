//
//  YTSApiService.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import UIKit

import Alamofire
import SwiftyJSON

import RxSwift

class YTSApiService {
  
  // MARK: - Properties
  
  static let basePath = "https://yts.mx/api/v2"
  private var disposeBag = DisposeBag()
  static let MINIMUM_TERM_LENGHT = 2
  
  enum YTSApiServiceError: Error {
    case lessThenMinimumTermLength
  }
  
  
  // MARK: - Methods
  
  public func getMovieList() -> Single<[Movie]> {
    return Single.create { observer in
      let url = Self.basePath + "/list_movies.json?limit=50"
      
      AF.request(url,
                 method: .get,
                 parameters: nil,
                 encoding: URLEncoding.default,
                 headers: ["Content-Type":"application/json", "Accept":"application/json"])
      .validate(statusCode: 200..<300)
      .responseData { response in
        switch response.result {
        case .success(let result):
          let object = JSON(result)
          let data = object["data"]
          let moviesData = data["movies"]
          var movies = [Movie]()

          for (_, movieObject) in moviesData {
            let movie = Movie(
              id: movieObject["id"].description,
              title: movieObject["title"].description,
              rating: Float(movieObject["rating"].description) ?? 0,
              runtime: Int(movieObject["runtime"].description) ?? 0,
              genres: movieObject["genres"].map { $0.1.description },
              description_full: movieObject["description_full"].description,
              medium_cover_image: movieObject["medium_cover_image"].description,
              large_cover_image: movieObject["large_cover_image"].description
            )
            movies.append(movie)
          }

          observer(.success(movies))
        case .failure(let error):
          observer(.failure(error))
        }
      }
      
      return Disposables.create()
    }
  }
  
  public func searchMovie(term: String) -> Single<[Movie]> {
    return Single.create { observer in
      if term.count < Self.MINIMUM_TERM_LENGHT {
        observer(.failure(YTSApiServiceError.lessThenMinimumTermLength))
        return Disposables.create()
      }
      
      let url = Self.basePath + "/list_movies.json?query_term=\(term.modifiedTerm())"
      AF.request(url,
                 method: .get,
                 parameters: nil,
                 encoding: URLEncoding.default,
                 headers: ["Content-Type":"application/json", "Accept":"application/json"])
      .validate(statusCode: 200..<300)
      .responseData { response in
        switch response.result {
        case .success(let result):
          let object = JSON(result)
          let data = object["data"]
          let moviesData = data["movies"]
          var movies = [Movie]()

          for (_, movieObject) in moviesData {
            let movie = Movie(
              id: movieObject["id"].description,
              title: movieObject["title"].description,
              rating: Float(movieObject["rating"].description) ?? 0,
              runtime: Int(movieObject["runtime"].description) ?? 0,
              genres: movieObject["genres"].map { $0.1.description },
              description_full: movieObject["description_full"].description,
              medium_cover_image: movieObject["medium_cover_image"].description,
              large_cover_image: movieObject["large_cover_image"].description
            )
            movies.append(movie)
          }

          observer(.success(movies))
        case .failure(let error):
          observer(.failure(error))
        }
      }
      
      return Disposables.create()
    }
  }
}

private extension String {
  func modifiedTerm() -> String {
    return self.replacingOccurrences(of: " ", with: "+")
  }
}
