//
//  TabBarViewModel.swift
//  YoongYoong
//
//  Copyright © 2021 YoongYoong. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Moya

class TabBarViewModel: ViewModel, ViewModelType {
  private let service : AuthorizeServiceType = AuthorizeService(provider: APIProvider(plugins:[NetworkLoggerPlugin()]))
    struct Input {
        let postTapDidTap: Observable<Void>
    }
    
    struct Output {
        let tabBarItems: Driver<[TabBarItem]>
        let postView: PublishSubject<PostSearchViewModel>
      let login: PublishSubject<Void>
        let setting: PublishSubject<Void>
    }
    
    func transform(input: Input) -> Output {
        let postView = PublishSubject<PostSearchViewModel>()
      let login = PublishSubject<Void>()
        let setting = PublishSubject<Void>()
        input.postTapDidTap
            .subscribe(onNext:{ [weak self] in
                guard let self = self else { return }
              if LoginManager.shared.isLogin && LoginManager.shared.loginStatus == .logined {
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
              } else {
                login.onNext(())
              }
                
                
            }).disposed(by: disposeBag)
        
        let tabBarItems = Observable<[TabBarItem]>
            .just([.home,.feed,.post,.myPage])
            .asDriver(onErrorJustReturn: [])
        getUser()
        return Output(tabBarItems: tabBarItems,
                      postView: postView,
                      login: login,
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
  
  private func getUser() {
    service.getProfile()
  }
}
