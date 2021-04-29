//
//  PostMapViewController.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/22.
//

import Foundation
import NMapsMap
import SnapKit
import RxSwift
import RxCocoa

class PostMapViewController: ViewController {
  
  let myLocationButton = UIButton().then {
    $0.setImage(UIImage(named: "btnMapMyLocation"), for: .normal)
  }
  
  let postButton = UIButton().then {
    $0.setTitleColor(.white, for: .normal)
    $0.setTitle("이 가게 포스트 쓰기", for: .normal)
    $0.backgroundColor = .brandPrimary
    $0.contentVerticalAlignment = .top
    $0.titleEdgeInsets = UIEdgeInsets(top: 10.0,
                                      left: 0.0,
                                      bottom: 0.0,
                                      right: 0.0)
    
  }
  
  let storeInfoView = MapStoreInfoView()
  
  let mapView = NMFMapView().then{
    $0.allowsRotating = false
    $0.allowsTilting = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    
    guard let viewModel = viewModel as? PostMapViewModel else { return }
    
    let input = PostMapViewModel.Input(post: postButton.rx.tap.asObservable())
    
    let output = viewModel.transform(input: input)
    
    output.imageSelectionView
      .observeOn(MainScheduler.instance)
      .skip(1)
      .subscribe(onNext: { [weak self] viewModel in
        self?.navigator.show(segue: .selectImage(viewModel: viewModel), sender: self, transition: .navigation())
      }).disposed(by: disposeBag)
    
    output.setting
      .skip(1)
      .subscribe(onNext: { [weak self] _ in
        self?.showPermissionAlert()
      }).disposed(by: disposeBag)
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    postButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    postButton.layer.cornerRadius = 16.0
  }
  
  // MARK: - Setup Views and Layout
  override func configuration() {
    super.configuration()
    self.view.backgroundColor = .white
  }
  
  override func setupView() {
    super.setupView()
    self.view.addSubview(mapView)
    self.view.addSubview(myLocationButton)
    self.view.addSubview(postButton)
    self.view.addSubview(storeInfoView)
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    mapView.snp.makeConstraints {
      $0.edges.equalTo(view)
    }
    
    myLocationButton.snp.makeConstraints {
      $0.trailing.equalTo(-19)
      $0.bottom.equalTo(storeInfoView.snp.top).offset(-16)
      $0.width.height.equalTo(48)
    }
    
    postButton.snp.makeConstraints {
      $0.bottom.equalTo(self.view.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(88)
    }
    
    storeInfoView.snp.makeConstraints {
      $0.leading.equalTo(29)
      $0.trailing.equalTo(-29)
      $0.bottom.equalTo(postButton.snp.top).offset(-16)
    }
  }
  
  private func showPermissionAlert() {
    let alertController = UIAlertController(title: nil, message: "사진 기능을 사용하려면 '사진' 접근권한을 허용해야 합니다.", preferredStyle: .alert)
    alertController.addAction(.init(title: "설정", style: .default, handler: { _ in
      guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }))
    alertController.addAction(.init(title: "취소", style: .cancel))
    self.present(alertController, animated: true)
  }
  
}


