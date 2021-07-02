//
//  PostReviewViewController.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/10.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class PostReviewViewController: ViewController {
  private let titleLabel = UILabel().then {
    $0.text = "이번 실천은 어땠나요?"
    $0.font = .krHeadline
  }
  
  private let discountContainer = UIStackView().then {
    $0.alignment = .fill
    $0.spacing = 9
    $0.axis = .vertical
  }
  private let smileContainer = UIStackView().then {
    $0.alignment = .fill
    $0.spacing = 9
    $0.axis = .vertical
  }
  private let likeContainer = UIStackView().then {
    $0.alignment = .fill
    $0.spacing = 9
    $0.axis = .vertical
  }
  private let discountButton = UIButton().then {
    $0.setImage(UIImage(named: "discountInactive"), for: .normal)
    $0.setImage(UIImage(named: "discountActive"), for: .selected)
  }
  private let smileButton = UIButton().then {
    $0.setImage(UIImage(named: "smileInactive"), for: .normal)
    $0.setImage(UIImage(named: "smileActive"), for: .selected)
  }
  private let likeButton = UIButton().then {
    $0.setImage(UIImage(named: "likeInactive"), for: .normal)
    $0.setImage(UIImage(named: "likeActive"), for: .selected)
  }
  
  private let uploadButton = UIButton().then {
    $0.layer.cornerRadius = 30.0
    $0.isEnabled = false
    $0.backgroundColor = .brandColorGreen03
    $0.setTitle("업로드", for: .normal)
    $0.titleLabel?.font = .krButton1
    $0.layer.applySketchShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.12, x: 0, y: 2, blur: 10, spread: 0)
  }
  
  private let discountLabel = UILabel().then {
    $0.text = "용기 할인"
    $0.font = .krCaption2
    $0.textColor = .systemGrayText02
    $0.textAlignment = .center
  }
  private let smileLabel = UILabel().then {
    $0.text = "친절한 사장님"
    $0.font = .krCaption2
    $0.textColor = .systemGrayText02
    $0.textAlignment = .center
    
  }
  private let likeLabel = UILabel().then {
    $0.text = "넉넉한 인심"
    $0.font = .krCaption2
    $0.textColor = .systemGrayText02
    $0.textAlignment = .center
  }
  
  private let textView = UITextView().then {
    $0.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    $0.layer.cornerRadius = 12
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.systemGray05.cgColor
    $0.font = .krBody2
    $0.text = "실천에 대한 자세한 이야기를 들려주세요!"
    $0.textColor = UIColor.systemGrayText02
  }
  private let textCountLabel = UILabel().then {
    $0.text = "0"
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textColor = .systemGrayText02
  }
  private let limitLabel = UILabel().then {
    $0.text = "/ 150"
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
    $0.textColor = .systemGrayText02
  }
  
  private var reviewContent = PublishRelay<String>()
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    
    guard let viewModel = viewModel as? PostReviewViewModel else { return }
    

    let discountButtonDidTap = BehaviorRelay<Bool>(value: false)
    let smileButtonDidTap = BehaviorRelay<Bool>(value: false)
    let likeButtonDidTap = BehaviorRelay<Bool>(value: false)
    
    discountButton.rx.tap
      .scan(false) { toggle, _ in
        !toggle
      }.bind { [weak self] toggle in
        guard let self = self else { return }
        self.discountButton.rx.isSelected.onNext(toggle)
        discountButtonDidTap.accept(toggle)
      }.disposed(by: disposeBag)
    
    smileButton.rx.tap
      .scan(false) { toggle, _ in
        !toggle
      }.bind { [weak self] toggle in
        guard let self = self else { return }
        self.smileButton.rx.isSelected.onNext(toggle)
        smileButtonDidTap.accept(toggle)
      }.disposed(by: disposeBag)
    
    likeButton.rx.tap
      .scan(false) { toggle, _ in
        !toggle
      }.bind { [weak self] toggle in
        guard let self = self else { return }
        self.likeButton.rx.isSelected.onNext(toggle)
        likeButtonDidTap.accept(toggle)
      }.disposed(by: disposeBag)
    
 
    let input = PostReviewViewModel.Input(discountButtonDidTap: discountButtonDidTap,
                                          smileButtonDidTap: smileButtonDidTap,
                                          likeButtonDidTap: likeButtonDidTap,
                                          reviewContent: reviewContent,
                                          uploadButtonDidTap: uploadButton.rx.tap.asObservable())
  
    
    let output = viewModel.transform(input: input)
    
    output.uploadButtonIsEnabled
      .bind { [weak self] in
        guard let self = self else { return }
        self.uploadButton.isEnabled = $0
        self.uploadButton.backgroundColor = $0 ? .brandColorGreen01 : .brandColorGreen03
      }.disposed(by: disposeBag)
 
    
    output.uploadDidEnd
      .subscribe(onNext: { [weak self] in
        guard let self = self,
              let window = self.view.window else { return }
        
        self.navigator.show(segue: .splash(viewModel: SplashViewModel()), sender: self, transition: .root(in: window))
      }).disposed(by: disposeBag)
  }
  
  override func setupView() {
    super.setupView()
    discountContainer.addArrangedSubview(discountButton)
    discountContainer.addArrangedSubview(discountLabel)
    smileContainer.addArrangedSubview(smileButton)
    smileContainer.addArrangedSubview(smileLabel)
    likeContainer.addArrangedSubview(likeButton)
    likeContainer.addArrangedSubview(likeLabel)
    view.adds([titleLabel, discountContainer, smileContainer, likeContainer,
               textView, textCountLabel, limitLabel, uploadButton])
  }
  
  override func setupLayout() {
    super.setupLayout()
    titleLabel.snp.makeConstraints {
      $0.width.equalTo(306)
      $0.height.equalTo(32)
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
      $0.leading.equalTo(view.snp.leading).offset(16)
    }
    discountContainer.snp.makeConstraints {
      $0.width.equalTo(70)
      $0.height.equalTo(97)
      $0.top.equalTo(titleLabel.snp.bottom).offset(21)
      $0.right.equalTo(smileContainer.snp.left).offset(-51)
    }
    smileContainer.snp.makeConstraints {
      $0.width.equalTo(70)
      $0.height.equalTo(97)
      $0.centerX.equalTo(view.snp.centerX)
      $0.top.equalTo(titleLabel.snp.bottom).offset(21)
    }
    likeContainer.snp.makeConstraints {
      $0.width.equalTo(70)
      $0.height.equalTo(97)
      $0.top.equalTo(titleLabel.snp.bottom).offset(21)
      $0.left.equalTo(smileContainer.snp.right).offset(51)
    }
    
    discountButton.snp.makeConstraints {
      $0.width.height.equalTo(70)
    }
    
    smileButton.snp.makeConstraints {
      $0.width.height.equalTo(70)
    }
    
    likeButton.snp.makeConstraints {
      $0.width.height.equalTo(70)
    }
    
    textView.snp.makeConstraints {
      $0.width.equalTo(327)
      $0.height.equalTo(134)
      $0.centerX.equalTo(view.snp.centerX)
      $0.top.equalTo(smileContainer.snp.bottom).offset(24)
    }
    textCountLabel.snp.makeConstraints{
      $0.top.equalTo(textView.snp.bottom).offset(8)
      $0.right.equalTo(limitLabel.snp.left).offset(-2)
    }
    limitLabel.snp.makeConstraints {
      $0.top.equalTo(textView.snp.bottom).offset(8)
      $0.right.equalTo(view.snp.right).offset(-24)
      
    }
    
    uploadButton.snp.makeConstraints {
      $0.width.equalTo(144)
      $0.height.equalTo(55)
      $0.centerX.equalTo(view.snp.centerX)
      $0.bottom.equalTo(view.snp.bottom).offset(-67)
    }
  }
  
  override func configuration() {
    super.configuration()
    view.backgroundColor = .white
    textView.rx.setDelegate(self).disposed(by: disposeBag)
    

  }
  
}

extension PostReviewViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == .systemGrayText02 {
      textView.text = nil
      textView.textColor = UIColor.systemGrayText01
    }
    
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "실천에 대한 자세한 이야기를 들려주세요!"
      textView.textColor = UIColor.systemGrayText02
    }
    reviewContent.accept(textView.text)
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    guard let str = textView.text else { return true }
    let newLength = str.count + text.count - range.length
    if newLength <= 150 {
      textCountLabel.text = "\(newLength)"
      return true
    } else {
      return false
    }
  }
}
