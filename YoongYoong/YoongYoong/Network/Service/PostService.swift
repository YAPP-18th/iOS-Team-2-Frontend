//
//  PostService.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/29.
//

import Foundation
import Moya
import RxSwift

protocol PostServiceType: AnyObject {
  func addRequest(_ requestDTO: PostRequestDTO) -> Observable<Response>
}

enum PostAPIError: Error {
  case error(String)
  
  var message: String {
    switch self {
    case .error(let msg):
      return msg
    }
  }
}

final class PostService: PostServiceType {
  
  private let provider: MoyaProvider<PostRouter>
  init(provider: MoyaProvider<PostRouter> = .init(plugins:[NetworkLoggerPlugin()])) {
    self.provider = provider
  }
  
  func addRequest(_ requestDTO: PostRequestDTO) -> Observable<Response> {
    return provider.rx.request(.addPost(param: requestDTO)).asObservable()
  }
  
  func fetchAllPosts() -> Observable<Result<BaseResponse<[PostResponse]>, PostAPIError>> {
    return provider.rx.request(.fetchPostList).asObservable()
      .map { response -> Result<BaseResponse<[PostResponse]>, PostAPIError> in
        switch response.statusCode {
        case 200:
          do {
            let results = try JSONDecoder().decode(BaseResponse<[PostResponse]>.self, from: response.data)
            return .success(results)
          } catch {
            return .failure(.error("JSON Parsing Error"))
          }
        case 400:
          // 잘못된 parameter를 전달한 경우
          return .failure(.error("Bad Request"))
        case 500:
          // parameter가 누락된 경우
          return .failure(.error("Internal Server Error"))
        default:
          return .failure(.error("원인 모를 에러"))
        }
      }
  }
  
  func fetchOtherPosts(userId: Int) -> Observable<Result<BaseResponse<[PostResponse]>, PostAPIError>> {
    return provider.rx.request(.fetchOtherPost(id: userId)).asObservable()
      .map { response -> Result<BaseResponse<[PostResponse]>, PostAPIError> in
        switch response.statusCode {
        case 200:
          do {
            let results = try JSONDecoder().decode(BaseResponse<[PostResponse]>.self, from: response.data)
            return .success(results)
          } catch {
            return .failure(.error("JSON Parsing Error"))
          }
        case 400:
          // 잘못된 parameter를 전달한 경우
          return .failure(.error("Bad Request"))
        case 500:
          // parameter가 누락된 경우
          return .failure(.error("Internal Server Error"))
        default:
          return .failure(.error("원인 모를 에러"))
        }
      }
  }
  
  func addCommentRequesst(postId: Int, requestDTO: CommentRequestDTO) -> Observable<Bool> {
    return provider.rx.request(.addComment(id: postId, param: requestDTO)).asObservable()
      .map { response -> Bool in
        (200...300).contains(response.statusCode)
      }
  }
    
    func editCommentRequest(postId: Int, commentId: Int, requestDTO: CommentRequestDTO) -> Observable<Bool> {
        return provider.rx.request(.modifyComment(postId: postId, commentId: commentId, param: requestDTO)).asObservable()
            .map { response -> Bool in
                (200...300).contains(response.statusCode)
            }
    }
    
  func deleteComment(postId: Int, commentId: Int) -> Observable<Bool>{
    return provider.rx.request(.deleteComment(postId: postId, commentId: commentId)).asObservable().map { response -> Bool in
      (200...300).contains(response.statusCode)
    }
  }
  
