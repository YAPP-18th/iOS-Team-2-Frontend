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
  struct Input {
    let post: Observable<Void>
    let myLocationButtonDidTap: Observable<Void>
  }
  
  struct Output {
    let imageSelectionView: PublishRelay<PostImageSelectionViewModel>
    let setting: PublishRelay<Void>
    let storeInfo: BehaviorRelay<Place>
    let myLocation: BehaviorRelay<CLLocationCoordinate2D>
  }
  
  // ??
  var place: Place!
  
  func transform(input: Input) -> Output {
    let storeInfo = BehaviorRelay<Place>(value: self.place)
    let myLocation = BehaviorRelay<CLLocationCoordinate2D>(value: self.locationManager.locationChanged.value)
    let imageSelectionView = PublishRelay<PostImageSelectionViewModel>()
    let setting = PublishRelay<Void>()
    
    input.myLocationButtonDidTap
      .subscribe(onNext: { [weak self ] _ in
        guard let self = self else { return }
        myLocation.accept(self.locationManager.locationChanged.value)
      }).disposed(by: disposeBag)
    
    input.post.subscribe(onNext: { [weak self] _ in
      self?.photoLibraryAuthorization() { granted in
        guard granted else {
          setting.accept(())
          return
        }
        
        imageSelectionView.accept(PostImageSelectionViewModel())
      }
    }).disposed(by: disposeBag)
    
    return Output(imageSelectionView: imageSelectionView,
                  setting: setting,
                  storeInfo: storeInfo,
                  myLocation: myLocation)
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
