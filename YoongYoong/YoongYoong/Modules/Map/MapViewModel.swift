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
    let post: Observable<Void>
    let myLocation: Observable<Void>
  }
  
  struct Output {
    let tip: Driver<TipViewModel>
    let setting: Observable<Void>
    let appSetting: Observable<Void>
    let location: Driver<CLLocationCoordinate2D>
    let login: Driver<LoginViewModel>
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
    
    let login = input.post.asDriver(onErrorJustReturn: ()).map { () -> LoginViewModel in
      let viewModel = LoginViewModel()
      return viewModel
    }.asDriver()
    
    let setting = self.settingTrigger.asObservable()
    let appSetting = self.appSettingTrigger.asObservable()
    let location = self.location.asDriver(onErrorJustReturn: .init(latitude: 37.5662952, longitude: 126.9757564))
    return Output(
      tip: tip,
      setting: setting,
      appSetting: appSetting,
      location: location,
      login: login
    )
  }
}
