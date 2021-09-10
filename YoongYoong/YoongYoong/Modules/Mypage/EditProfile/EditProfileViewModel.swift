//
//  EditProfileViewModel.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/02.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class EditProfileViewModel : ViewModel, ViewModelType {
  private let service = AuthorizeService(provider: APIProvider(plugins:[NetworkLoggerPlugin()]))
  struct Input {
    let loadView : Observable<Void>
    let ProfileImage : Observable<UIImage>
    let nameText: Observable<String>
    let commentText: Observable<String>
    let changeAction: Observable<(String, String)>
  }
  struct Output {
    let changeBtnActivate: Driver<Bool>
    let nameTextCount : Driver<Int>
    let commentTextCount: Driver<Int>
    let profile:Observable<ProfileModel>
  }
  
  let profileChanged = PublishSubject<Void>()
}
extension EditProfileViewModel {
  func transform(input: Input) -> Output {
    let currentProfile = input.loadView.map{_ in
      ProfileModel(imagePath: "", name: "김용기", message: "안녕하세용", userId: 0)
    }
    let textValidate = Observable.combineLatest(input.nameText , input.commentText).map{ (name, comment) -> Bool in
      let firstCondition = name.count < 13 && !name.isEmpty
      let secondCondition = comment.count < 50 && !comment.isEmpty
      return firstCondition && secondCondition
    }
    let nicknameCheck = input.nameText.flatMap {
      self.service.checkNickNameDuplicate($0)
    }
    
    input.changeAction.subscribe(onNext: { nickName, introduction in
      self.updateProfile(nickname: nickName, introduction: introduction)
    }).disposed(by: disposeBag)
    
    let combined = Observable.combineLatest(textValidate, nicknameCheck).map{ $0.0 && $0.1}
    
    let nameCount = input.nameText.map{$0.count}
    let commentCount = input.commentText.map{$0.count}
    return .init(changeBtnActivate: combined.asDriver(onErrorDriveWith: .empty()),
                 nameTextCount: nameCount.asDriver(onErrorDriveWith: .empty()),
                 commentTextCount: commentCount.asDriver(onErrorDriveWith: .empty()),
                 profile: currentProfile)
  }
  
  private func updateProfile(nickname: String, introduction: String) {
  let param = ModifyProfileParam(id: globalUser.value.id, introduction: introduction, nickname: nickname)
    service.editProfile(param).subscribe(onNext: { result in
      if result {
        self.profileChanged.onNext(())
      }
    }).disposed(by: disposeBag)
  }
}
