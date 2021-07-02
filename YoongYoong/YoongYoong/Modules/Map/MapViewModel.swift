//
//  MapViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/17.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift

class MapViewModel: ViewModel, ViewModelType {
  struct Input {
    let tip: Observable<Void>
    let myLocation: Observable<Void>
    let search: Observable<Void>
  }
  
  struct Output {
    let tip: Driver<TipViewModel>
    let setting: Observable<Void>
    let appSetting: Observable<Void>
    let location: Driver<CLLocationCoordinate2D>
    let search: Driver<MapSearchViewModel>
  }
  
  var settingTrigger = PublishSubject<Void>()
  var appSettingTrigger = PublishSubject<Void>()
  
  var location = PublishSubject<CLLocationCoordinate2D>()
  
  func transform(input: Input) -> Output {
    let tip = input.tip.asDriver(onErrorJustReturn: ()).map { () -> TipViewModel in
      let viewModel = TipViewModel()
      return viewModel
    }
    //1 -
    input.myLocation.subscribe(onNext: { [weak self] in
      guard let self = self else { return }
      if LocationManager.shared.locationServicesEnabled {
        switch self.locationManager.permissionStatus.value {
        case .authorizedWhenInUse, .authorizedAlways:
          self.location.onNext(self.locationManager.locationChanged.value)
        case .denied:
          self.appSettingTrigger.onNext(())
        case .notDetermined:
          self.locationManager.requestPermission()
        default:
          break
        }
      } else {
        self.settingTrigger.onNext(())
      }
    }).disposed(by: disposeBag)
    
    let setting = self.settingTrigger.asObservable()
    let appSetting = self.appSettingTrigger.asObservable()
    let location = self.location.asDriver(onErrorJustReturn: .init(latitude: 37.5662952, longitude: 126.9757564))
    let search = input.search.asDriver(onErrorJustReturn: ()).map { () -> MapSearchViewModel in
      let viewModel = MapSearchViewModel()
      return viewModel
    }
    return Output(
      tip: tip,
      setting: setting,
      appSetting: appSetting,
      location: location,
      search: search
    )
  }
}
