//
//  RegistrationTermsViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/14.
//

import UIKit

class RegistrationTermsViewController: ViewController {
  
  let titleLabel = UILabel().then {
    $0.text = "환영합니다!"
    $0.font = .krTitle1
    $0.textColor = .systemGrayText01
  }
  
  let checkAllButton = UIButton().then {
    $0.setImage(UIImage(named: "icRegUnchecked"), for: .normal)
    $0.adjustsImageWhenHighlighted = false
  }
  
  let checkAllLabel = UILabel().then {
    $0.text = "전체 동의"
    $0.font = .krCaption1
    $0.textColor = .systemGrayText01
  }
  
  let divider = UIView().then {
    $0.backgroundColor = .systemGray05
  }
  
  let vStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 16
  }
  
  let nextButton = Button().then {
    $0.setTitle("다음", for: .normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = self.viewModel as? RegistrationTermsViewModel else { return }
    let input = RegistrationTermsViewModel.Input(
      next: self.nextButton.rx.tap.asObservable()
    )
    
    let output = viewModel.transform(input: input)
    
    output.registrationEmail.drive(onNext: { viewModel in
      self.navigator.show(segue: .registrationEmail(viewModel: viewModel), sender: self, transition: .navigation(.right))
    }).disposed(by: disposeBag)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  override func configuration() {
    super.configuration()
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "icBtnNavBack")?
        .withRenderingMode(.alwaysOriginal),
      style: .plain,
      target: self,
      action: #selector(backButtonTapped)
    )
    
    self.navigationItem.title = "약관 및 정책"
    self.nextButton.isEnabled = true
  }
  
  @objc func backButtonTapped() {
    
  }
  
  override func setupView() {
    super.setupView()
    [titleLabel, checkAllButton, checkAllLabel, divider, vStackView, nextButton].forEach {
      self.view.addSubview($0)
    }
  }
  
  override func setupLayout() {
    super.setupLayout()
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(32)
      $0.leading.equalTo(24)
    }
    
    checkAllButton.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(39)
      $0.leading.equalTo(24)
      $0.width.height.equalTo(24)
    }
    
    checkAllLabel.snp.makeConstraints {
      $0.leading.equalTo(checkAllButton.snp.trailing).offset(10)
      $0.centerY.equalTo(checkAllButton)
    }
    
    divider.snp.makeConstraints {
      $0.top.equalTo(checkAllButton.snp.bottom).offset(8)
      $0.leading.equalTo(24)
      $0.trailing.equalTo(-24)
      $0.height.equalTo(1)
    }
    
    vStackView.snp.makeConstraints {
      $0.top.equalTo(divider.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview()
    }
    
    let viewModelList: [TermsCheckItem.ViewModel] = [
      .init(isChecked: true, title: "(필수) 서비스 이용약관", detail: ""),
      .init(isChecked: false, title: "(필수) 개인정보 처리방침", detail: ""),
      .init(isChecked: true, title: "(필수) 위치 기반 서비스", detail: ""),
      .init(isChecked: false, title: "(선택) 마케팅 정보 수신 동의", detail: "")
    ]
    
    for viewModel in viewModelList {
      let checkItem = TermsCheckItem()
      checkItem.viewModel = viewModel
      self.vStackView.addArrangedSubview(checkItem)
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-46)
      $0.leading.equalTo(24)
      $0.trailing.equalTo(-24)
      $0.height.equalTo(44)
    }
  }
}
