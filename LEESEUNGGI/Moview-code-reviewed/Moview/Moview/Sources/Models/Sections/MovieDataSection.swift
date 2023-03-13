//
//  MovieDataSection.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import RxDataSources

struct MovieDataSection {
  var items: [Item]
  
  init(items: [Item]) {
    self.items = items
  }
}

extension MovieDataSection: SectionModelType {
  typealias Item = Movie
  
  init(original: MovieDataSection, items: [Movie]) {
    self = original
    self.items = items
  }
}
