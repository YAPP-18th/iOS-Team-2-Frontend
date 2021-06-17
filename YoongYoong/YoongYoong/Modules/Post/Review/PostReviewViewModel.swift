//
//  PostReviewViewModel.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/10.
//

import Foundation
import RxSwift
import RxCocoa

class PostReviewViewModel: ViewModel, ViewModelType {
  struct Input {
    let discountButtonDidTap: BehaviorRelay<Bool>
    let smileButtonDidTap: BehaviorRelay<Bool>
    let likeButtonDidTap: BehaviorRelay<Bool>
    let reviewContent: PublishRelay<String>
    let uploadButtonDidTap: Observable<Void>
  }
  
  struct Output {
    let uploadButtonIsEnabled: PublishSubject<Bool>
    let uploadDidEnd: PublishSubject<Void>
  }
  
  func transform(input: Input) -> Output {
    var reviewBadges = Array(repeating: false, count: 3)
    let buttonEnabled = PublishSubject<Bool>()
    Observable.combineLatest([input.discountButtonDidTap, input.smileButtonDidTap, input.likeButtonDidTap]).subscribe(onNext: {
      reviewBadges = [$0[0], $0[1],$0[2]]
      PostData.shared.reviewBadges = reviewBadges.reduce("", { $0 + ($1 ? "T" : "F") })
      buttonEnabled.onNext($0[0] || $0[1] || $0[2])
    }).disposed(by: disposeBag
    )
    let uploadDidEnd = PublishSubject<Void>()
    let model = PostReviewModel()
    
    input.reviewContent
      .subscribe(onNext: {
        PostData.shared.content = $0
      }).disposed(by: disposeBag)
    
    input.uploadButtonDidTap
      .subscribe(onNext: {
        PostData.shared.toDTO { model.addPost($0) }
        uploadDidEnd.onNext(())
      }).disposed(by: disposeBag)
    
    return Output(uploadButtonIsEnabled: buttonEnabled,
                  uploadDidEnd: uploadDidEnd)
  }
  
  
  
}
