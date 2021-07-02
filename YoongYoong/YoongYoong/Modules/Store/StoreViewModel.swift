//
//  StoreViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/02.
//

import UIKit
import RxSwift
import RxCocoa

class StoreViewModel: ViewModel, ViewModelType {
  let place: Place
  
  init(place: Place) {
    self.place = place
  }
  
  struct Input {
    
  }
  
  struct Output {
    let place: Driver<Place>
  }
  
  func transform(input: Input) -> Output {
    return .init(
      place: .just(self.place)
    )
  }
}
