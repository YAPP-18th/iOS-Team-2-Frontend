//
//  RegistrationProfileViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/15.
//

import UIKit

class RegistrationProfileViewController: ViewController {
  
  let profileButton = UIButton().then {
    $0.setImage(UIImage(named: "icRegProfileEmpty"), for: .normal)
    $0.contentMode = .scaleAspectFit
    $0.layer.cornerRadius = 42.3
  }
  
  let profileImageView = UIImageView().then {
    $0.image = UIImage(named: "icRegBtnProfile")
    $0.contentMode = .scaleAspectFit
  }
  
  let nicknameField = UITextField().then {
    $0.attributedPlaceholder = NSMutableAttributedString().string("닉네임", font: .krBody2, color: .systemGrayText02)
    $0.font = .krBody2
    $0.textColor = .systemGray01
  }
  
  let nicknameLengthLabel = UILabel().then {
    $0.text = "0"
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textAlignment = .justified
    $0.textColor = .systemGrayText02
  }
  
  let nicknameMaxLengthLabel = UILabel().then {
    $0.text = "12"
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textAlignment = .justified
    $0.textColor = .systemGrayText02
  }
  
  let nicknameSlashLabel = UILabel().then {
    $0.text = "/"
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textAlignment = .justified
    $0.textColor = .systemGrayText02
  }
  
  let nicknameDivider = UIView().then {
    $0.backgroundColor = .systemGray05
  }
  
  let warningImageView = UIImageView().then {
    $0.image = UIImage(named: "icRegWarning")
    $0.contentMode = .scaleAspectFit
  }
  
  let warningLabel = UILabel().then {
    $0.text = "이미 사용중인 닉네임입니다."
    $0.textColor = .brandColorSecondary01
    $0.font = .krCaption2
  }
  
  let introduceContainer = UIView().then {
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.systemGray05.cgColor
    $0.layer.cornerRadius = 12
  }
  
  private let introduceTextView = UITextView().then{
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .regular)
    $0.textColor = .black
    $0.layer.cornerRadius = 8
    $0.layer.borderWidth = 1
    $0.placeholder = "한 줄로 자신을 소개해주세요!"
    $0.layer.borderColor = UIColor.lightGray.cgColor
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  let introduceLengthLabel = UILabel().then {
    $0.text = "0"
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textAlignment = .justified
    $0.textColor = .systemGrayText02
  }
  
  let introduceMaxLengthLabel = UILabel().then {
    $0.text = "50"
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textAlignment = .justified
    $0.textColor = .systemGrayText02
  }
  
  let introduceSlashLabel = UILabel().then {
    $0.text = "/"
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textAlignment = .justified
    $0.textColor = .systemGrayText02
  }
  
  let saveButton = Button().then {
    $0.setTitle("저장하기", for: .normal)
  }
  
  let laterButton = UIButton().then {
    $0.setTitle("다음에 할게요!", for: .normal)
    $0.titleLabel?.font = .krCaption2
    $0.setTitleColor(.systemGray02, for: .normal)
  }
  
  private var profileImagePicker: SingleImagePicker!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = self.viewModel as? RegistrationProfileViewModel else { return }
    
    let input = RegistrationProfileViewModel.Input(
      nicknameChanged: nicknameField.rx.text.orEmpty.asObservable(),
      introduceChanged: introduceTextView.rx.text.orEmpty.asObservable(),
      register: saveButton.rx.tap.map {
        let nickname = self.nicknameField.text ?? ""
        let introduction = self.introduceTextView.text ?? ""
        let image = self.profileButton.image(for: .normal) ?? UIImage()
        return (nickname, introduction, image)
      }.asObservable()
    )
    
    let output = viewModel.transform(input: input)
    
    output.nicknameLength.drive(nicknameLengthLabel.rx.text).disposed(by: disposeBag)
    output.introduceLength.drive(introduceLengthLabel.rx.text).disposed(by: disposeBag)
    
    output.checkNicknameResult.drive(onNext: {result in
      self.warningImageView.isHidden = result
      self.warningLabel.isHidden = result
    }).disposed(by: disposeBag)
    
    profileButton.rx.tap.bind{ [weak self] in
      self?.profileImagePicker.present(from: self?.view ?? UIView())
    }.disposed(by: disposeBag)
    
    output.signUp.drive(onNext: { response in
      if (200..<300).contains(response.statusCode) {
        AlertAction.shared.showAlertView(title: "회원가입이 완료되었습니다.", grantMessage: "확인", denyMessage: "취소" , okAction: { [weak self] in
            guard let self = self else { return }
            self.navigator.show(segue: .login(viewModel: .init()), sender: self, transition: .root(in: self.view.window!))
        })
      } else {
        print("실패")
      }
    }).disposed(by: disposeBag)
    
