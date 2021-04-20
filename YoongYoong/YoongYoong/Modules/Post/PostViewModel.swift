//
//  PostViewModel.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/19.
//

import Foundation
import RxSwift
import RxCocoa

class PostViewModel: ViewModel, ViewModelType {
  struct Input {
    let postButtonDidTap: Driver<Void>
  }
  
  struct Output {
    let post: Driver<PostSearchViewModel>
  }
  
  func transform(input: Input) -> Output {
    let post = input.postButtonDidTap.map { () -> PostSearchViewModel in
      let viewModel = PostSearchViewModel()
      return viewModel
    }
    
    return Output(post: post)
  }
  
}
