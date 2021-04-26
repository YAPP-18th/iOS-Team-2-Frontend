//
//  FeedViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/27.
//

import Foundation
import RxCocoa
import RxSwift

class FeedViewModel: ViewModel, ViewModelType {
  struct Input {
    
  }
  
  struct Output {
    let sample: Driver<[String]>
  }
  
  func transform(input: Input) -> Output {
    let sampleList = ["Hello1","Hello2","Hello3","Hello4","Hello5"]
    return Output(
      sample: Observable.of(sampleList)
        .asDriver(onErrorJustReturn: []
        )
    )
  }
}
