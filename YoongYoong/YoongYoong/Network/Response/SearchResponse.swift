//
//  Store.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/18.
//

import Foundation

struct SearchAPIResponse: Decodable {
  let documents: [Documents]
  let meta: Meta
}

struct Documents: Codable {
  var name: String
  var roadAddress: String
  var address: String
  var distance: String
  var latitude: String
  var longtitude: String
  
  enum CodingKeys: String, CodingKey {
    case name = "place_name"
    case roadAddress = "road_address_name"
    case address = "address_name"
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




