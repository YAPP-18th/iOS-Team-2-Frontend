//
//  StoreViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/02.
//

import UIKit

class StoreViewController: ViewController {
  let vStackView = ScrollStackView().then {
    $0.contentInset.bottom = 88
  }
  private let topContainerView = UIView().then {
    $0.backgroundColor = .brandColorTertiary01
  }
  private let backButton = UIButton().then {
    $0.setImage(UIImage(named: "icBtnNavBackWhite"), for: .normal)
    $0.contentMode = .center
  }
  
  private let nameLabel = UILabel().then {
    $0.text = "김밥나라"
    $0.textColor = .white
    $0.font = .krDisplay
  }
  
  private let distanceLabel = UILabel().then {
    $0.text = "600m"
    $0.textColor = .white
    $0.font = .krTitle1
  }
  
  private let locationImageView = UIImageView().then {
    $0.image = UIImage(named: "icStorePin")
  }
  
  private let addressLabel = UILabel().then {
    $0.text = "서울 송파구 송파대로 106-17"
    $0.font = .krBody2
    $0.textColor = .white
  }
  
  private let yonggiView = StoreYonggiView()
  
  private let tableView = DynamicHeightTableView().then {
    $0.backgroundColor = .brandColorBlue03
  }
  
  private let postButton = UIButton().then {
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .krButton1
    $0.setTitle("이 가게 포스트 쓰기", for: .normal)
    $0.backgroundColor = .brandColorGreen01
    $0.contentVerticalAlignment = .top
    $0.titleEdgeInsets = UIEdgeInsets(top: 10.0,
                                      left: 0.0,
                                      bottom: 0.0,
                                      right: 0.0)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    postButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    postButton.layer.cornerRadius = 16.0
  }
  
  override func configuration() {
    super.configuration()
  }
  
  override func setupView() {
    super.setupView()
    self.view.addSubview(vStackView)
    self.view.addSubview(postButton)
    [topContainerView, yonggiView, tableView].forEach {
      vStackView.addArrangedSubview($0)
    }
    
    [backButton, nameLabel, distanceLabel, locationImageView, addressLabel].forEach {
      topContainerView.addSubview($0)
    }
  }
  
  override func setupLayout() {
    vStackView.snp.makeConstraints {
      $0.edges.bottom.equalToSuperview()
    }
    
    backButton.snp.makeConstraints {
      $0.top.equalTo(44)
      $0.leading.equalToSuperview()
      $0.width.height.equalTo(40)
    }
    
    nameLabel.snp.makeConstraints {
      $0.top.equalTo(backButton.snp.bottom).offset(24)
      $0.leading.equalTo(16)
    }
    
    distanceLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(12)
      $0.leading.equalTo(16)
    }
    
    locationImageView.snp.makeConstraints {
      $0.top.equalTo(distanceLabel.snp.bottom).offset(12)
      $0.leading.equalTo(16)
      $0.width.height.equalTo(20)
      $0.bottom.equalTo(-52)
    }
    
    addressLabel.snp.makeConstraints {
      $0.leading.equalTo(locationImageView.snp.trailing).offset(2)
      $0.centerY.equalTo(locationImageView)
    }
    
    tableView.snp.makeConstraints {
      $0.height.equalTo(1000)
    }
    
    postButton.snp.makeConstraints {
      $0.bottom.equalTo(self.view.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(88)
    }
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = self.viewModel as? StoreViewModel else { return }
    let input = StoreViewModel.Input()
    let output = viewModel.transform(input: input)
    
    output.place.drive(onNext: { place in
      self.nameLabel.text = place.name
      self.distanceLabel.text = place.distance + "m"
      self.addressLabel.text = place.address
    }).disposed(by: disposeBag)
  }
}
