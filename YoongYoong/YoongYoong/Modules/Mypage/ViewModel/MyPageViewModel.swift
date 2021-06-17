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
    let containerSelect: Observable<ContainerCellModel>
  }
  struct Output {
    let messageIndicator: Observable<[String]>
    let badgeUsecase: Observable<[BadgeModel]>
    let postUsecase: Observable<PostListModel>
    let packageUsecase: Observable<[ContainerSection]>
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
        return [BadgeModel(badgeId: 0, imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(badgeId: 1, imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(badgeId: 2, imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(badgeId: 3, imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(badgeId: 4, imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(badgeId: 5, imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(badgeId: 6, imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(badgeId: 7, imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(badgeId: 8, imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다"),
                BadgeModel(badgeId: 9, imagePath: "", title: "관심도 용기", discription: "설명문내용설명문내용설명문내용설명문내용", condition: "관심을가져야합니다")]
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
    var dummy: [ContainerSection] = []
    if LoginManager.shared.isLogin {
    dummy = [
        .init(id: 1, items: [
          .init(identity: "밀폐 용기/S", title: "밀폐 용기", size: "S", isFavorite: false),
          .init(identity: "밀폐 용기/M", title: "밀폐 용기", size: "M", isFavorite: false),
          .init(identity: "밀폐 용기/L", title: "밀폐 용기", size: "L", isFavorite: false)
        ]),
        
        .init(id: 2, items: [
          .init(identity: "냄비/S", title: "냄비", size: "S", isFavorite: false),
          .init(identity: "냄비/M", title: "냄비", size: "M", isFavorite: false),
          .init(identity: "냄비/L", title: "냄비", size: "L", isFavorite: false)
        ]),
        
        .init(id: 3, items: [
          .init(identity: "텀블러/S", title: "텀블러", size: "S", isFavorite: false),
          .init(identity: "텀블러/M", title: "텀블러", size: "M", isFavorite: false),
          .init(identity: "텀블러/L", title: "텀블러", size: "L", isFavorite: false)
        ]),
        
        .init(id: 4, items: [
          .init(identity: "보온 도시락/S", title: "보온 도시락", size: "S", isFavorite: false),
          .init(identity: "보온 도시락/M", title: "보온 도시락", size: "M", isFavorite: false),
          .init(identity: "보온 도시락/L", title: "보온 도시락", size: "L", isFavorite: false)
        ]),
        
        .init(id: 5, items: [
          .init(identity: "프라이팬/S", title: "프라이팬", size: "S", isFavorite: false),
          .init(identity: "프라이팬/M", title: "프라이팬", size: "M", isFavorite: false),
          .init(identity: "프라이팬/L", title: "프라이팬", size: "L", isFavorite: false)
        ]),
      ]
    }
    let packageUsecase = input.loadView.flatMapLatest{_ -> Observable<[ContainerSection]> in
      self.mutateUsecase(select: input.containerSelect, origin: dummy)
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
  func mutateUsecase(select: Observable<ContainerCellModel>,
                     origin : [ContainerSection]) -> Observable<[ContainerSection]> {
    enum Action {
      case select(model: ContainerCellModel)
    }
    return select.map(Action.select)
      .scan(into: origin) {state, action in
        switch action {
        case .select(model: let model):
          if model.isFavorite {
            model.delete()
          }
          else {
            model.add()
          }
          if state[0].id == 0,
             let section = UserDefaultStorage.myContainerSection{
            state[0] = section
          }
          else if let section = UserDefaultStorage.myContainerSection{
            state.append(section)
            state.sort(by: {$0.id < $1.id})
          }
        }
      }.startWith(origin)
      
  }
}
