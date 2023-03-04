//
//  MovieListEntity.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/05.
//

import RealmSwift
import Realm

class MovieListEntity: Object {
  @Persisted(primaryKey: true) var id: ObjectId
  @Persisted var movieList = List<MovieEntity>()
}

extension MovieListEntity {
  // Domain으로 가져오기 위한 매핑
  func asDomain() -> [Movie] {
    return movieList.map { $0.asDomain() }
  }
}
