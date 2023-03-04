//
//  MovieResponseDTO.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

/// `id` : 고유 ID
/// `title` : 영화 제목
/// `rating` : 영화 평점
/// `summary`: 영화 내용 요약
/// `description_full`: 영화 내용
/// `large_cover_image` : imageURL
/// `year`: 출시년도
/// `runtime`: 상영시간
/// `genres`: 장르 리스트
/// `date_uploaded`: 업로드된 날짜
struct MovieResponseDTO: Decodable {
  let id: Int
  let title: String
  let rating: Double
  let summary: String
  let description_full: String
  let large_cover_image: String
  let year: Int
  let runtime: Int
  let genres: [String]?
  let date_uploaded: String?
}

extension MovieResponseDTO {
  func toDomain() -> Movie {
    Movie(id: self.id,
          title: self.title,
          rating: self.rating,
          summary: self.summary,
          description: self.description_full,
          imageURL: self.large_cover_image,
          year: self.year,
          runtime: self.runtime,
          genres: genresString(genres: self.genres),
          diff: self.date_uploaded == nil ? "" : self.date_uploaded!.toDiff())
  }
  
  /// 서버에서 주는 리스트 형식인 `["장르1", "장르2"]` -> `"장르1, 장르2"` 로 수정
  func genresString(genres: [String]?) -> String {
    guard let genres = genres else { return ""}
    return genres.joined(separator: ", ")
  }
}
