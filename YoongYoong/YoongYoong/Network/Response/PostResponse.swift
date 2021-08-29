//
//  PostResponse.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/27.
//

import Foundation

struct PostResponse: Decodable, Hashable{
  let commentCount: Int
  let content: String?
  let createdDate: String
  let images: [String]
  var likeCount: Int
  let placeLocation: String
  let placeName: String
  let postContainers: [PostContainerModel]
  let postId: Int
  let reviewBadge: String
  let user: UserInfo
  var isLikePressed: Bool
  let placeLatitude: Double
  let placeLongitude: Double
  
  enum CodingKeys: String, CodingKey {
    case commentCount
    case content
    case createdDate
    case images
    case likeCount
    case placeLocation
    case placeName
    case postContainers
    case postId
    case reviewBadge
    case user
    case isLikePressed
    case placeLatitude
    case placeLongitude
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: PostResponse.CodingKeys.self)
    commentCount = try container.decode(Int.self, forKey: .commentCount)
    content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
    createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate) ?? ""
    images = try container.decodeIfPresent([String].self, forKey: .images) ?? []
    likeCount = try container.decode(Int.self, forKey: .likeCount)
    placeLocation = try container.decode(String.self, forKey: .placeLocation)
    placeName = try container.decode(String.self, forKey: .placeName)
    postContainers = try container.decode([PostContainerModel].self, forKey: .postContainers)
    postId = try container.decode(Int.self, forKey: .postId)
    reviewBadge = try container.decode(String.self, forKey: .reviewBadge)
    user = try container.decode(UserInfo.self, forKey: .user)
    isLikePressed = try container.decode(Bool.self, forKey: .isLikePressed)
    let latitude = try container.decodeIfPresent(String.self, forKey: .placeLatitude) ?? "0.0"
    placeLatitude = Double(latitude)!
    let longitude = try container.decodeIfPresent(String.self, forKey: .placeLongitude) ?? "0.0"
    placeLongitude = Double(longitude)!
  }
}
struct UserInfo : Decodable, Hashable {
  let email: String
  let id: Int
  var imageUrl: String?
  let introduction: String?
  let nickname: String
}
struct PostContainerModel : Decodable, Hashable {
  let container: ContainerInfo
  let containerCount: Int
  let food: String
  let foodCount: Int
}
struct ContainerInfo: Decodable, Hashable{
  let name: String
  let size: String
}

extension PostResponse {
  var myPagePostModel : PostSimpleModel {
    return .init(
      feedId: postId,
      profile: .init(imagePath: user.imageUrl, name: user.nickname, message: user.introduction, userId: user.id),
      postedAt: createdDate,
      menus: postContainers.map{MenuModel.init(menutitle: $0.food, menuCount: $0.foodCount)},
      thumbNail: images.first ?? "",
      postDescription: content ?? "")
  }
}
