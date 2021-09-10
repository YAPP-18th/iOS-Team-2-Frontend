//
//  APIRouter.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/08/28.
//  Copyright © 2021 YoongYoong. All rights reserved.
//

import Foundation
import Moya

enum APIRouter {
  // Auth
  case register(param: SignupRequest, image: Data)
  case appleRegister(param: AppleRegistrationDTO)
  case login(param: LoginRequest)
  case appleLogin(param: AppleLoginRequest)
  case guest
  case profile
  case emailCheck(param: CheckEmailDuplicateRequest)
  case deleteAccount(id: Int)
  case nickNameCheck(param: String)
  case modifyProfile(param: ModifyProfileParam)
  case findPassword(param: FindPasswordRequest)
  case findPasswordCode(param: FindPasswordCodeRequest)
  case resetPassword(param: ResetPasswordRequest)
  case refreshToken(param: RefreshTokenRequest)
  //place
  case fetchPlaceList(param : PlaceRequest)
  case fetchReviewCount(name: String)
  case fetchReviewCountAll(Void)
  //post
  case fetchPostList
  case fetchCommentList(id: Int)
  case addPost(param: PostRequestDTO)
  case editPost(param: PostEditDTO)
  case addComment(id: Int, param: CommentRequestDTO)
  case modifyComment(postId: Int, commentId: Int, param: CommentRequestDTO)
  case deleteComment(postId: Int, commentId: Int)
  case fetchPostBy
  case fetchMyPost(month: Int)
  case fetchOtherPost(id: Int)
  case likePost(id: Int)
  case fetchStorePost(name: String, address: String)
  case fetchStoreContainer(place: Place)
  case deletePost(id: Int)
}


extension APIRouter: TargetType {
  var headers: [String : String]? {
    if self.authorizationType == .bearer {
      return [
              "Authorization" : "Bearer \(UserDefaultHelper<String>.value(forKey: .accessToken) ?? "")"]
    } else {
      return nil
    }
  }
  
  public var baseURL: URL {
    switch self {
    default:
      return URL(string: "http://52.78.137.81:8080")!
    }
  }
  
