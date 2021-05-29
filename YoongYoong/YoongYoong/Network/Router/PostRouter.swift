//
//  PostRouter.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/22.
//

import Foundation

import Moya

enum PostRouter {
  case fetchPostList
  case fetchCommentList(id: Int)
  case addPost(param: PostRequestDTO)
  case addComment(id: Int)
  case modifyComment(id: Int)
  case deleteComment(id: Int)
  case fetchPostBy
  case fetchMyPost(month: Int)
  case fetchOtherPost(id: Int)
}


extension PostRouter: TargetType {
  public var baseURL: URL {
    return URL(string: "http://52.78.137.81:8080")!
  }
  
  var path: String {
    switch self {
    
    case .fetchPostList:
      return "/post"
    case .fetchCommentList(let id),
         .addComment(let id),
         .modifyComment(let id),
         .deleteComment(let id):
      return "/post/\(id)/comment"
    case .addPost:
      return "/post"
    case .fetchPostBy:
      return "/post"
    case .fetchMyPost:
      return "/post/user/mine"
    case .fetchOtherPost:
      return "/post/user"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .fetchPostList,
         .fetchCommentList,
         .fetchPostBy,
         .fetchMyPost,
         .fetchOtherPost:
      return .get
    case .addPost,
         .addComment:
      return .post
    case .modifyComment:
      return .put
    case .deleteComment:
      return .delete
    }
  }
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    switch self {
    case .fetchPostList:
      return .requestPlain
    case .fetchCommentList:
      return .requestPlain
    case .addPost(let param):
      var multipartFormDatas = [MultipartFormData]()
      
      let placeNameMP = MultipartFormData(provider: .data("\(param.placeName)".data(using: .utf8)!), name: "placeName")
      let contentMP = MultipartFormData(provider: .data("\(param.content)".data(using: .utf8)!), name: "content")
      let reviewBadgeMP = MultipartFormData(provider: .data("\(param.reviewBadge)".data(using: .utf8)!), name: "reviewBadge")
      let placeLocationMP = MultipartFormData(provider: .data("\(param.placeLocation)".data(using: .utf8)!), name: "placeLocation")
      
      for i in 0..<param.containers.count {
        let tuples = containerParameter(i)
        let foodMP = MultipartFormData(provider: .data("\(param.containers[i].food)".data(using: .utf8)!), name: tuples.food)
        let foodCountMP = MultipartFormData(provider: .data("\(param.containers[i].foodCount)".data(using: .utf8)!), name: tuples.foodCount)
        let containerNameMP = MultipartFormData(provider: .data("\(param.containers[i].container.name)".data(using: .utf8)!), name: tuples.containerName)
        let containerSizeMP = MultipartFormData(provider: .data("\(param.containers[i].container.size)".data(using: .utf8)!), name: tuples.containerSize)
        let containerCountMP = MultipartFormData(provider: .data("\(param.containers[i].containerCount)".data(using: .utf8)!), name: tuples.containerCount)
        
        multipartFormDatas += [foodMP, foodCountMP, containerNameMP, containerSizeMP, containerCountMP]
      }
      
      // TODO: imageData
      for data in param.postImages {}
      
      multipartFormDatas += [placeNameMP, placeLocationMP, contentMP, reviewBadgeMP]
      
      print(multipartFormDatas)
      
      return .uploadMultipart(multipartFormDatas)
    case .addComment:
      return .requestPlain
    case .modifyComment:
      return .requestPlain
    case .deleteComment:
      return .requestPlain
    case .fetchPostBy:
      return .requestPlain
    case .fetchMyPost(month: let month):
      return .requestParameters(parameters: ["month": month], encoding: URLEncoding.default)
    case let .fetchOtherPost(id):
      return .requestParameters(parameters: ["userId": id], encoding: URLEncoding.default)
    }
  }
  
  var headers: [String : String]? {
    switch self {
    default:
      return ["Content-Type":"application/json",
              "Authorization" : "Bearer \(UserDefaultHelper<String>.value(forKey: .accessToken)!)"]
    }
  }
}

func containerParameter(_ index: Int) -> (food: String,
                                foodCount: String,
                                containerName: String,
                                containerSize: String,
                                containerCount: String) {
  
  let containers = "containers[\(index)]."
  return (containers+"food",
          containers+"foodCount",
          containers+"container.name",
          containers+"container.size",
          containers+"containerCount")
  
}
