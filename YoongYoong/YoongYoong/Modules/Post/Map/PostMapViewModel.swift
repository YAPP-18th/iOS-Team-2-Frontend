//
//  PostMapViewModel.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/22.
//

import Foundation
import CoreLocation
import Photos
import RxCocoa
import RxSwift

class PostMapViewModel: ViewModel, ViewModelType {
  private let output = Output()
  
  struct Input {
    let post: Observable<Void>
  }
  
  struct Output {
    let imageSelectionView: BehaviorRelay<PostImageSelectionViewModel> = BehaviorRelay(value: PostImageSelectionViewModel())
    let setting: BehaviorRelay<Void> = BehaviorRelay(value: ())
  }
  
  func transform(input: Input) -> Output {
    input.post.subscribe(onNext: { [weak self] _ in
      self?.photoLibraryAuthorization() { granted in
        guard granted else {
          self?.permissionIsRequired()
          return
        }
        
        self?.output.imageSelectionView.accept(PostImageSelectionViewModel())
      }
    }).disposed(by: disposeBag)
    
    return output
  }
  
  private func permissionIsRequired() {
    output.setting.accept(())
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
  
  
}
