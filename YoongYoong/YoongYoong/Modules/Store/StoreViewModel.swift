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
    let imageSelectionView: PublishRelay<PostImageSelectionViewModel>
    let setting: PublishRelay<Void>
  }
  
  func transform(input: Input) -> Output {
    let imageSelectionView = PublishRelay<PostImageSelectionViewModel>()
    let setting = PublishRelay<Void>()
    input.post.subscribe(onNext: { [weak self] _ in
      self?.photoLibraryAuthorization() { granted in
        guard granted else {
          setting.accept(())
          return
        }
        
        imageSelectionView.accept(PostImageSelectionViewModel())
      }
    }).disposed(by: disposeBag)
    
    return .init(
      place: .just(self.place),
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
    
  }
  
  func getPostList() {
    
  }
}
