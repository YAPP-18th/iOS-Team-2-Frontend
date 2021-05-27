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
  private var fetchResults = PHFetchResult<PHAsset>()
  private var allPhotos = [PHAsset]()
  var selected = [(PHAsset, IndexPath)]()
  
  struct Input {
    let itemSelected: Observable<IndexPath>
    let itemDeselected: Observable<IndexPath>
    let topCellDidDelete: PublishSubject<Int>
    let registButtonDidTap: Observable<Void>
    let newPhotoSaved: PublishSubject<Void>
  }
  
  struct Output {
    let photos: BehaviorRelay<[PHAsset]>
    let selectedPhotos: PublishRelay<[(PHAsset, IndexPath)]>
    let setting: PublishRelay<Void>
    let presentCamera: PublishRelay<Void>
    let selectMenuView: PublishRelay<SelectMenuViewModel>
  }

  func transform(input: Input) -> Output {
    PHPhotoLibrary.shared().register(self)

    self.fetchPHAssets()
    let photos = BehaviorRelay<[PHAsset]>(value: allPhotos)
    let presentCamera = PublishRelay<Void>()
    let setting = PublishRelay<Void>()
    let selectedPhotos = PublishRelay<[(PHAsset, IndexPath)]>()
    let selectMenuView = PublishRelay<SelectMenuViewModel>()
    
    photosTrigger.bind(to: photos).disposed(by: disposeBag)
    
    
    
    input.newPhotoSaved
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.photoLibraryDidChange = false
        self.selected.removeAll()
        selectedPhotos.accept(self.selected)
      }).disposed(by: disposeBag)
    
    // 카메라 셀
    input.itemSelected
      .filter { $0.row == 0 }
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.cameraAuthorization { granted in
          guard granted else {
            setting.accept(())
            return
          }
          presentCamera.accept(())
        }
      }).disposed(by: disposeBag)
    
    // 사진 셀
    input.itemSelected
      .filter { $0.row > 0 }
      .map{ (self.allPhotos[$0.row], $0) }
      .subscribe(onNext:{ [weak self] item in
        guard let self = self else { return }
        self.selected.append(item)
        selectedPhotos.accept(self.selected)
      }).disposed(by: disposeBag)
    
    input.itemDeselected
      .filter { $0.row > 0 }
      .map{ (self.allPhotos[$0.row], $0) }
      .subscribe(onNext: { [weak self] item in
        guard let self = self else { return }
        for i in 0..<self.selected.count {
          if item.0 === self.selected[i].0 {
            self.selected.remove(at: i)
            selectedPhotos.accept(self.selected)
            return
          }
        }
        
      }).disposed(by: disposeBag)
    
    input.topCellDidDelete
      .subscribe(onNext: { [weak self] index in
        guard let self = self else { return }
        self.selected.remove(at: index)
        selectedPhotos.accept(self.selected)
      }).disposed(by: disposeBag)
    
    input.registButtonDidTap
      .map { _ in return SelectMenuViewModel() }
      .bind(to: selectMenuView)
      .disposed(by: disposeBag)
    
    return Output(photos: photos,
                  selectedPhotos: selectedPhotos,
                  setting: setting,
                  presentCamera: presentCamera,
                  selectMenuView: selectMenuView)
  }
  
  func selectedCellNumber(indexPath: IndexPath) -> Int? {
    for i in 0..<selected.count {
      if selected[i].1 == indexPath {
        return i+1
      }
    }
    
    return nil
  }

  private var photosTrigger = PublishRelay<[PHAsset]>()
  private func fetchPHAssets() {

    let fetchOptions = PHFetchOptions().then {
      $0.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    }
    fetchResults = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    let photoAssets = [PHAsset.init()] + fetchResults.objects(at: IndexSet(0..<fetchResults.count))
    allPhotos = photoAssets
    photosTrigger.accept(allPhotos)
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
  var photoLibraryDidChange = false

}

extension PostImageSelectionViewModel: PHPhotoLibraryChangeObserver {
  func photoLibraryDidChange(_ changeInstance: PHChange) {
    guard !photoLibraryDidChange else { return }
    if let changed = changeInstance.changeDetails(for: fetchResults) {
        fetchResults = changed.fetchResultAfterChanges
      DispatchQueue.main.async {
        self.fetchPHAssets()

      }
      photoLibraryDidChange = true

    }
  }
  
  
}
