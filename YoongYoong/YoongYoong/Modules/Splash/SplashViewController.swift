//
//  SplashViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SplashViewController: ViewController {
  
  let logoImageView = UIImageView().then {
    $0.image = UIImage(named: "icSplashLogo")
    $0.contentMode = .scaleAspectFit
  }
  
  let bottomLabel = UILabel().then {
    $0.text = "지금까지 낸 용기 8937개"
    $0.textColor = .white
    $0.font = .krTitle2
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      guard let viewModel = self.viewModel as? SplashViewModel else {
        return
      }
      viewModel.splashTrigger.onNext(())
    }
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = self.viewModel as? SplashViewModel else { return }
    let input = SplashViewModel.Input()
    let output = viewModel.transform(input: input)
    
    output.login.bind{ viewModel in
      self.navigator.show(segue: .login(viewModel: viewModel), sender: self, transition: .root(in: self.view.window!))
    }.disposed(by: disposeBag)
    
    output.onboard.bind { _ in
      self.navigator.show(segue: .onboarding(viewModel: nil), sender: self, transition: .root(in: self.view.window!))
    }.disposed(by: disposeBag)
    
    output.main.bind { viewModel in
      self.navigator.show(segue: .tabs(viewModel: viewModel), sender: self, transition: .root(in: self.view.window!))
    }.disposed(by: disposeBag)
  }
  
  override func configuration() {
    super.configuration()
    self.view.backgroundColor = .brandColorGreen01
  }
  
  override func setupView() {
    super.setupView()
    [logoImageView, bottomLabel].forEach {
      self.view.addSubview($0)
    }
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    logoImageView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    bottomLabel.snp.makeConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
      $0.centerX.equalToSuperview()
    }
    
  }
}
