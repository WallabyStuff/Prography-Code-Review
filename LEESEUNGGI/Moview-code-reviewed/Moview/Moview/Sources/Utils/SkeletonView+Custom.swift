//
//  SkeletonView+Custom.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import SkeletonView

extension UIView {
  func showCustomSkeleton() {
    let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topLeftBottomRight)
    let gradient = SkeletonGradient(baseColor: R.color.backgroundBlackLighter()!,
                                    secondaryColor: R.color.backgroundBlack()!)
    showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
  }
}

