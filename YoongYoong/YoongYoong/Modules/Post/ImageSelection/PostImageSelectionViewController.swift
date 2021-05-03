//
//  PostImageSelectionViewController.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PostImageSelectionViewController: ViewController {
  private let photoPicker = UIImagePickerController()
  private let selectedImageContainer = PostImageContainer()
  private var pickerColletionView: UICollectionView!
  private let registButton = UIButton().then {
    $0.setTitle("선택", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = #colorLiteral(red: 0.6196078431, green: 0.9137254902, blue: 0.8039215686, alpha: 1)
    $0.layer.cornerRadius = 30
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = viewModel as? PostImageSelectionViewModel else { return }
    
    let input = PostImageSelectionViewModel.Input(itemSelected: pickerColletionView.rx.itemSelected.asObservable(),
                                                  itemDeselected: pickerColletionView.rx.itemDeselected.asObservable(),
                                                  registButtonDidTap: registButton.rx.tap.asObservable()
    )
    
    let output = viewModel.transform(input: input)
    
    output.photos
      .observeOn(MainScheduler.instance)
      .bind(to: pickerColletionView.rx.items(cellIdentifier: PostImageSelectionViewCell.reuseIdentifier, cellType: PostImageSelectionViewCell.self)) { row , asset, cell in
        if row == 0 {
          cell.setCameraView()
        } else {
          cell.setImage(asset)
          cell.cameraImageView.isHidden = true
          if let number = viewModel.selectedCellNumber(indexPath: IndexPath(row: row, section: 0)) {
            cell.setNumber(number)
          }
        }
        
      }.disposed(by: disposeBag)
    
    output.selectedPhotos
      .observeOn(MainScheduler.instance)
      .bind(to: selectedImageContainer.collectionView.rx.items(cellIdentifier: PostImageContainerCell.reuseIdentifier, cellType: PostImageContainerCell.self)) { [weak self] index, element, cell in
        guard let self = self else {return}
        cell.setImage(element.0)
        cell.didDelete = {
          viewModel.removeFromSelected(index)
          self.pickerColletionView.deselectItem(at: element.1, animated: false)
        }
        
      }.disposed(by: disposeBag)

    output.selectedPhotos
      .observeOn(MainScheduler.instance)
      .skip(1)
      .subscribe(onNext: { [weak self] item in
        guard let self = self else { return }
        for i in 0..<item.count {
          let indexPath = item[i].1
          if let cell = self.pickerColletionView.cellForItem(at: indexPath) as? PostImageSelectionViewCell {
            cell.setNumber(i+1)
            
          }
          
          
        }
        
      }).disposed(by: disposeBag)

    
    output.selectedPhotos
      .observeOn(MainScheduler.instance)
      .skip(1)
      .map { $0.count }
      .subscribe(onNext: { [weak self] count in
        guard let self = self else { return }
        
        self.selectedImageContainer.collectionView.scrollToItem(at: IndexPath(row: count-1, section: 0),
                                                                at: .right, animated: false)
        self.animateSelectedContainerView(count > 0)
        self.registButton.isEnabled = count > 0
        self.registButton.backgroundColor = count > 0 ? UIColor.brandPrimary : #colorLiteral(red: 0.6196078431, green: 0.9137254902, blue: 0.8039215686, alpha: 1)
        if count > 0 {
          self.registButton.setTitle("\(count)장 올리기", for: .normal)
        } else {
          self.registButton.setTitle("선택", for: .normal)
        }
      }).disposed(by: disposeBag)
    
    output.setting
      .observeOn(MainScheduler.instance)
      .skip(1)
      .subscribe(onNext: { [weak self] in
        self?.showPermissionAlert()
      }).disposed(by: disposeBag)
    
    output.presentCamera
      .observeOn(MainScheduler.instance)
      .skip(1)
      .subscribe(onNext: {  [weak self] in
        self?.presentCamera()
      }).disposed(by: disposeBag)
    
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let viewModel = viewModel as? PostImageSelectionViewModel else { return }

    let selectedItmes = viewModel.selected
    for i in 0..<selectedItmes.count {
      let indexPath = selectedItmes[i].1
      if let cell = self.pickerColletionView.cellForItem(at: indexPath) as? PostImageSelectionViewCell {
        cell.setNumber(i+1)
      }
    }
  
  }
  
  override func setupView() {
    super.setupView()
    view.adds([selectedImageContainer, pickerColletionView, registButton])
    
  }
  
  
  override func setupLayout() {
    super.setupLayout()
    selectedImageContainer.snp.makeConstraints {
      $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(0)
    }
    
    pickerColletionView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalTo(view)
      $0.top.equalTo(selectedImageContainer.snp.bottom)
    }
    
    registButton.snp.makeConstraints {
      $0.centerX.equalTo(view)
      $0.width.equalTo(144)
      $0.height.equalTo(55)
      $0.bottom.equalTo(view.snp.bottom).offset(-67)
    }
    
  }
  
  override func configuration() {
    super.configuration()
    view.backgroundColor = .white
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = PostImageSelectionViewCell.cellSize
    layout.minimumLineSpacing = 2
    layout.minimumInteritemSpacing = 2
    layout.sectionInset = UIEdgeInsets(top: 0,
                                       left: 2,
                                       bottom: 0,
                                       right: 2)
    pickerColletionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    pickerColletionView.register(PostImageSelectionViewCell.self, forCellWithReuseIdentifier: PostImageSelectionViewCell.reuseIdentifier)
    pickerColletionView.backgroundColor = .white
    pickerColletionView.allowsMultipleSelection = true
    pickerColletionView.rx.setDelegate(self).disposed(by: disposeBag)
    
  }
  
  // MARK: - Private
  private var hidden = true
  private func animateSelectedContainerView(_ flag: Bool) {
    guard hidden == flag else { return }
    hidden = !hidden
    self.selectedImageContainer.snp.updateConstraints {
      $0.height.equalTo(flag ? 80 : 0)
    }
  
    UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
  }
  
  private func presentCamera() {
    photoPicker.delegate = self
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      photoPicker.sourceType = .camera
    } else {
      photoPicker.sourceType = .photoLibrary
    }
    
    self.present(photoPicker, animated: true, completion: nil)
  }
  
  private func showPermissionAlert() {
    let alertController = UIAlertController(title: nil, message: "사진 기능을 사용하려면 '카메라' 접근권한을 허용해야 합니다.", preferredStyle: .alert)
    alertController.addAction(.init(title: "설정", style: .default, handler: { _ in
      guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }))
    alertController.addAction(.init(title: "취소", style: .cancel))
    self.present(alertController, animated: true)
  }
  
}


extension PostImageSelectionViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    
    if indexPath.row == 0 { return true }
    
    guard let indexPaths = collectionView.indexPathsForSelectedItems,
          indexPaths.count < 10 else { return false }
    
    return true
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard indexPath.row != 0 else {
      collectionView.deselectItem(at: indexPath, animated: false)
      return
    }
  }
  
}

extension PostImageSelectionViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
    picker.dismiss(animated: true, completion: nil)
    
    // TODO: Navigate
    
  }
  
}
