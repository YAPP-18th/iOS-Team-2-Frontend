//
//  LoginViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/13.
//

import UIKit

class LoginViewController: ViewController {
  let scrollView = ScrollStackView().then {
    $0.showsVerticalScrollIndicator = false
  }
  
  let contentView = UIView()
  
  let logoImageView = UIImageView().then {
    $0.image = UIImage(named: "icLoginLogo")
    $0.contentMode = .scaleAspectFit
  }
  
  let emailField = UITextField().then {
    $0.borderStyle = .none
    $0.placeholder = "이메일"
    $0.font = .krBody2
    $0.textColor = .systemGray01
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
  }
  
  let emailDivider = UIView().then {
    $0.backgroundColor = .systemGray05
  }
  
  let passwordField = UITextField().then {
    $0.borderStyle = .none
    $0.placeholder = "비밀번호"
    $0.font = .krBody2
    $0.textColor = .systemGray01
    $0.isSecureTextEntry = true
  }
  
  let passwordDivider = UIView().then {
    $0.backgroundColor = .systemGray05
  }
  
  let loginButton = UIButton().then {
    $0.layer.cornerRadius = 22
    $0.backgroundColor = .brandColorGreen02
    $0.setTitle("로그인", for: .normal)
    $0.titleLabel?.font = .krButton1
    $0.setTitleColor(.brandColorGreen03, for: .normal)
  }
  
  let findPasswordButton = UIButton().then {
    $0.setTitle("비밀번호 찾기", for: .normal)
    $0.setTitleColor(.systemGray02, for: .normal)
    $0.titleLabel?.font = .krCaption1
  }
  
  let signInWithAppleButton = UIButton().then {
    $0.setImage(UIImage(named: "icLoginButtonApple"), for: .normal)
    $0.layer.cornerRadius = 22
    $0.layer.masksToBounds = true
  }
  
  let signInWithKakaoButton = UIButton().then {
    $0.setImage(UIImage(named: "icLoginButtonKakao"), for: .normal)
    $0.layer.cornerRadius = 22
    $0.layer.masksToBounds = true
  }
  
  let skipLoginButton = UIButton().then {
    $0.setTitle("로그인 없이 둘러볼게요", for: .normal)
    $0.setTitleColor(.brandColorGreen01, for: .normal)
    $0.titleLabel?.font = .krButton1
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 22
    $0.layer.borderColor = UIColor.systemGray05.cgColor
    $0.layer.borderWidth = 1
  }
  
  let registContainer = UIView()
  let registLabel = UILabel().then {
    $0.text = "용기내용이 처음이신가요?"
    $0.textColor = .systemGrayText01
    $0.font = .krCaption2
  }
  
  let registButton = UIButton().then {
    $0.setTitle("회원가입", for: .normal)
    $0.setTitleColor(.brandColorSecondary01, for: .normal)
    $0.titleLabel?.font = .krCaption1
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func configuration() {
    super.configuration()
    self.view.backgroundColor = .white
  }
  
  override func setupView() {
    super.setupView()
    self.view.addSubview(scrollView)
    scrollView.addArrangedSubview(contentView)
    [
      logoImageView, emailField, emailDivider, passwordField, passwordDivider,
      loginButton, findPasswordButton, signInWithAppleButton, signInWithKakaoButton, skipLoginButton, registContainer
    ].forEach {
      self.contentView.addSubview($0)
    }
    [registLabel, registButton].forEach {
      registContainer.addSubview($0)
    }
  }
  
  override func setupLayout() {
    super.setupLayout()
    scrollView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    logoImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(110)
      $0.width.equalTo(88.3)
      $0.height.equalTo(102)
    }
    emailField.snp.makeConstraints {
      $0.top.equalTo(logoImageView.snp.bottom).offset(64)
      $0.leading.equalTo(32)
      $0.trailing.equalTo(-32)
      $0.height.equalTo(32)
    }
    emailDivider.snp.makeConstraints {
      $0.top.equalTo(emailField.snp.bottom)
      $0.leading.equalTo(24)
      $0.trailing.equalTo(-24)
      $0.height.equalTo(1)
    }
    passwordField.snp.makeConstraints {
      $0.top.equalTo(emailDivider.snp.bottom).offset(16)
      $0.leading.equalTo(32)
      $0.trailing.equalTo(-32)
      $0.height.equalTo(32)
    }
    passwordDivider.snp.makeConstraints {
      $0.top.equalTo(passwordField.snp.bottom)
      $0.leading.equalTo(24)
      $0.trailing.equalTo(-24)
      $0.height.equalTo(1)
    }
    
    loginButton.snp.makeConstraints {
      $0.top.equalTo(passwordDivider.snp.bottom).offset(28)
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-16)
      $0.height.equalTo(44)
    }
    
    findPasswordButton.snp.makeConstraints {
      $0.top.equalTo(loginButton.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
    }
    
    signInWithKakaoButton.snp.makeConstraints {
      $0.top.equalTo(findPasswordButton.snp.bottom).offset(57)
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-16)
      $0.height.equalTo(44)
    }
    
    signInWithAppleButton.snp.makeConstraints {
      $0.top.equalTo(signInWithKakaoButton.snp.bottom).offset(8)
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-16)
      $0.height.equalTo(44)
    }
    
    skipLoginButton.snp.makeConstraints {
      $0.top.equalTo(signInWithAppleButton.snp.bottom).offset(8)
      $0.leading.equalTo(16)
      $0.trailing.equalTo(-16)
      $0.height.equalTo(44)
    }
    
    registContainer.snp.makeConstraints {
      $0.top.equalTo(skipLoginButton.snp.bottom).offset(25)
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(-66)
    }
    
    registLabel.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview()
      $0.height.equalTo(18)
    }
    
    registButton.snp.makeConstraints {
      $0.top.trailing.bottom.equalToSuperview()
      $0.height.equalTo(18)
      $0.leading.equalTo(registLabel.snp.trailing).offset(8)
    }
  }
}
