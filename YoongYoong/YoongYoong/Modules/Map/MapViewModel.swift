//
//  MapViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/17.
//

import Foundation
import RxCocoa
import RxSwift

class MapViewModel: ViewModel, ViewModelType {
  struct Input {
    let tipSelection: Observable<Void>
  }
  
  struct Output {
    let tipSelection: Driver<TipViewModel>
  }
  
  func transform(input: Input) -> Output {
    let tipSelection = input.tipSelection.asDriver(onErrorJustReturn: ()).map { () -> TipViewModel in
      let viewModel = TipViewModel()
      return viewModel
    }
    return Output(tipSelection: tipSelection)
  }
}
