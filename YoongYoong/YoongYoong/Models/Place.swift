//
//  Place.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/24.
//

import Foundation
import CoreLocation

struct Place {
  var name: String
  var roadAddress: String
  var address: String
  var distance: String
  var latitude: String
  var longtitude: String
  var reviewCount: Int
  
  var coordinate: CLLocationCoordinate2D {
    let lat = NumberFormatter().number(from: latitude)!.doubleValue
    let long = NumberFormatter().number(from: longtitude)!.doubleValue
    return CLLocationCoordinate2D(latitude: lat, longitude: long)
  }
  
}
