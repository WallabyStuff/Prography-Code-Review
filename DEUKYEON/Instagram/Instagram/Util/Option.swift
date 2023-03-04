//
//  Option.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

/// 검색 옵션
///  sort 종류 : `날짜`, `이름`, `좋아요`, `별점`
///  order 종류 :  `내림차순`, `오름차순`
///  총 8가지 조합
enum Option: Int, CaseIterable {
  case dateDesc, dateAsc, titleAsc, titleDesc, likeDesc, likeAsc, rateDesc, rateAsc
  
  var description: String {
    switch self {
    case .dateDesc:
      return "최신순"
    case .dateAsc:
      return "오래된순"
    case .titleAsc:
      return "이름순"
    case .titleDesc:
      return "이름역순"
    case .likeDesc:
      return "좋아요 많은순"
    case .likeAsc:
      return "좋아요 적은순"
    case .rateDesc:
      return "별점 높은순"
    case .rateAsc:
      return "별점 낮은순"
    }
  }
  
  /// Request Query를 위함
  var sort: String {
    switch self {
    case .dateDesc, .dateAsc:
      return "date_added"
    case .titleAsc, .titleDesc:
      return "title"
    case .likeDesc, .likeAsc:
      return "like_count"
    case .rateDesc, .rateAsc:
      return "rating"
    }
  }
  
  /// Request Query를 위함
  var order: String {
    switch self {
    case .dateDesc, .titleDesc, .likeDesc, .rateDesc:
      return "desc"
    case .dateAsc, .titleAsc, .likeAsc, .rateAsc:
      return "asc"
    }
  }
  
}
