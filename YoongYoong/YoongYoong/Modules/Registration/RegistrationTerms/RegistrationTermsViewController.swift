//
//  RegistrationTermsViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/14.
//

import UIKit
import RxSwift
import RxCocoa

class RegistrationTermsViewController: ViewController {
  
  
  var viewModels: [TermsCheckItem.ViewModel] = [
    .init(id: 0, isChecked: false, title: "(필수) 서비스 이용약관"),
    .init(id: 1, isChecked: false, title: "(필수) 개인정보 처리방침"),
    .init(id: 2, isChecked: false, title: "(필수) 위치 기반 서비스"),
    .init(id: 3, isChecked: false, title: "(선택) 마케팅 정보 수신 동의")
  ]
  var isCheckedAll: Bool = false
  
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
      next: nextButton.rx.tap.map { [weak self] _ -> Bool in
        guard let self = self else { return false }
        return self.isCheckedAll
      }.asObservable()
    )
    
    checkAllButton.rx.tap.subscribe(onNext: { [weak self ] in
      guard let self = self else { return }
      for item in self.vStackView.arrangedSubviews {
        guard let v = item as? TermsCheckItem else {
          continue
        }
        self.viewModels[v.viewModel!.id].isChecked = !self.isCheckedAll
        v.viewModel?.isChecked = !self.isCheckedAll
      }
      self.validate()
    }).disposed(by: disposeBag)
    
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
    self.view.backgroundColor = .systemGray00
    self.setupBackButton()
    
    self.navigationItem.title = "약관 및 정책"
    self.nextButton.isEnabled = false
    
    for item in self.viewModels {
      let itemView = TermsCheckItem().then {
        $0.checkClosure = { checked in
          self.viewModels[item.id].isChecked = checked
          self.validate()
        }
//        $0.detailClosure = { hostType in
//          if let vc = self.parentViewController as? MembershipConnectTermsListViewController {
//            vc.interactor?.hostType = hostType
//            vc.router?.routeToMembershipConnectTermsDetail()
//          }
//        }
      }
      self.vStackView.addArrangedSubview(itemView)
      itemView.viewModel = item
      itemView.snp.makeConstraints {
        $0.height.equalTo(32)
      }
    }
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
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-46)
      $0.leading.equalTo(24)
      $0.trailing.equalTo(-24)
      $0.height.equalTo(44)
    }
  }
  
  private func validate() {
    if self.viewModels.filter({ $0.id != 3 }).contains(where: { $0.isChecked == false }) {
      self.isCheckedAll = false
      self.checkAllButton.setImage(UIImage(named: "icRegUnchecked"), for: .normal)
      self.nextButton.isEnabled = false
    } else {
      if viewModels[3].isChecked {
        self.isCheckedAll = true
        self.checkAllButton.setImage(UIImage(named: "icRegChecked"), for: .normal)
      } else {
        self.isCheckedAll = false
        self.checkAllButton.setImage(UIImage(named: "icRegUnchecked"), for: .normal)
      }
      self.nextButton.isEnabled = true
    }
  }
}
