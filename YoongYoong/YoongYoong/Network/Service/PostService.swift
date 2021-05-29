//
//  PostService.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/29.
//

import Foundation
import Moya
import RxSwift

protocol PostServiceType: AnyObject {
  func addRequest(_ requestDTO: PostRequestDTO) -> Observable<Response>
}

class PostService: PostServiceType {
  private let provider: MoyaProvider<PostRouter>
  init(provider: MoyaProvider<PostRouter> = .init()) {
    self.provider = provider
  }
  
  func addRequest(_ requestDTO: PostRequestDTO) -> Observable<Response> {
    return provider.rx.request(.addPost(param: requestDTO)).asObservable()
  }
  
  
}
