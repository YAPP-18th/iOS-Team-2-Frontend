//
//  PlaceResponse.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/23.
//

import Foundation

struct AllPlaceReviewCountResponse: Decodable {
  let count: Int
  let data: [PlaceReviewCount]
  
}

struct PlaceReviewCount: Decodable {
  let location: String
  let name: String
  let reviewCount: Int
}
