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
    let storeInfo: BehaviorRelay<Place>
  }
  
  init(place: Place) {
    self.place = place
  }
  
  func transform(input: Input) -> Output {
    let storeInfo = BehaviorRelay<Place>(value: self.place)
    PostData.shared.place = self.place
    return .init(
      storeInfo: storeInfo
    )
  }
}
  
