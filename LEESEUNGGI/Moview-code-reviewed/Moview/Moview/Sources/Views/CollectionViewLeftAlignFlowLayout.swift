//
//  CollectionViewLeftAlignFlowLayout.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import UIKit

class GenreCollectionFlowLayout: UICollectionViewFlowLayout {
  
  // MARK: - Constants
  
  struct Metric {
    static let itemSpacing = 8.f
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    self.minimumLineSpacing = 10.0
    self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0.0, right: 0)
    let attributes = super.layoutAttributesForElements(in: rect)
    
    var leftMargin = sectionInset.left
    var maxY: CGFloat = -1.0
    attributes?.forEach { layoutAttribute in
      if layoutAttribute.frame.origin.y >= maxY {
        leftMargin = sectionInset.left
      }
      layoutAttribute.frame.origin.x = leftMargin
      leftMargin += layoutAttribute.frame.width + Metric.itemSpacing
      maxY = max(layoutAttribute.frame.maxY, maxY)
    }
    return attributes
  }
}
