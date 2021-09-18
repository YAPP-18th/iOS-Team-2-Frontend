//
//  LoginViewController.swift
//  YoongYoong
//
//  Copyright © 2021 YoongYoong. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import AuthenticationServices

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
        $0.font = .krBody2
        $0.textColor = .systemGray01
        $0.attributedPlaceholder = NSMutableAttributedString().string("이메일", font: .krBody2, color: .systemGray04)
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
    }
    
    let emailDivider = UIView().then {
        $0.backgroundColor = .systemGray05
    }
    
    let passwordField = PasswordField()
    
    let passwordDivider = UIView().then {
        $0.backgroundColor = .systemGray05
    }
    
    let loginButton = Button().then {
        $0.setTitle("로그인", for: .normal)
    }
    
    let findPasswordButton = UIButton().then {
        $0.setTitle("비밀번호 찾기", for: .normal)
        $0.setTitleColor(.systemGray02, for: .normal)
        $0.titleLabel?.font = .krCaption1
    }
    
    let signInWithAppleButton = UIButton().then {
        $0.backgroundColor = .systemGrayText01
        $0.layer.cornerRadius = 22
        $0.layer.masksToBounds = true
    }
    
    let signInWithKakaoButton = UIButton().then {
        $0.backgroundColor = .kakaoLoginYellow
        $0.layer.cornerRadius = 22
        $0.layer.masksToBounds = true
    }
    
  let signWithKakaoContentView = UIView().then {
    $0.isUserInteractionEnabled = false
  }
  let signWithAppleContentView = UIView().then {
    $0.isUserInteractionEnabled = false
  }
    
    let signInWithKakaoImageView = UIImageView().then {
        $0.image = UIImage(named: "kakaoLogo")
    }
    
    let signInWithAppleImageView = UIImageView().then {
        $0.image = UIImage(named: "appleLogo")
    }
    
    let signInWithKakaoContent = UILabel().then {
        $0.text = "카카오로 로그인"
        $0.textColor = .systemGrayText00OnlyLight
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    let signInWithAppleContent = UILabel().then {
        $0.text = "Apple로 로그인"
        $0.textColor = .systemGray00
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    lazy var skipLoginButton = UIButton().then {
        $0.setTitle("로그인 없이 둘러볼게요", for: .normal)
        $0.setTitleColor(self.traitCollection.userInterfaceStyle == .dark ? .systemGrayText01 : .brandColorGreen01, for: .normal)
        $0.titleLabel?.font = .krButton1
        $0.backgroundColor = .skipLoginButtonBg
        $0.layer.cornerRadius = 22
        $0.layer.borderColor = UIColor.systemGray05.cgColor
        $0.layer.borderWidth = self.traitCollection.userInterfaceStyle == .dark ? 0 : 1
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.userInterfaceStyle == .dark {
            skipLoginButton.layer.borderWidth = 0
            skipLoginButton.backgroundColor = .systemGray03
            skipLoginButton.setTitleColor(.systemGrayText01, for: .normal)
        } else {
            skipLoginButton.layer.borderWidth = 1
            skipLoginButton.backgroundColor = .systemGray00
            skipLoginButton.setTitleColor(.brandColorGreen01, for: .normal)
        }
        skipLoginButton.layer.borderColor = UIColor.systemGray05.cgColor
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = self.viewModel as? LoginViewModel else { return }
        let loginParam = Observable.combineLatest(emailField.rx.text.orEmpty.asObservable(),
                                                  passwordField.textField.rx.text.orEmpty.asObservable())
        let input = LoginViewModel.Input(
            param: loginParam,
            registration: self.registButton.rx.tap.asObservable(),
            login: self.loginButton.rx.tap.asObservable(),
            guest: self.skipLoginButton.rx.tap.asObservable(),
            findPassword: self.findPasswordButton.rx.tap.asObservable()
        )
        
        loginParam.bind{ [weak self] param in
            guard let `self` = self else { return }
            self.validate(email: param.0, password: param.1)
        }.disposed(by: self.disposeBag)
        
        let output = viewModel.transform(input: input)
        output.loginResult
            .bind{ [weak self] result, response in
                if result,
                   let token = response?.accessToken,
                   let refreshToken = response?.refreshToken {
                    LoginManager.shared.makeLoginStatus(accessToken: token, refreshToken: refreshToken)
                    let alert = YYAlertController(title: "알림", message: "로그인이 정상적으로 완료되었습니다.")
                    let okAction = YYAlertAction(title: "확인", style: .default) { [weak self] in
                        let viewModel = TabBarViewModel()
                        self?.navigator.show(segue: .tabs(viewModel: viewModel), sender: self, transition: .modalFullScreen)
                    }
                    alert.addAction(okAction)
                    self?.present(alert, animated: true, completion: nil)
                } else {
                    let alert = YYAlertController(title: "로그인 오류", message: "이메일 혹은 비밀번호를 다시 입력해주세요")
                    let okAction = YYAlertAction(title: "확인", style: .default)
                    alert.addAction(okAction)
                    self?.present(alert, animated: true, completion: nil)
                }
            }.disposed(by: self.disposeBag)
      
      output.appleLoginResult
          .bind{ [weak self] result, response in
              if result,
                 let token = response?.accessToken,
                 let refreshToken = response?.refreshToken {
                  LoginManager.shared.makeLoginStatus(accessToken: token, refreshToken: refreshToken)
                  let alert = YYAlertController(title: "알림", message: "로그인이 정상적으로 완료되었습니다.")
                  let okAction = YYAlertAction(title: "확인", style: .default) { [weak self] in
                      let viewModel = TabBarViewModel()
                      self?.navigator.show(segue: .tabs(viewModel: viewModel), sender: self, transition: .modalFullScreen)
                  }
                  alert.addAction(okAction)
                  self?.present(alert, animated: true, completion: nil)
              } else {
                let viewModel = RegistrationTermsViewModel(isAppleRegistration: true)
                self?.navigator.show(segue: .registrationTerms(viewModel: viewModel), sender: self, transition: .navigation(.right))
              }
          }.disposed(by: self.disposeBag)
        output.guestLoginResult
            .bind{ [weak self] result, response in
                if result,
                   let token = response?.accessToken {
                    LoginManager.shared.makeLoginStatus(accessToken: token)
                    let alert = YYAlertController(title: "알림", message: "로그인이 정상적으로 완료되었습니다.")
                    let okAction = YYAlertAction(title: "확인", style: .default) { [weak self] in
                        let viewModel = TabBarViewModel()
                        self?.navigator.show(segue: .tabs(viewModel: viewModel), sender: self, transition: .modalFullScreen)
                    }
                    alert.addAction(okAction)
                    self?.present(alert, animated: true, completion: nil)
                } else {
                    let alert = YYAlertController(title: "로그인 오류", message: "이메일 혹은 비밀번호를 다시 입력해주세요")
                    let okAction = YYAlertAction(title: "확인", style: .default)
                    alert.addAction(okAction)
                    self?.present(alert, animated: true, completion: nil)
                }
            }.disposed(by: disposeBag)
        
        
        output.registration.drive(onNext: { viewModel in
            self.navigator.show(segue: .registrationTerms(viewModel: viewModel), sender: self, transition: .navigation(.right))
        }).disposed(by: disposeBag)
        
        output.findPassword.drive(onNext: { viewModel in
            self.navigator.show(segue: .findPassword(viewModel: viewModel), sender: self, transition: .navigation(.right))
        }).disposed(by: disposeBag)
        
        signInWithKakaoButton.rx.tap.subscribe(onNext: { _ in
            self.navigator.show(segue: .kakaoLogin(viewModel: KakaoLoginViewModel()), sender: self, transition: .modalFullScreen)
        }).disposed(by: disposeBag)
    }
    
    override func configuration() {
        super.configuration()
        self.loginButton.isEnabled = true
        self.view.backgroundColor = .systemGray00
        
        if #available(iOS 13.0, *) {
            signInWithAppleButton.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        }
    }
    
    private func validate(email: String, password: String) {
        loginButton.isEnabled = !email.isEmpty && !password.isEmpty
    }
    
    override func setupView() {
        super.setupView()
        self.view.addSubview(scrollView)
        scrollView.addArrangedSubview(contentView)
        [
            logoImageView, emailField, emailDivider, passwordField, passwordDivider,
            loginButton, findPasswordButton, signInWithAppleButton
        ].forEach {
            self.contentView.addSubview($0)
        }
        if #available(iOS 13.0, *) {
            self.contentView.addSubview(signInWithAppleButton)
        }
        [signInWithKakaoButton, skipLoginButton, registContainer].forEach {
            self.contentView.addSubview($0)
        }
        
        signInWithKakaoButton.addSubview(signWithKakaoContentView)
        [signInWithKakaoImageView, signInWithKakaoContent].forEach {
            signWithKakaoContentView.addSubview($0)
        }
        
        signInWithAppleButton.addSubview(signWithAppleContentView)
        [signInWithAppleImageView, signInWithAppleContent].forEach {
            signWithAppleContentView.addSubview($0)
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
        
        signWithKakaoContentView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        signInWithKakaoImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        signInWithKakaoContent.snp.makeConstraints {
            $0.leading.equalTo(signInWithKakaoImageView.snp.trailing).offset(9)
            $0.trailing.centerY.equalToSuperview()
        }
        
        if #available(iOS 13.0, *) {
            signInWithAppleButton.snp.makeConstraints {
                $0.top.equalTo(signInWithKakaoButton.snp.bottom).offset(8)
                $0.leading.equalTo(16)
                $0.trailing.equalTo(-16)
                $0.height.equalTo(44)
            }
            
            signWithAppleContentView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            signInWithAppleImageView.snp.makeConstraints {
                $0.top.leading.bottom.equalToSuperview()
                $0.width.height.equalTo(24)
            }
            
            signInWithAppleContent.snp.makeConstraints {
                $0.leading.equalTo(signInWithAppleImageView.snp.trailing).offset(9)
                $0.trailing.centerY.equalToSuperview()
            }
            
            skipLoginButton.snp.makeConstraints {
                $0.top.equalTo(signInWithAppleButton.snp.bottom).offset(8)
                $0.leading.equalTo(16)
                $0.trailing.equalTo(-16)
                $0.height.equalTo(44)
            }
        } else {
            skipLoginButton.snp.makeConstraints {
                $0.top.equalTo(signInWithKakaoButton.snp.bottom).offset(8)
                $0.leading.equalTo(16)
                $0.trailing.equalTo(-16)
                $0.height.equalTo(44)
            }
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
    
    @available(iOS 13.0, *)
    @objc func signInWithApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}
@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Todo: 첫 인증시 저장해야함
            let userIdentifier = appleIDCredential.user
          let fullName = "\(appleIDCredential.fullName?.familyName ?? "")\(appleIDCredential.fullName?.givenName ?? "")"
            let email = appleIDCredential.email
          AppleRegistration.shared.socialId = userIdentifier
          AppleRegistration.shared.email = email
          AppleRegistration.shared.nickname = fullName
          (self.viewModel as? LoginViewModel)?.appleLogin.onNext(userIdentifier)
        default:
            break
        }
    }
    
}
@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
