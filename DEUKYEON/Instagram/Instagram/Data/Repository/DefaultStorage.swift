//
//  DefaultStorage.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/05.
//

import RxSwift
import RealmSwift

protocol Storage {
  func fetchMovieList() -> Observable<[Movie]>
  func addMovie(movie: Movie)
  func deleteMovie(movie: Movie)
}

final class DefaultStorage: Storage {
  
  // 싱글톤 구현
  static let shared = DefaultStorage()
  let realm = try! Realm()
  
  private init() {}
  
  // 저장된 MovieList 불러오기
  func fetchMovieList() -> Observable<[Movie]> {
    let movieList = realm.objects(MovieListEntity.self).map { $0.asDomain() }.first
    
    return Observable.create { observer in
      observer.onNext(movieList ?? [])
      return Disposables.create()
    }
  }
  
  // Movie 저장
  func addMovie(movie: Movie) {
    // 기존에 이미 같은 id의 Movie가 존재하는 경우 저장 안함
    let movieIfExisted = realm.objects(MovieEntity.self).filter( "movieId == \(movie.id)").first
    
    if let _ = movieIfExisted {
      return
    }
    
    let movieList = realm.objects(MovieListEntity.self).first
    
    try! realm.write {
      guard let movieList = movieList else {
        let movieListNew = MovieListEntity()
        movieListNew.movieList.append(objectsIn: [movie.toEntity()])
        self.realm.add(movieListNew)
        return
      }
      movieList.movieList.append(objectsIn: [movie.toEntity()])
      self.realm.add(movieList, update: .modified)
    }
  }
  
  // Movie 삭제
  func deleteMovie(movie: Movie) {
    let movie = realm.objects(MovieEntity.self).filter( "movieId == \(movie.id)").first
    guard let movie = movie else { return }
    try! self.realm.write {
      self.realm.delete(movie)
    }
  }
}
