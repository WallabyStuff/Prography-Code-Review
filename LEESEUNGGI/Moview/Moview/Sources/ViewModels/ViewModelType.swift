//
//  ViewModelType.swift
//  Moview
//
//  Created by Wallaby on 2023/02/05.
//

import Foundation

import RxSwift

protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  
  var input: Input! { get }
  var output: Output! { get }
  
  var disposeBag: DisposeBag { get }
}

