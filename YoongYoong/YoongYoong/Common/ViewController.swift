//
//  ViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/17.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, Navigatable {
  let disposeBag = DisposeBag()
  var viewModel: ViewModel?
  var navigator: Navigator!
  
  init(viewModel: ViewModel?, navigator: Navigator) {
    self.viewModel = viewModel
    self.navigator = navigator
    super.init(nibName: nil, bundle: nil)
  }
  
  let isLoading = BehaviorRelay(value: false)
  let error = PublishSubject<Error>()
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configuration()
    setupView()
    setupLayout()
    bindViewModel()
    
    NotificationCenter.default
        .rx.notification(UIApplication.didBecomeActiveNotification)
        .subscribe { [weak self] (event) in
            self?.didBecomeActive()
        }.disposed(by: disposeBag)
  }
  
  func bindViewModel() {
    
  }
  
  func configuration() {
    
  }
  
  func setupView() {
    
  }
  
  func setupLayout() {
    
  }
  
  func updateUI() {

  }
  
  func didBecomeActive() {
      self.updateUI()
  }
}
