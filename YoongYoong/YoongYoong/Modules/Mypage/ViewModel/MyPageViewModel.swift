//
//  MyPageViewModel.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/04/22.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class MypageViewModel: ViewModel , ViewModelType {
  private let service = MyPostService(provider: MoyaProvider<PostRouter>(plugins:[NetworkLoggerPlugin()]))
  let currentMonth = BehaviorSubject<Int>(value: Int(Date().month) ?? 6)
  struct Input {
    let loadView : Observable<Void>
  }
  struct Output {
    let messageIndicator: Observable<[String]>
    let badgeUsecase: Observable<[BadgeModel]>
    let postUsecase: Observable<PostListModel>
    let packageUsecase: Observable<[PackageSectionType]>
  }
}
extension MypageViewModel {
  // contentCell에 바인딩
  func changeCurrentMonth(for changed: Int) {
    currentMonth.onNext(changed)
  }
  func transform(input: Input) -> Output {
    weak var weakSelf = self
    let badgeUsecase = input.loadView.map{ _ -> [BadgeModel] in
      if LoginManager.shared.isLogin {
        return [BadgeModel(imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다")]
      }
      else {
        return []
      }
    }
    let postList = input.loadView.withLatestFrom(self.currentMonth).flatMapLatest{ month -> Observable<PostListModel> in
      if LoginManager.shared.isLogin {
        let myPost =  self.service.fetchMyPost(month: month)
        let containers = myPost.map{$0.map{$0.postContainers.map{$0.containerCount}}}.map{ container -> Int in
          let result = container.map{$0.reduce(0){$0 + $1}}.reduce(0){$0 + $1}
          return result
        }
        return Observable.combineLatest(myPost, containers).map{PostListModel(month: "2021년 \(month)월", postCount: $0.0.count, packageCount: $0.1, postList: $0.0.map{$0.myPagePostModel})}
      }
      else {
        return .just( .init(month: "3월", postCount: 0, packageCount: 0, postList: []))
      }
    }.share()
    let message = postList.map{ model -> [String] in
        return ["용기를 내고 배지를 모아보세요",
                "지금까지 총 \(model.packageCount)개의 용기를 냈어요!",
                "자주 사용하는 용기를 등록하세요!"]
      }
    let packageUsecase = input.loadView.map{_ -> [PackageSectionType] in
      if LoginManager.shared.isLogin {
        
        return [PackageSectionType(model: "자주 쓰는 용기", items: [PackageSimpleModel(identity: 0, title: "밀폐용기", size: "S", selected: true)]),
                PackageSectionType(model: "밀폐용기", items: [PackageSimpleModel(identity: 0, title: "밀폐용기", size: "S", selected: true),
                                                                  PackageSimpleModel(identity: 0, title: "밀폐용기", size: "M", selected: false),
                                                                  PackageSimpleModel(identity: 0, title: "밀폐용기", size: "L", selected: false)]),
                PackageSectionType(model: "냄비", items: [PackageSimpleModel(identity: 0, title: "냄비", size: "S", selected: false),
                                                            PackageSimpleModel(identity: 0, title: "냄비", size: "M", selected: false),
                                                            PackageSimpleModel(identity: 0, title: "냄비", size: "L", selected: false)]),
                PackageSectionType(model: "텀블러", items: [PackageSimpleModel(identity: 0, title: "텀블러", size: "S", selected: false),
                                                               PackageSimpleModel(identity: 0, title: "텀블러", size: "M", selected: false),
                                                               PackageSimpleModel(identity: 0, title: "텀블러", size: "L", selected: false)]),
        ]
      }
      else {
        return []
      }
    }

    
    return .init(messageIndicator: message,
                 badgeUsecase: badgeUsecase,
                 postUsecase: postList,
                 packageUsecase: packageUsecase)  }
  //메인 뷰에 바인딩하는 함수
  func getProfile(inputs: Input) -> Driver<ProfileModel> {
    weak var weakSelf = self
    let profile = inputs.loadView.map{ _ in
      ProfileModel(imagePath: nil, name: "김용기", message: "안녕하세용", userId: 1)
    }
    return profile.asDriver(onErrorDriveWith: profile.asDriver(onErrorDriveWith: .empty()))
  }
  func yongyongMessage(inputs: Input) -> Driver<String> {
    let comment = inputs.loadView.map{ _ in
      return "용기를 내고 배지를 모아보세요!"
    }
    return comment.asDriver(onErrorDriveWith: comment.asDriver(onErrorDriveWith: .empty()))
  }
  func logIn (inputs: Observable<Void>) -> Observable<SplashViewModel> {
    return inputs.map{SplashViewModel()}
  }
}
