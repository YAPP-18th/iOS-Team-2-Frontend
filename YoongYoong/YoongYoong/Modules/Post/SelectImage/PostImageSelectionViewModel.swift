//
//  PostImageSelectionViewModel.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/23.
//

import Foundation
import Photos
import RxCocoa
import RxSwift

class PostImageSelectionViewModel: ViewModel, ViewModelType {
  private var output = Output()
  private var allPhoto = [PHAsset]()
  var selected = [(PHAsset, IndexPath)]()
  
  struct Input {
    let itemSelected: Observable<IndexPath>
    let itemDeselected: Observable<IndexPath>
    let registButtonDidTap: Observable<Void>
  }
  
  struct Output {
    let photos: BehaviorRelay<[PHAsset]> = BehaviorRelay(value: [])
    var selectedPhotos: BehaviorRelay<[(PHAsset, IndexPath)]> = BehaviorRelay(value: [])
    let setting: BehaviorRelay<Void> = BehaviorRelay(value: ())
    let presentCamera: BehaviorRelay<Void> = BehaviorRelay(value: ())
    var selectMenuView: Observable<SelectMenuViewModel> = Observable.of(SelectMenuViewModel())
  }

  func removeFromSelected(_ index: Int) {
    selected.remove(at: index)
    output.selectedPhotos.accept(self.selected)
  }
  
  func transform(input: Input) -> Output {
    self.fetchPHAssets()
    
    input.itemSelected
      .filter { $0.row == 0 }
      .subscribe(onNext: { [weak self] _ in
        self?.cameraAuthorization { granted in
          guard granted else {
            self?.permissionIsRequired()
            return
          }
          self?.output.presentCamera.accept(())
        }
      }).disposed(by: disposeBag)
    
    input.itemSelected
      .filter { $0.row > 0 }
      .map{ (self.allPhoto[$0.row], $0) }
      .subscribe(onNext:{ [weak self] item in
        guard let self = self else { return }
        self.selected.append(item)
        self.output.selectedPhotos.accept(self.selected)
      }).disposed(by: disposeBag)
    
    input.itemDeselected
      .filter { $0.row > 0 }
      .map{ (self.allPhoto[$0.row], $0) }
      .subscribe(onNext: { [weak self] item in
        guard let self = self else { return }
        for i in 0..<self.selected.count {
          if item.0 === self.selected[i].0 {
            self.selected.remove(at: i)
            self.output.selectedPhotos.accept(self.selected)
            return
          }
        }
        
      }).disposed(by: disposeBag)
    
    output.selectMenuView = input.registButtonDidTap
      .map { _ in return SelectMenuViewModel() }
    
    return output
  }
  
  func selectedCellNumber(indexPath: IndexPath) -> Int? {
    for i in 0..<selected.count {
      if selected[i].1 == indexPath {
        return i+1
      }
    }
    
    return nil
  }
  
  private func permissionIsRequired() {
    output.setting.accept(())
  }

  private func fetchPHAssets() {
    let fetchOptions = PHFetchOptions().then {
      $0.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    }
    let fetchResults = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    let photoAssets = [PHAsset.init()] + fetchResults.objects(at: IndexSet(0..<fetchResults.count))
    allPhoto = photoAssets
    output.photos.accept(photoAssets)
  }
  
  
  private func cameraAuthorization(_ completion: @escaping (Bool) -> Void) {
    
    switch  AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      completion(true)
    case .denied, .restricted:
      completion(false)
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { completion($0) }
    default:
      break
    }
  }
  
}
