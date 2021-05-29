//
//  PostReviewModel.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/28.
//

import Foundation
import RxSwift

class PostReviewModel {
  // provider
  private let service: PostService
  private let disposeBag = DisposeBag()
  
  init(_ service: PostService = .init()) {
    self.service = service
  }
  
  func addPost(_ requestDTO: PostRequestDTO) {
    service.addRequest(requestDTO)
      .retry(2)
      .subscribe(onNext: { response in
        if !(200...300).contains(response.statusCode) {
          AlertAction.shared.showAlertView(title: "게시물 등록 실패")
          print("Post Request Error Code: \(response.statusCode)")

        }
      }).disposed(by: disposeBag)
  }

  
}

