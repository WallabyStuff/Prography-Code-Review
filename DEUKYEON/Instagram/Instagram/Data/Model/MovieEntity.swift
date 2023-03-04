//
//  MovieEntity.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/05.
//

import RealmSwift
import Realm

class MovieEntity: Object {
  @Persisted(primaryKey: true) var id: ObjectId
  @Persisted var movieId: Int
  @Persisted var title: String
  @Persisted var rating: Double
  @Persisted var summary: String
  @Persisted var content: String
  @Persisted var imageURL: String
  @Persisted var year: Int
  @Persisted var runtime: Int
  @Persisted var genres: String?
  @Persisted var diff: String?
  
  convenience init(movieId: Int, title: String, rating: Double, summary: String, content: String, imageURL: String, year: Int, runtime: Int, genres: String?, diif: String?) {
    
    self.init()
    self.movieId = movieId
    self.title = title
    self.rating = rating
    self.summary = summary
    self.content = content
    self.imageURL = imageURL
    self.year = year
    self.runtime = runtime
    self.genres = genres
    self.diff = diif
  }
}

extension MovieEntity {
  // Domain으로 가져오기 위한 매핑
  func asDomain() -> Movie {
    return Movie(id: self.movieId,
                 title: self.title,
                 rating: self.rating,
                 summary: self.summary,
                 description: self.content,
                 imageURL: self.imageURL,
                 year: self.year,
                 runtime: self.runtime,
                 genres: self.genres ?? "",
                 diff: self.diff)
  }
}
