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
    let uploadButtonDidTap: Observable<Void>
  }
  
  struct Output {
    let uploadButtonIsEnabled: Observable<Bool>
    let uploadDidEnd: PublishSubject<Void>
  }
  
  func transform(input: Input) -> Output {

    let buttonEnabled = Observable.combineLatest([input.discountButtonDidTap, input.smileButtonDidTap, input.likeButtonDidTap]).map {$0[0] || $0[1] || $0[2]}
    let uploadDidEnd = PublishSubject<Void>()
    
    input.uploadButtonDidTap
      .subscribe(onNext: {
        // model.upload()
        uploadDidEnd.onNext(())
      }).disposed(by: disposeBag)
    
    return Output(uploadButtonIsEnabled: buttonEnabled,
                  uploadDidEnd: uploadDidEnd)
  }
  
  
  
}
