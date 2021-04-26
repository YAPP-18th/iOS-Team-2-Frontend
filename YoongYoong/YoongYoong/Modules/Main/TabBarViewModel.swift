//
//  TabBarViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/17.
//

import Foundation
import RxCocoa
import RxSwift

class TabBarViewModel: ViewModel, ViewModelType {
  struct Input {
    
  }
  
  struct Output {
    let tabBarItems: Driver<[TabBarItem]>
  }
  
  func transform(input: Input) -> Output {
    let tabBarItems = Observable<[TabBarItem]>
      .just([.home,.feed,.post,.myPage])
      .asDriver(onErrorJustReturn: [])
    
    return Output(tabBarItems: tabBarItems)
  }
  
  func viewModel(for tabBarItem: TabBarItem) -> ViewModel {
    switch tabBarItem{
    case .home:
      let viewModel = MapViewModel()
      return viewModel
    case .feed:
      let viewModel = FeedViewModel()
      return viewModel
    default:
      return ViewModel()
    }
  }
}
