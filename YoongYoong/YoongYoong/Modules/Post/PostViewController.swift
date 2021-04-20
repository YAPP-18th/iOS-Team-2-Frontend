//
//  PostViewController.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/04/19.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then


class PostViewController: ViewController {
  
  let titleLabel = UILabel()
  let subLabel = UILabel()
  let postImageView = UIImageView()
  let postButton = UIButton().then {
    $0.backgroundColor = UIColor.brandPrimary
    $0.setTitle("포스트 작성하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.layer.cornerRadius = 30
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    
    guard let viewModel = viewModel as? PostViewModel else { return }
    let input = PostViewModel.Input(postButtonDidTap: postButton.rx.tap.asDriver())
    
    let output = viewModel.transform(input: input)
    
    output.post.drive(onNext: { [weak self] viewModel in
      // TODO: PresentationStyle
      self?.navigator.show(segue: .post(viewModel: viewModel), sender: self, transition: .detail)
    }).disposed(by: disposeBag)
    
  }
  
  override func configuration() {
    super.configuration()
    view.backgroundColor = .white
  }
  
  override func setupView() {
    super.setupView()
    view.addSubview(titleLabel)
    view.addSubview(subLabel)
    view.addSubview(postImageView)
    view.addSubview(postButton)
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    postButton.snp.makeConstraints {
      $0.width.equalTo(343)
      $0.height.equalTo(55)
      $0.centerX.equalTo(view)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
    }
    
  }
  
}
