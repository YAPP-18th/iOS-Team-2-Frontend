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
  let service = PostService(provider: APIProvider())
  
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
    let pin: Driver<[PinModel]>
    let error: Observable<Error>
  }
  
  var pinUpdateTrigger = PublishSubject<Void>()
  var settingTrigger = PublishSubject<Void>()
  var appSettingTrigger = PublishSubject<Void>()
  var error = PublishSubject<Error>()
  var location = PublishSubject<CLLocationCoordinate2D>()
  var pin = BehaviorRelay<[PinModel]>(value: [])
  
  func transform(input: Input) -> Output {
    let tip = input.tip.asDriver(onErrorJustReturn: ()).map { () -> TipViewModel in
      let viewModel = TipViewModel()
      return viewModel
    }
    
    pinUpdateTrigger.subscribe(onNext: {
      self.updatePin()
    }).disposed(by: disposeBag)
    
    //1 -
    input.myLocation.subscribe(onNext: { [weak self] in
      guard let self = self else { return }
      self.myLocation()
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
      search: search,
      pin: self.pin.asDriver(),
      error: self.error
    )
  }
  
  func myLocation() {
    if LocationManager.shared.locationServicesEnabled {
      switch self.locationManager.permissionStatus.value {
      case .authorizedWhenInUse, .authorizedAlways:
        self.location.onNext(self.locationManager.locationChanged.value)
      case .denied:
        self.appSettingTrigger.onNext(())
      case .notDetermined:
        self.locationManager.requestPermission()
      default:
        self.location.onNext(.init(latitude: 37.5662952, longitude: 126.9757564))
      }
    } else {
      self.settingTrigger.onNext(())
    }
  }
  
  func updatePin() {
    service.fetchAllPosts()
      .subscribe(onNext: { result in
        switch result  {
        case .success(let response):
          let list = (response.data ?? []).filter { $0.placeLatitude != nil && $0.placeLongitude != nil }
          self.updatePinInfo(list: list)
        case .failure(let error):
          self.error.onNext(error)
        }
      }, onError: { error in
        self.error.onNext(error)
      }).disposed(by: disposeBag)
    
    let group = DispatchGroup()
    
    for i in 0..<10 {
      defer {
        group.leave()
      }
      group.enter()
      print("hello \(i)")
    }
  }
  
  func updatePinInfo(list: [PostResponse]) {
    for post in list {
      let address = post.placeLocation
      let name = post.placeName
      
      let myDistance = CLLocation(latitude: LocationManager.shared.locationChanged.value.latitude, longitude: LocationManager.shared.locationChanged.value.longitude)
      let destnation = CLLocation(latitude: post.placeLatitude, longitude: post.placeLongitude)
      let distance = myDistance.distance(from: destnation)
      service.storePosts(name: name, address: address).subscribe(onNext: { result in
        switch result {
        case .success(let count):
          let pinModel = PinModel(name: name, postCount: count, address: address, latitude: post.placeLatitude, longitude: post.placeLongitude, distance: distance)
          var pinList = self.pin.value
          pinList.append(pinModel)
          self.pin.accept(pinList)
        case .failure(let error):
          let pinModel = PinModel(name: name, postCount: 0, address: address, latitude: post.placeLatitude, longitude: post.placeLongitude, distance: distance)
          var pinList = self.pin.value
          pinList.append(pinModel)
          self.pin.accept(pinList)
        }
      }).disposed(by: disposeBag)
    }
  }
}
