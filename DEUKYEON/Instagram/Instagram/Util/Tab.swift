//
//  Tab.swift
//  Instagram
//
//  Created by 황득연 on 2023/02/04.
//

/// TabController 하단 Tab Type
///  1. list : 인스타그램 같은 리스트 뷰
///  2. search : 검색 뷰
///  3. mypage: 보관함 뷰
enum Tab: String, CaseIterable {
  case list
  case search
  case mypage
  
  init?(idx: Int) {
    switch idx {
    case 0: self = .list
    case 1: self = .search
    case 2: self = .mypage
    default: return nil
    }
  }
  
  func pageOrderNumber() -> Int {
    switch self {
    case .list: return 0
    case .search: return 1
    case .mypage: return 2
    }
  }
  
  func tabIconSelected() -> String {
    switch self {
    case .list: return "homeActive"
    case .search: return "searchActive"
    case .mypage: return "mypageActive"
    }
  }
  
  func tabIconUnselected() -> String {
    switch self {
    case .list: return "homeInactive"
    case .search: return "searchInactive"
    case .mypage: return "mypageInactive"
    }
  }
  
  func tabName() -> String {
    switch self {
    case .list: return "목록"
    case .search: return "검색"
    case .mypage: return "마이"
    }
  }
}
