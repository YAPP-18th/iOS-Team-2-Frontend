//
//  MapSearchResultViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/06/25.
//

import Foundation

import RxCocoa
import RxSwift

class MapSearchResultViewModel: ViewModel, ViewModelType {
  
  var place: Place
  
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  init(place: Place) {
    self.place = place
  }
  
  func transform(input: Input) -> Output {
    return .init()
  }
}
  
