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
    let postTapDidTap: Observable<Void>
  }
  
  struct Output {
    let tabBarItems: Driver<[TabBarItem]>
    let postView: PublishSubject<PostSearchViewModel>
    let setting: PublishSubject<Void>
  }
  
  func transform(input: Input) -> Output {
    let postView = PublishSubject<PostSearchViewModel>()
    let setting = PublishSubject<Void>()
    input.postTapDidTap
      .subscribe(onNext:{ [weak self] in
        guard let self = self else { return }
        
        // 위치 권한 설정
          if LocationManager.shared.locationServicesEnabled {
            switch self.locationManager.permissionStatus.value {
            case .authorizedWhenInUse, .authorizedAlways:
              let viewModel = PostSearchViewModel()
              postView.onNext(viewModel)
            case .denied:
              setting.onNext(())
            case .notDetermined:
              self.locationManager.requestPermission()
            default:
              break
            }
          } else {
            setting.onNext(())
          }
        
      }).disposed(by: disposeBag)
    
    let tabBarItems = Observable<[TabBarItem]>
      .just([.home,.feed,.post,.myPage])
      .asDriver(onErrorJustReturn: [])
    
    return Output(tabBarItems: tabBarItems,
                  postView: postView,
                  setting: setting)
  }
  
  func viewModel(for tabBarItem: TabBarItem) -> ViewModel {
    switch tabBarItem{
    case .home:
      let viewModel = MapViewModel()
      return viewModel
    case .post:
      let viewModel = PostSearchViewModel()
      return viewModel
    case .myPage:
      return MypageViewModel()
    case .feed:
      let viewModel = FeedViewModel()
      return viewModel
    default:
      return ViewModel()
    }
  }
}
