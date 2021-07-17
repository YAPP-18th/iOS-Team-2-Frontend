//
//  PostRequest.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/29.
//

import Foundation

struct PostRequestDTO: Encodable {
  let postImages: [Data]
  let content: String
  let placeLocation: String
  let placeName: String
  let containers: [PostContainerDTO]
  let reviewBadge: String
}

struct PostContainerDTO: Encodable {
  let container: ContainerDTO
  let containerCount: Int
  let food: String
  let foodCount: Int
}

struct ContainerDTO: Codable {
  let name: String
  let size: String
}

struct CommentRequestDTO: Encodable {
  let content: String
}

