//
//  Store.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/18.
//

import Foundation

struct SearchAPIResponse: Decodable {
  let documents: [Place]
  let meta: Meta
}

struct Place: Codable {
  var name: String
  var address: String
  var distance: String
  var latitude: String
  var longtitude: String
  
  enum CodingKeys: String, CodingKey {
    case name = "place_name"
    case address = "road_address_name"
    case distance
    case latitude = "y"
    case longtitude = "x"
  }
}

struct Meta: Codable {
  let isEnd: Bool
  let pageableCount: Int
  
  enum CodingKeys: String, CodingKey {
    case isEnd = "is_end"
    case pageableCount = "pageable_count"
  }
}




