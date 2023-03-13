//
//  MovieBookmark.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import Foundation

import RealmSwift
import RxDataSources

class MovieBookmark: Object {
  
  static let genreArraySeparator = "/"
  
  @objc dynamic var id: String = ""
  @objc dynamic var title: String = ""
  @objc dynamic var rating: Float = 0
  @objc dynamic var runtime: Int = 0
  @objc dynamic var genres: String = ""
  @objc dynamic var description_full: String = ""
  @objc dynamic var medium_cover_image: String = ""
  @objc dynamic var large_cover_image: String = ""
  
  convenience init(id: String,
       title: String,
       rating: Float,
       runtime: Int,
       genres: String,
       description_full: String,
       medium_cover_image: String,
       large_cover_image: String) {
    self.init()
    self.id = id
    self.title = title
    self.rating = rating
    self.runtime = runtime
    self.genres = genres
    self.description_full = description_full
    self.medium_cover_image = medium_cover_image
    self.large_cover_image = large_cover_image
  }
  
  override class func primaryKey() -> String? {
    return "id"
  }
}

extension MovieBookmark: IdentifiableType {
  typealias Identity = String
  
  var identity: String {
    if isInvalidated {
      return UUID().uuidString
    } else {
      return id
    }
  }
}

extension MovieBookmark {
  func toMovieType() -> Movie {
    return Movie(
      id: id,
      title: title,
      rating: rating,
      runtime: runtime,
      genres: genres.components(separatedBy: ","),
      description_full: description_full,
      medium_cover_image: medium_cover_image,
      large_cover_image: large_cover_image)
  }
}
