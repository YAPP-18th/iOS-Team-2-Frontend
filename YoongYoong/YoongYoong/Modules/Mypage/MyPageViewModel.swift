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
  private let authService : AuthorizeServiceType = AuthorizeService(provider: MoyaProvider<AuthRouter>(plugins:[NetworkLoggerPlugin()]))
  
  let currentMonth = BehaviorRelay<Int>(value: Int(Date().month) ?? 6)
  let postList = BehaviorRelay<PostListModel>(value: .sample)
  struct Input {
    let containerSelect: Observable<ContainerCellModel>
    let selectBadge: Observable<IndexPath>
  }
  struct Output {
    let messageIndicator: Observable<[String]>
    let containers: Observable<[ContainerSection]>
    let badgeList: Driver<[MyBadgeSection]>
    let selectedBadge: Observable<BadgeModel>
  }
}
extension MypageViewModel {
  // contentCell에 바인딩
  func changeCurrentMonth(for changed: Int) {
    currentMonth.accept(changed)
    getPostList()
  }
  func transform(input: Input) -> Output {
    let message = postList.map{ model -> [String] in
        return ["용기를 내고 배지를 모아보세요",
                "지금까지 총 \(model.packageCount)개의 용기를 냈어요!",
                "자주 사용하는 용기를 등록하세요!"]
      }
    var dummy: [ContainerSection] = []
    if LoginManager.shared.isLogin {
      dummy = getContainers()
    }
    let containerItems = BehaviorSubject<[ContainerSection]>(value: dummy)
    
    let badgeArr = [BadgeModel(badgeId: 0, imagePath: "icBadge001", title: "관심도 용기", discription: "처음으로 다른 사람의 포스트에\n좋아요를 누르면 드려요", condition: "다른 사람 포스트에 첫 좋아요를 누를 시"),
                    BadgeModel(badgeId: 1, imagePath: "icBadge002", title: "첫 용기", discription: "깨끗한 지구를 위한 첫 걸음!\n당신의 용기 덕분이예요", condition: "첫 포스트를 올릴 시 획득"),
                    BadgeModel(badgeId: 2, imagePath: "icBadge003", title: "작심삼일 극복!", discription: "연속 3일이상 포스트를 작성해보세요", condition: "연속 3일 이상 포스트를 올릴 시"),
                    BadgeModel(badgeId: 3, imagePath: "icBadge004", title: "말 건내는 용기", discription: "처음으로 다른 사람의 포스트에 댓글을 달면 드려요", condition: "다른 사람 포스트에 첫 댓글을 달면"),
                    BadgeModel(badgeId: 4, imagePath: "icBadge005", title: "레스웨이스트", discription: "포스트를 10개 이상 올려보세요", condition: "포스트 10개 이상 올릴 시"),
                    BadgeModel(badgeId: 5, imagePath: "icBadge006", title: "이목집중 용기왕", discription: "다른 사람으로부터 좋아요를 총 20개 받아보세요!", condition: "내가 쓴 포스트의 좋아요가 누적 20개 넘을 시"),
                    BadgeModel(badgeId: 6, imagePath: "icBadge007", title: "용기 마당발", discription: "총 30개의 가게에서 용기를 사용하면 드려요", condition: "용기 등록한 가게가 30개 넘을 시"),
                    BadgeModel(badgeId: 7, imagePath: "icBadge008", title: "세계최고 환경 지킴이", discription: "포스트를 100개 이상 올려보세요", condition: "포스트 100개 이상 올릴 시"),
                    BadgeModel(badgeId: 8, imagePath: "icBadge009", title: "용기 매니아", discription: "서로 다른 용기를 3개 이상을 포스트에 등록하세요", condition: "서로 다른 용기 3개 이상 포스트 등록했을 시"),
                    BadgeModel(badgeId: 9, imagePath: "icBadge010", title: "단골 손님", discription: "한 가게에 두 개 이상의 포스트를 작성해보세요", condition: "한 가게에 대해 두 번 이상 포스트를 올릴 시"),
                    BadgeModel(badgeId: 10, imagePath: "icBadge011", title: "제로 웨이스트", discription: "포스트를 10개 이상 올려보세요", condition: "포스트 10개 이상 올릴 시"),
                    BadgeModel(badgeId: 11, imagePath: "icBadge012", title: "용기의 달인", discription: "포스트를 30개 이상 올려보세요", condition: "포스트 30개 이상 올릴 시")
            ]
    let selectedBadge = input.selectBadge.map { badgeArr[$0.row] }.asObservable()
    let badgeList = Observable.of(badgeArr).map { list -> [MyBadgeSection] in
      let section = MyBadgeSection(items: list)
      return [section]
    }.asDriver(onErrorJustReturn: [])
    return .init(
      messageIndicator: message,
      containers: containerItems,
      badgeList: badgeList,
      selectedBadge: selectedBadge
    )
    
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
  
  private func getContainers() -> [ContainerSection] {
    return [
      .init(id: 0, items: []),
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
  
  func getUserInfo() {
    authService.getProfile()
  }
  
  func getPostList() {
    let month = currentMonth.value
    if LoginManager.shared.isLogin {
      let myPost =  self.service.fetchMyPost(month: month)
      myPost.subscribe(onNext: { response in
        let containerCount = response.map {
          $0.postContainers.reduce(0) {
            return $0 + $1.containerCount
          }
        }.reduce(0, +)
        let model = PostListModel(
          month: "2021년 \(month)월",
          postCount: response.count,
          packageCount: containerCount,
          postList: response
        )
        self.postList.accept(model)
      }).disposed(by: disposeBag)
    }
  }
}