  var path: String {
    switch self {
    //auth
    case .register:
      return "/user/sign-up"
    case .appleRegister:
      return "/user/login/apple"
    case .login:
      return "/user/login"
    case .appleLogin:
      return "/user/login/apple"
    case .guest:
      return "/user/login/guest"
    case .profile:
      return "/user/profile"
    case .emailCheck:
      return "/user/check/email"
    case .deleteAccount:
      return "/user/withdrawal"
    case .nickNameCheck:
      return "/user/check/nickname"
    case .modifyProfile:
      return "/user/profile"
    case .findPassword:
      return "/user/password/email"
    case .findPasswordCode:
      return "/user/password/email"
    case .resetPassword:
      return "/user/password"
    case .refreshToken:
      return "/user/token"
    //place
    case .fetchPlaceList:
      return "/place"
    case .fetchReviewCount:
      return "/place/review-count"
    case .fetchReviewCountAll:
      return "/place/review-count/all"
    //post
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
    case .editPost(let param):
      return "/post/\(param.postId)"
    case .fetchPostBy:
      return "/post"
    case .fetchMyPost:
      return "/post/user/mine"
    case .fetchOtherPost:
      return "/post/user"
    case .likePost(let id):
      return "/post/\(id)/like"
    case .fetchStorePost:
      return "/post/place"
    case .fetchStoreContainer:
      return "/place"
    case .deletePost(let id):
      return "/post/\(id)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    // auth
    case .register, .appleRegister, .login, .appleLogin, .guest, .findPasswordCode:
      return .post
    case .emailCheck,
         .nickNameCheck,
         .findPassword,
         .profile:
      return .get
    case .deleteAccount:
      return .delete
    case .modifyProfile, .resetPassword, .refreshToken:
      return .put
    // place
    case .fetchReviewCount,
         .fetchPlaceList,
         .fetchReviewCountAll:
      return .get
    //post
    case .fetchPostList,
         .fetchCommentList,
         .fetchPostBy,
         .fetchMyPost,
         .fetchOtherPost,
         .fetchStorePost,
         .fetchStoreContainer:
      return .get
    case .addPost,
         .addComment:
      return .post
    case .modifyComment, .likePost, .editPost:
      return .put
    case .deleteComment, .deletePost:
      return .delete
    }
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    switch self {
    //auth
    case let .register(param, image):
      let multipart = MultipartFormData(provider: .data(image), name: "profileImage", fileName: "profileImage.png", mimeType: "image/png")
      return .uploadCompositeMultipart([multipart], urlParameters: try! param.asParameters())
    case let .appleRegister(param):
      return .requestJSONEncodable(param)
    case .login(let param):
      return .requestJSONEncodable(param)
    case .appleLogin(let param):
      return .requestJSONEncodable(param)
    case .guest:
      return .requestPlain
    case .profile:
      return .requestPlain
    case .emailCheck(let param):
      return .requestParameters(parameters: try! param.asParameters(), encoding: URLEncoding.default)
    case .deleteAccount(let id):
      return .requestParameters(parameters: try! ["userId" : id].asParameters(), encoding: URLEncoding.default)
    case .nickNameCheck(param: let param):
      return .requestParameters(parameters: try! ["nickname" : param].asParameters(), encoding: URLEncoding.default)
    case .modifyProfile(let param):
      return .requestParameters(parameters: try! param.asParameters(), encoding: URLEncoding.default)
    case .findPassword(let param):
      return .requestParameters(parameters: try! param.asParameters(), encoding: URLEncoding.default)
    case .findPasswordCode(let param):
      return .requestJSONEncodable(param)
    case .resetPassword(let param):
      return .requestJSONEncodable(param)
    case .refreshToken(let param):
      return .requestJSONEncodable(param)
    //place
    case .fetchPlaceList(param: let param):
      return .requestJSONEncodable(param)
    case .fetchReviewCount(name: let name):
      return .requestParameters(parameters: try! ["name" : name].asParameters(), encoding: JSONEncoding.default)
    case .fetchReviewCountAll():
      return .requestPlain
    //post
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
      let placeLatitudeMP = MultipartFormData(provider: .data("\(param.placeLatitude)".data(using: .utf8)!), name: "placeLatitude")
      let placeLongitudeMP = MultipartFormData(provider: .data("\(param.placeLongitude)".data(using: .utf8)!), name: "placeLongitude")
      
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
      
        
      multipartFormDatas += [placeNameMP, placeLocationMP, placeLatitudeMP, placeLongitudeMP, contentMP, reviewBadgeMP]
      
      print("multiparts \(multipartFormDatas)")
      
      return .uploadMultipart(multipartFormDatas)
    case let .editPost(param):
      return .requestParameters(parameters: ["reviewBadge": param.reviewBadge, "content": param.content], encoding: JSONEncoding.default)
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
    case let .fetchStorePost(place):
      return .requestParameters(
        parameters: [
          "location": place.address,
          "name": place.name
        ],
        encoding: URLEncoding.default
      )
    case let .fetchStoreContainer(place):
      return .requestParameters(
        parameters: [
          "place": place.address,
          "name": place.name
        ],
        encoding: URLEncoding.default
      )
    case .deletePost:
      return .requestPlain
    }
  }
}

extension APIRouter: AccessTokenAuthorizable {
  var authorizationType: AuthorizationType? {
    switch self {
    //auth
    case .deleteAccount, .profile:
      return .bearer
    //profile
    case .modifyProfile, .fetchPlaceList, .fetchReviewCount, .fetchReviewCountAll:
      return .bearer
    //post
    case .fetchPostList,
         .fetchCommentList,
         .addPost,
         .editPost,
         .addComment,
         .modifyComment,
         .deleteComment,
         .fetchPostBy,
         .fetchMyPost,
         .fetchOtherPost,
         .likePost,
         .fetchStorePost,
         .fetchStoreContainer,
         .deletePost:
      return .bearer
    default:
      return nil
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
