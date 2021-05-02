//
//  MyPageViewModel.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/04/22.
//

import Foundation
import RxSwift
import RxCocoa
class MypageViewModel: ViewModel , ViewModelType {
  struct Input {
    let loadView : Observable<Void>
  }
  struct Output {
    let badgeUsecase: Observable<[BadgeModel]>
    let postUsecase: Driver<[PackageModel]>
    let packageUsecase: Driver<[PackageSectionType]>
  }
}
extension MypageViewModel {
  // contentCell에 바인딩
  func transform(input: Input) -> Output {
    weak var weakSelf = self
    let badgeUsecase = input.loadView.map{ _ in
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
    return .init(badgeUsecase: badgeUsecase,
                 postUsecase: .empty(),
                 packageUsecase: .empty())
  }
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
}