  func fetchComments(postId: Int) -> Observable<Result<BaseResponse<[CommentResponse]>, PostAPIError>> {
    return provider.rx.request(.fetchCommentList(id: postId)).asObservable()
      .map { response -> Result<BaseResponse<[CommentResponse]>, PostAPIError> in
        switch response.statusCode {
        case 200:
          do {
            let results = try JSONDecoder().decode(BaseResponse<[CommentResponse]>.self, from: response.data)
            return .success(results)
          } catch {
            return .failure(.error("JSON Parsing Error"))
          }
        case 400:
          // 잘못된 parameter를 전달한 경우
          return .failure(.error("Bad Request"))
        case 500:
          // parameter가 누락된 경우
          return .failure(.error("Internal Server Error"))
        default:
          return .failure(.error("원인 모를 에러"))
        }
      }
  }
  
  func likePost(feedId: Int) -> Observable<Result<Void, PostAPIError>> {
    return provider.rx.request(.likePost(id: feedId))
      .asObservable()
      .map { response -> Result<Void, PostAPIError> in
        switch response.statusCode {
        case 200...399:
          return .success(())
        case 400...499:
          // 잘못된 parameter를 전달한 경우
          return .failure(.error("Bad Request"))
        case 500...:
          // parameter가 누락된 경우
          return .failure(.error("Internal Server Error"))
        default:
          return .failure(.error("원인 모를 에러"))
        }
      }
  }
  
  func deletePost(feedId: Int) -> Observable<Result<Void, PostAPIError>> {
    return provider.rx.request(.deletePost(id: feedId))
      .asObservable()
      .map { response -> Result<Void, PostAPIError> in
        switch response.statusCode {
        case 200...399:
          return .success(())
        case 400...499:
          // 잘못된 parameter를 전달한 경우
          return .failure(.error("Bad Request"))
        case 500...:
          // parameter가 누락된 경우
          return .failure(.error("Internal Server Error"))
        default:
          return .failure(.error("원인 모를 에러"))
        }
      }
  }
  
  func storeContainer(place: Place) -> Observable<Result<[ContainerDTO], PostAPIError>> {
    return provider.rx.request(.fetchStoreContainer(place: place))
      .asObservable()
      .map { response -> Result<[ContainerDTO], PostAPIError> in
        switch response.statusCode {
        case 200:
          do {
            let results = try JSONDecoder().decode(BaseResponse<[ContainerDTO]>.self, from: response.data)
            return .success(results.data ?? [])
          } catch {
            return .failure(.error("JSON Parsing Error"))
          }
        case 400:
          // 잘못된 parameter를 전달한 경우
          return .failure(.error("Bad Request"))
        case 500:
          // parameter가 누락된 경우
          return .failure(.error("Internal Server Error"))
        default:
          return .failure(.error("원인 모를 에러"))
        }
      }
  }
  
  func storePosts(place: Place) -> Observable<Result<[PostResponse], PostAPIError>> {
    return provider.rx.request(.fetchStorePost(place: place))
      .asObservable()
      .map { response -> Result<[PostResponse], PostAPIError> in
        switch response.statusCode {
        case 200:
          do {
            let results = try JSONDecoder().decode(BaseResponse<[PostResponse]>.self, from: response.data)
            return .success(results.data ?? [])
          } catch {
            return .failure(.error("JSON Parsing Error"))
          }
        case 400:
          // 잘못된 parameter를 전달한 경우
          return .failure(.error("Bad Request"))
        case 500:
          // parameter가 누락된 경우
          return .failure(.error("Internal Server Error"))
        default:
          return .failure(.error("원인 모를 에러"))
        }
      }
  }
}

protocol MyPostServiceType: AnyObject {
  func fetchMyPost(month: Int) -> Observable<[PostResponse]>
}

class MyPostService: MyPostServiceType {
  private let provider: MoyaProvider<PostRouter>
  init(provider: MoyaProvider<PostRouter>) {
    self.provider = provider
  }
}

extension MyPostService {
  func fetchMyPost(month: Int) -> Observable<[PostResponse]> {
    provider.rx.request(.fetchMyPost(month: month))
      .filter401StatusCode()
      .filter500StatusCode()
      .asObservable()
      .map([PostResponse].self ,atKeyPath: "data")
  }
}

