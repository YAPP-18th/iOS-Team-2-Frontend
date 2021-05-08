//
//  TipViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/17.
//

import Foundation
import RxCocoa
import RxSwift

class TipViewModel: ViewModel, ViewModelType {
  struct Input {
    
  }
  
  struct Output {
    let items: BehaviorRelay<[TipSection]>
  }
  
  let tipElements = BehaviorRelay<[Tip]>(value: Tip.allCases)
  
  func transform(input: Input) -> Output {
    let elements = BehaviorRelay<[TipSection]>(value: [])
    
    tipElements.map { tipList -> [TipSection] in
      var elements: [TipSection] = []
      let cellViewModel = tipList.map { tip -> TipSection.Item in
        TipTableViewCellViewModel.init(with: tip)
      }
      elements.append(TipSection(items: cellViewModel))
      return elements
    }.bind(to: elements).disposed(by: disposeBag)
    
    return Output(
      items: elements
    )
  }
}
