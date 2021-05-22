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
  case addPost
  case addComment(id: Int)
  case modifyComment(id: Int)
  case deleteComment(id: Int)
  case fetchPostBy
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
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .fetchPostList,
         .fetchCommentList,
         .fetchPostBy:
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
    case .fetchCommentList(id: let id):
      return .requestPlain
    case .addPost:
      return .requestPlain
    case .addComment(id: let id):
      return .requestPlain
    case .modifyComment(id: let id):
      return .requestPlain
    case .deleteComment(id: let id):
      return .requestPlain
    case .fetchPostBy:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    switch self {
    default:
      return ["Content-Type":"application/json",
              "token" : UserDefaultHelper<String>.value(forKey: .accessToken)!]
    }
  }
}

