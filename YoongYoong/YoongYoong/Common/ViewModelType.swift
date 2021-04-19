//
//  ViewModelType.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/17.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  
  func transform(input: Input) -> Output
}

class ViewModel: NSObject {
  let disposeBag = DisposeBag()
  var locationManager: LocationService
  
  init(locationManager: LocationService = LocationManager.shared) {
    self.locationManager = locationManager
  }
}
