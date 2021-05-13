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
  }
  
  func transform(input: Input) -> Output {

    let buttonEnabled = Observable.combineLatest([input.discountButtonDidTap, input.smileButtonDidTap, input.likeButtonDidTap]).map {$0[0] || $0[1] || $0[2]}
    
    return Output(uploadButtonIsEnabled: buttonEnabled)
  }
  
  
  
}
