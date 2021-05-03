//
//  EditProfileViewModel.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/02.
//

import Foundation
import RxSwift
import RxCocoa

class EditProfileViewModel : ViewModel, ViewModelType {
  struct Input {
    let loadView : Observable<Void>
    let ProfileImage : Observable<UIImage>
    let nameText: Observable<String>
    let commentText: Observable<String>
    let changeAction: Observable<Void>
  }
  struct Output {
    let changeBtnActivate: Driver<Bool>
    let nameTextCount : Driver<Int>
    let commentTextCount: Driver<Int>
    let profile:Observable<ProfileModel>
  }
}
extension EditProfileViewModel {
  func transform(input: Input) -> Output {
    let currentProfile = input.loadView.map{_ in
      ProfileModel(imagePath: "", name: "김용기", message: "안녕하세용", userId: 0)
    }
    let combined = Observable.combineLatest(input.nameText , input.commentText).map{ (name, comment) -> Bool in
      let firstCondition = name.count < 13 && !name.isEmpty
      let secondCondition = comment.count < 50 && !comment.isEmpty
      return firstCondition && secondCondition
    }
    let nameCount = input.nameText.map{$0.count}
    let commentCount = input.commentText.map{$0.count}
    return .init(changeBtnActivate: combined.asDriver(onErrorDriveWith: .empty()),
                 nameTextCount: nameCount.asDriver(onErrorDriveWith: .empty()),
                 commentTextCount: commentCount.asDriver(onErrorDriveWith: .empty()),
                 profile: currentProfile)
  }
}
