//
//  EditProfileViewController.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/02.
//
import UIKit
import Foundation
import RxSwift
import RxCocoa
import Moya

class EditProfileViewController : ViewController {
  private let profileBtn = UIButton().then{
    $0.layer.cornerRadius = 43
    $0.backgroundColor = .gray
    $0.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(named: "iconUserAvater")
    //$0.setImage(image, for: .normal)
    $0.setBackgroundImage(image, for: .normal)
    let profileSubImg = UIImageView().then {
      $0.image = UIImage(named: "protilePicture")
    }
    $0.add(profileSubImg)
    profileSubImg.snp.makeConstraints{
      $0.trailing.bottom.equalToSuperview()
      $0.width.height.equalTo(24)
    }
  }
  private var profileImagePicker: SingleImagePicker!
  private let nameTextField = UITextField().then{
    $0.placeholder = "이름을 입력해주세요"
    $0.addUnderBar()
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .regular)
    $0.textColor = .black
  }
  private let nameTextCounter = UILabel().then{
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .regular)
    $0.textColor = .gray
  }
  private let commentTextView = UITextView().then{
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .regular)
    $0.textColor = .black
    $0.layer.cornerRadius = 8
    $0.layer.borderWidth = 1
    $0.placeholder = "한 줄로 자신을 소개해주세요!"
    $0.layer.borderColor = UIColor.lightGray.cgColor
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  private let commentTextCounter = UILabel().then{
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .regular)
    $0.textColor = .gray
  }
  private let submitBtn = UIButton().then{
    $0.backgroundColor = .brandColorBlue02
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    $0.layer.cornerRadius = 16
    $0.setTitle("완료", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 40, right: 16)
    $0.titleLabel?.font  = .sdGhothicNeo(ofSize: 18, weight: .bold)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  override func viewDidLoad() {
    self.view.backgroundColor = .white
    super.viewDidLoad()
    setupSimpleNavigationItem(title: "프로필 편집")
    
  }
  override func setupLayout() {
    self.view.adds([profileBtn,
    nameTextField,
    commentTextView,
    nameTextCounter,
    commentTextCounter,
    submitBtn])
    
    profileBtn.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(115)
      $0.width.height.equalTo(86)
    }
    nameTextField.snp.makeConstraints{
      $0.top.equalTo(profileBtn.snp.bottom).offset(24)
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(24)
    }
    nameTextCounter.snp.makeConstraints{
      $0.centerY.equalTo(nameTextField)
      $0.trailing.equalToSuperview().offset(-24)
    }
    commentTextView.snp.makeConstraints{
      $0.top.equalTo(nameTextField.snp.bottom).offset(27)
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(24)
      $0.height.equalTo(76)
    }
    commentTextCounter.snp.makeConstraints{
      $0.trailing.equalTo(commentTextView)
      $0.top.equalTo(commentTextView.snp.bottom).offset(8)
    }
    submitBtn.snp.makeConstraints{
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(88)
    }
  }
  override func setupView() {
    self.profileImagePicker = SingleImagePicker(presentationController: self, delegate: self)
  }
  override func bindViewModel() {
    guard let viewModel = viewModel as? EditProfileViewModel else { return }
    let inputs = EditProfileViewModel.Input(loadView: Observable.just(()),
                                            ProfileImage: Observable.just(profileBtn.image(for: .normal) ?? UIImage()),
                                            nameText: nameTextField.rx.text.orEmpty.asObservable(),
                                            commentText: commentTextView.rx.text.orEmpty.asObservable(),
                                            changeAction: submitBtn.rx.tap.asObservable())
    let output = viewModel.transform(input: inputs)
    output.changeBtnActivate.drive{[weak self] result in
      self?.submitBtn.isEnabled = result
      self?.submitBtn.backgroundColor = result ? .brandColorBlue01 : .brandColorBlue02
    }.disposed(by: disposeBag)
    output.commentTextCount.drive{ [weak self] count in
      self?.commentTextCounter.text = "\(count)/50"
    }.disposed(by: disposeBag)
    output.nameTextCount.drive{ [weak self] count in
      self?.nameTextCounter.text = "\(count)/12"
    }.disposed(by: disposeBag)
    profileBtn.rx.tap.bind{ [weak self] in
      self?.profileImagePicker.present(from: self?.view ?? UIView())
    }.disposed(by: disposeBag)
  }
  
}
extension EditProfileViewController : SingleImagePickerDelegate {
  func didSelect(image: UIImage?) {
      if let image = image {
        self.profileBtn.setImage(image, for: .normal)
        self.profileBtn.imageView?.layer.cornerRadius = 43
      }
  }
}
