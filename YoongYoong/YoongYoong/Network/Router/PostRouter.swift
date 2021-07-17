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
  case addComment(id: Int, param: CommentRequestDTO)
  case modifyComment(postId: Int, commentId: Int, param: CommentRequestDTO)
  case deleteComment(postId: Int, commentId: Int)
  case fetchPostBy
  case fetchMyPost(month: Int)
  case fetchOtherPost(id: Int)
  case likePost(id: Int)
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
         .addComment(let id, _):
      return "/post/\(id)/comment"
    case let .modifyComment(postId, commentId, _):
      return "/post/\(postId)/comment/\(commentId)"
    case let .deleteComment(postId, commentId):
      return "/post/\(postId)/comment/\(commentId)"
    case .addPost:
      return "/post"
    case .fetchPostBy:
      return "/post"
    case .fetchMyPost:
      return "/post/user/mine"
    case .fetchOtherPost:
      return "/post/user"
    case .likePost(let id):
      return "/post/\(id)/like"
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
    case .modifyComment, .likePost:
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
      
      for i in 0..<param.postImages.count {
        let imageData = param.postImages[i]
        let imageMP = MultipartFormData(provider: .data(imageData), name: "postImages", fileName: "image\(i).jpg", mimeType: "image/jpeg")
        multipartFormDatas.append(imageMP)
      }
      
      
      for i in 0..<param.containers.count {
        let tuples = containerParameter(i)
        let foodMP = MultipartFormData(provider: .data("\(param.containers[i].food)".data(using: .utf8)!), name: tuples.food)
        let foodCountMP = MultipartFormData(provider: .data("\(param.containers[i].foodCount)".data(using: .utf8)!), name: tuples.foodCount)
        let containerNameMP = MultipartFormData(provider: .data("\(param.containers[i].container.name)".data(using: .utf8)!), name: tuples.containerName)
        let containerSizeMP = MultipartFormData(provider: .data("\(param.containers[i].container.size)".data(using: .utf8)!), name: tuples.containerSize)
        let containerCountMP = MultipartFormData(provider: .data("\(param.containers[i].containerCount)".data(using: .utf8)!), name: tuples.containerCount)
        
        multipartFormDatas += [foodMP, foodCountMP, containerNameMP, containerSizeMP, containerCountMP]
      }
      
        
      multipartFormDatas += [placeNameMP, placeLocationMP, contentMP, reviewBadgeMP]
      
      print("multiparts \(multipartFormDatas)")
      
      return .uploadMultipart(multipartFormDatas)
    case let .addComment(_, comment):
      return .requestParameters(parameters: try! comment.asParameters(), encoding: JSONEncoding.default)
    case let .modifyComment(_, _, comment):
      return .requestParameters(parameters: try! comment.asParameters(), encoding: JSONEncoding.default)
    case .deleteComment:
      return .requestPlain
    case .fetchPostBy:
      return .requestPlain
    case .fetchMyPost(month: let month):
      return .requestParameters(parameters: ["month": month], encoding: URLEncoding.default)
    case let .fetchOtherPost(id):
      return .requestParameters(parameters: ["userId": id], encoding: URLEncoding.default)
    case .likePost:
      return .requestPlain
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
