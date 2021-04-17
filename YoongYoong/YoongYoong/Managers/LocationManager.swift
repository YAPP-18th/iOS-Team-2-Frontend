//
//  LocationManager.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/17.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

protocol LocationService {
  func requestPermission()
  var locationChanged: BehaviorRelay<CLLocationCoordinate2D> { get }
  var permissionStatus: BehaviorRelay<CLAuthorizationStatus> { get }
}

final class LocationManager: NSObject {
  static let shared = LocationManager()
  
  let locationManager: CLLocationManager
  
  // 기본 위치는 서울 시청으로 지정
  let locationChanged = BehaviorRelay<CLLocationCoordinate2D>(value: .init(latitude: 37.5662952, longitude: 126.9757564))
  var permissionStatus = BehaviorRelay<CLAuthorizationStatus>(value: .notDetermined)
  
  func requestPermission() {
    self.locationManager.requestWhenInUseAuthorization()
  }
  var locationServicesEnabled: Bool {
    return CLLocationManager.locationServicesEnabled()
  }
  
  override init() {
    self.locationManager = CLLocationManager()
    super.init()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.delegate = self
  }
  
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let newLocation = locations.last {
      self.locationChanged.accept(newLocation.coordinate)
    }
  }
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    self.permissionStatus.accept(status)
    switch status{
    case .denied:
      print("denied")
    case .notDetermined, .restricted:
      locationManager.requestWhenInUseAuthorization()
    case .authorizedWhenInUse, .authorizedAlways:
      locationManager.startUpdatingLocation()
    default:
      break
    }
  }
}

extension LocationManager: LocationService {
  
}
