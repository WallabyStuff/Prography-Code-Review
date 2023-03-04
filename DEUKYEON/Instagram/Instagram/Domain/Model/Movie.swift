//
//  Movie.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

import Foundation

struct Movie {
  let id: Int
  let title: String
  let rating: Double
  let summary: String
  let description: String
  let imageURL: String
  let year: Int
  let runtime: Int
  let genres: String
  let diff: String?
  
  static let empty = Movie(id: 0, title: "", rating: 0, summary: "", description: "", imageURL: "", year: 0, runtime: 0, genres: "", diff: "")
}

extension Movie {
  // Entity(Realm)에 저장하기 위한 매핑
  func toEntity() -> MovieEntity {
    MovieEntity(movieId: self.id,
                title: self.title,
                rating: self.rating,
                summary: self.summary,
                content: self.description,
                imageURL: self.imageURL,
                year: self.year,
                runtime: self.runtime,
                genres: self.genres,
                diif: self.diff)
  }
}
