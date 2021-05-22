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
    hideKeyboardWhenTappedAround()
    NotificationCenter.default
        .rx.notification(UIApplication.didBecomeActiveNotification)
        .subscribe { [weak self] (event) in
            self?.didBecomeActive()
        }.disposed(by: disposeBag)
  }
  
  func bindViewModel() {
    
  }
  
  func configuration() {
    navigationItem.backButtonTitle = ""
    self.view.backgroundColor = .systemGray00
  }
  
  func setupView() {
    
  }
  
  func setupLayout() {
    
  }
  
  func updateUI() {

  }
  func hideNaviController() {
    self.navigationController?.navigationBar.isHidden = true
  }
  func hideKeyboardWhenTappedAround() {
      let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
  }
  func setupNavigationBar(_ color: UIColor) {
      guard let navigationBar = self.navigationController?.navigationBar else { return }
      
      navigationBar.isTranslucent = true
      navigationBar.backgroundColor = color
      navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
      navigationBar.shadowImage = UIImage()
  }
  func setupStatusBar(_ color: UIColor) {
         if #available(iOS 13.0, *) {
             let margin = view.layoutMarginsGuide
             let statusbarView = UIView()
             statusbarView.backgroundColor = color
             statusbarView.frame = CGRect.zero
             view.addSubview(statusbarView)
             statusbarView.translatesAutoresizingMaskIntoConstraints = false
             
             NSLayoutConstraint.activate([
                 statusbarView.topAnchor.constraint(equalTo: view.topAnchor),
                 statusbarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0),
                 statusbarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                 statusbarView.bottomAnchor.constraint(equalTo: margin.topAnchor)
             ])
             
         } else {
             let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
             statusBar?.backgroundColor = UIColor.white
         }
     }
  func didBecomeActive() {
      self.updateUI()
  }
}
extension ViewController {
  @objc
  func dismissKeyboard() {
    view.endEditing(true)
  }
  
  var isDarkMode: Bool {
    if #available(iOS 13.0, *) {
      return self.traitCollection.userInterfaceStyle == .dark
    }
    else {
      return false
    }
  }
}
