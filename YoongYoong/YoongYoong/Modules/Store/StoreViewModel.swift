//
//  StoreViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/02.
//

import UIKit

class StoreViewModel: ViewModel, ViewModelType {
  let place: Place
  
  init(place: Place) {
    self.place = place
  }
  
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  func transform(input: Input) -> Output {
    return .init()
  }
}