    output.defaultNickname.drive(self.nicknameField.rx.text).disposed(by: disposeBag)
  }
  
  override func configuration() {
    super.configuration()
    self.view.backgroundColor = .systemGray00
    self.navigationItem.title = "프로필 만들기"
    self.setupBackButton()
    self.saveButton.isEnabled = true
    self.nicknameField.delegate = self
    self.introduceTextView.delegate = self
  }
  
  override func setupView() {
    super.setupView()
    self.profileImagePicker = SingleImagePicker(presentationController: self, delegate: self)
    [
      profileButton,
      nicknameField, nicknameLengthLabel, nicknameSlashLabel, nicknameMaxLengthLabel, nicknameDivider,
      warningImageView, warningLabel,
      introduceContainer, introduceLengthLabel, introduceSlashLabel, introduceMaxLengthLabel,
      saveButton, laterButton
    ].forEach {
      self.view.addSubview($0)
    }
    
    profileButton.addSubview(profileImageView)
    
    introduceContainer.addSubview(introduceTextView)
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    profileButton.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(114)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(84.6)
    }
    
    profileImageView.snp.makeConstraints {
      $0.trailing.bottom.equalToSuperview()
      $0.width.height.equalTo(24)
    }
    
    nicknameField.snp.makeConstraints {
      $0.top.equalTo(profileButton.snp.bottom).offset(26)
      $0.leading.equalTo(24)
      $0.height.equalTo(32)
      $0.trailing.equalTo(nicknameLengthLabel.snp.leading).offset(-8)
    }
    
    nicknameField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    
    nicknameLengthLabel.snp.makeConstraints {
      $0.bottom.equalTo(nicknameField)
      $0.trailing.equalTo(nicknameSlashLabel.snp.leading).offset(-2)
    }
    
    nicknameSlashLabel.snp.makeConstraints {
      $0.bottom.equalTo(nicknameField)
      $0.trailing.equalTo(nicknameMaxLengthLabel.snp.leading).offset(-2)
    }
    
    nicknameMaxLengthLabel.snp.makeConstraints {
      $0.trailing.equalTo(-24)
      $0.bottom.equalTo(nicknameField)
    }
    
    nicknameDivider.snp.makeConstraints {
      $0.top.equalTo(nicknameField.snp.bottom)
      $0.leading.equalTo(24)
      $0.trailing.equalTo(-24)
      $0.height.equalTo(1)
    }
    
    warningImageView.snp.makeConstraints {
      $0.top.equalTo(nicknameDivider.snp.bottom).offset(3)
      $0.leading.equalTo(24)
      $0.width.height.equalTo(16)
    }
    
    warningLabel.snp.makeConstraints {
      $0.leading.equalTo(warningImageView.snp.trailing).offset(8)
      $0.centerY.equalTo(warningImageView)
    }
    
    introduceContainer.snp.makeConstraints {
      $0.top.equalTo(nicknameDivider.snp.bottom).offset(26)
      $0.leading.equalTo(24)
      $0.trailing.equalTo(-24)
    }
    
    introduceTextView.snp.makeConstraints {
      $0.top.leading.equalTo(16)
      $0.height.equalTo(76)
      $0.trailing.bottom.equalTo(-16)
    }
    
    introduceLengthLabel.snp.makeConstraints {
      $0.top.equalTo(introduceContainer.snp.bottom).offset(12)
      $0.trailing.equalTo(introduceSlashLabel.snp.leading).offset(-2)
    }
    
    introduceSlashLabel.snp.makeConstraints {
      $0.bottom.equalTo(introduceMaxLengthLabel)
      $0.trailing.equalTo(nicknameMaxLengthLabel.snp.leading).offset(-2)
    }
    
    introduceMaxLengthLabel.snp.makeConstraints {
      $0.trailing.equalTo(-24)
      $0.bottom.equalTo(introduceLengthLabel)
    }
    
    laterButton.snp.makeConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-32)
      $0.centerX.equalToSuperview()
    }
    
    saveButton.snp.makeConstraints {
      $0.bottom.equalTo(laterButton.snp.top).offset(-16)
      $0.leading.equalTo(24)
      $0.trailing.equalTo(-24)
      $0.height.equalTo(44)
    }
    self.warningImageView.isHidden = true
    self.warningLabel.isHidden = true
  }
  
}
extension RegistrationProfileViewController : SingleImagePickerDelegate {
  func didSelect(image: UIImage?) {
    if let image = image {
      self.profileButton.setImage(image, for: .normal)
    }
    profileImageView.contentMode = .scaleAspectFill
    
    profileButton.layer.masksToBounds = true
    
    self.profileImageView.isHidden = true
  }
}

extension RegistrationProfileViewController: UITextViewDelegate, UITextFieldDelegate {
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    guard let str = textView.text else { return true }
    let newLength = str.count + text.count - range.length
    return newLength <= 50
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    let newLength = text.count + string.count - range.length
    return newLength <= 15
  }
}
