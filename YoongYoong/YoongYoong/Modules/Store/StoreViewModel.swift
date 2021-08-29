//
//  StoreViewModel.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/02.
//

import UIKit
import RxSwift
import Photos
import RxCocoa

class StoreViewModel: ViewModel, ViewModelType {
  let place: Place
  private let provider: PostService
  
  init(place: Place, provider: PostService = .init()) {
    self.place = place
    self.provider = provider
  }
  
  struct Input {
    let post: Observable<Void>
  }
  
  struct Output {
    let place: Driver<Place>
    let login: PublishSubject<Void>
    let imageSelectionView: PublishRelay<PostImageSelectionViewModel>
    let setting: PublishRelay<Void>
  }
  
  let containerList = BehaviorRelay<[ContainerDTO]>(value: [])
  let postList = BehaviorRelay<[PostResponse]>(value: [])
  let detail = PublishSubject<FeedDetailViewModel>()
  
  func transform(input: Input) -> Output {
    let imageSelectionView = PublishRelay<PostImageSelectionViewModel>()
    let login = PublishSubject<Void>()
    let setting = PublishRelay<Void>()
    input.post.subscribe(onNext: { [weak self] _ in
      if LoginManager.shared.isLogin, LoginManager.shared.loginStatus == .logined {
        self?.photoLibraryAuthorization() { granted in
          guard granted else {
            setting.accept(())
            return
          }
          
          imageSelectionView.accept(PostImageSelectionViewModel())
        }
      } else {
        login.onNext(())
      }
      
    }).disposed(by: disposeBag)
    
    return .init(
      place: .just(self.place),
      login: login,
      imageSelectionView: imageSelectionView,
      setting: setting
    )
  }
  
  private func photoLibraryAuthorization(_ completion: @escaping (Bool) -> Void) {
    switch PHPhotoLibrary.authorizationStatus() {
    case .authorized, .limited:
      completion(true)
    case .denied:
      completion(false)
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization { (status) in
        if #available(iOS 14, *) {
          completion(status == .authorized || status == .limited)
        } else {
          completion(status == .authorized)
        }
      }
      
    default:
      break
    }
    
  }
  
  func getContainerInfo() {
    provider.storeContainer(place: place)
      .subscribe(onNext: { result in
        switch result {
        case .success(let list):
          self.containerList.accept(list)
        case .failure(let error):
          print(error.localizedDescription)
        }
      }).disposed(by: self.disposeBag)
  }
  
  func getPostList() {
    provider.storePosts(place: place)
      .subscribe(onNext: { result in
          switch result {
          case .success(let list):
            self.postList.accept(list)
          case .failure(let error):
            print(error.localizedDescription)
          }
      }).disposed(by: self.disposeBag)
  }
  
  func goToFeedDetail(_ indexPath: IndexPath) {
    let value = self.postList.value[indexPath.row]
    let viewModel = FeedDetailViewModel(feed: value)
    self.detail.onNext(viewModel)
  }
}
