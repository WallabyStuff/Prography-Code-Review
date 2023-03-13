//
//  Moview.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import Foundation

struct Movie: Codable {
  var id: String
  var title: String
  var rating: Float
  var runtime: Int
  var genres: [String]
  var description_full: String
  var medium_cover_image: String
  var large_cover_image: String
}

extension Movie {
  public static func fakeItem() -> Movie {
    return .init(
      id: UUID().uuidString,
      title: "",
      rating: 0,
      runtime: 0,
      genres: [],
      description_full: "",
      medium_cover_image: "",
      large_cover_image: "")
  }
}

extension Movie {
  public func toMovieBookmarkType() -> MovieBookmark {
    return MovieBookmark(
      id: id,
      title: title,
      rating: rating,
      runtime: runtime,
      genres: genres.joined(separator: MovieBookmark.genreArraySeparator),
      description_full: description_full,
      medium_cover_image: medium_cover_image,
      large_cover_image: large_cover_image)
  }
}
