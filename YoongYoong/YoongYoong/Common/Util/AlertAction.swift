//
//  AlertAction.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/02.
//

import Foundation
import UIKit

class AlertAction: BaseAlert {
  typealias PopupDialogButtonAction = () -> Void
  
  static let shared = AlertAction()
  var buttonAction: PopupDialogButtonAction?
  var cancelAction : PopupDialogButtonAction?
  override init(frame: CGRect) {
    super.init(frame: frame)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension AlertAction {
  func showAlertView(
    title: String,
    description: String = "",
    grantMessage: String = "확인",
    okAction: PopupDialogButtonAction? = nil
  ) {
    initializeMainView()
    
    denyButton.isHidden = true
    denyButton.removeFromSuperview()
    buttonAction = okAction
    titleLabel.text = title
    
    grantButton.setTitle(grantMessage, for: .normal)
    grantButton.addTarget(self,
                          action: #selector(grantAction),
                          for: .touchUpInside)
    
    let titlelabelLineCount = titleLabel.intrinsicContentSize.height / 24
    alertView.heightAnchor.constraint(equalToConstant: 170 + 24 * titlelabelLineCount).isActive = true
    
    if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
      let transform = CGAffineTransform(translationX: 0, y: -300)
      blackView.alpha = 0
      alertView.transform = transform
      UIView.animate(
        withDuration: 0.7,
        delay: 0,
        usingSpringWithDamping: 1,
        initialSpringVelocity: 1,
        options: .curveEaseOut,
        animations: { [unowned self] in
          self.blackView.alpha = 0.5
          self.alertView.transform = .identity
        }, completion: nil)
    }
  }
  func showAlertView(
    title: String,
    description: String = "",
    grantMessage: String,
    denyMessage: String,
    okAction: PopupDialogButtonAction? = nil,
    cancelBtnAction: PopupDialogButtonAction? = nil
  ) {
    initializeMainView()
    
    denyButton.isHidden = false
    
    buttonAction = okAction
    cancelAction = cancelBtnAction
    titleLabel.text = title
    descriptionLabel.text = description
    denyButton.setTitle(denyMessage, for: .normal)
    denyButton.addTarget(self,
                         action: #selector(denyAction),
                         for: .touchUpInside)
    grantButton.setTitle(grantMessage, for: .normal)
    grantButton.addTarget(self,
                          action: #selector(grantAction),
                          for: .touchUpInside)
    
    let titlelabelLineCount = titleLabel.intrinsicContentSize.height / 24
    alertView.heightAnchor.constraint(equalToConstant: 170 + 24 * titlelabelLineCount).isActive = true
    
    if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
      let transform = CGAffineTransform(translationX: 0, y: -300)
      blackView.alpha = 0
      alertView.transform = transform
      UIView.animate(
        withDuration: 0.7,
        delay: 0,
        usingSpringWithDamping: 1,
        initialSpringVelocity: 1,
        options: .curveEaseOut,
        animations: { [unowned self] in
          self.blackView.alpha = 0.5
          self.alertView.transform = .identity
        }, completion: nil)
    }
  }
  
  @objc
  func grantAction() {
    if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
      let transform = CGAffineTransform(translationX: 0, y: 200)
      UIView.animate(
        withDuration: 0.3,
        delay: 0,
        usingSpringWithDamping: 1,
        initialSpringVelocity: 1,
        options: .curveEaseOut,
        animations: { [unowned self] in
          self.alertView.transform = transform
          self.alertView.alpha = 0
          self.blackView.alpha = 0
        } , completion: { _ in
          self.buttonAction?()
          self.blackView.removeFromSuperview()
          self.alertView.removeFromSuperview()
        })
    }
  }
  
  @objc
  func denyAction() {
    if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
      let transform = CGAffineTransform(translationX: 0, y: 200)
      UIView.animate(
        withDuration: 0.3,
        delay: 0,
        usingSpringWithDamping: 1,
        initialSpringVelocity: 1,
        options: .curveEaseOut,
        animations: { [unowned self] in
          self.alertView.transform = transform
          self.alertView.alpha = 0
          self.blackView.alpha = 0
        }, completion: { _ in
          self.cancelAction?()
          self.blackView.removeFromSuperview()
          self.alertView.removeFromSuperview()
        })
    }
  }
}



class BaseAlert: UIView {
  lazy var blackView: UIView = { [weak self] in
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = UIColor.black
    $0.alpha = 0.5
    return $0
  }(UIView(frame: .zero))
  
  let alertView: UIView = {
    $0.backgroundColor = UIColor.white
    $0.translatesAutoresizingMaskIntoConstraints = false
    return $0
  }(UIView(frame: .zero))
  
  let titleLabel: UILabel = {
    $0.font = .krTitle1
    $0.textColor = UIColor.black
    $0.textAlignment = .center
    $0.numberOfLines = 0
    $0.translatesAutoresizingMaskIntoConstraints = false
    return $0
  }(UILabel(frame: .zero))
  let descriptionLabel: UILabel = {
    $0.font = .krBody3
    $0.textColor = UIColor.black
    $0.textAlignment = .center
    $0.numberOfLines = 0
    $0.translatesAutoresizingMaskIntoConstraints = false
    return $0
  }(UILabel(frame: .zero))

  let grantButton: UIButton = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.titleLabel?.font = .krButton1
    $0.backgroundColor = UIColor.white
    $0.setTitleColor(UIColor.brandColorGreen01, for: .normal)
    $0.setTitle("", for: .normal)
    $0.layer.borderWidth = 0.5
    $0.layer.borderColor = UIColor.init(white: 60, alpha: 0.36).cgColor

    return $0
  }(UIButton(frame: .zero))
  
  let denyButton: UIButton = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.titleLabel?.font = .krButton2
    $0.backgroundColor = UIColor.white
    $0.setTitleColor(UIColor.brandColorGreen01, for: .normal)
    $0.setTitle("", for: .normal)
    $0.layer.borderWidth = 0.5
    $0.layer.borderColor = UIColor.init(white: 60, alpha: 0.36).cgColor
    return $0
  }(UIButton(frame: .zero))
  
  lazy var buttonStackView: UIStackView = { [weak self] in
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.addArrangedSubview(denyButton)
    $0.addArrangedSubview(grantButton)
    $0.distribution = .fillEqually
    $0.axis = .horizontal
    return $0
  }(UIStackView(frame: .zero))
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    initializeMainView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension BaseAlert {
  func initializeMainView() {
    if let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow }) {
      window.endEditing(true)
      alertView.alpha = 1
      blackView.alpha = 0.5
      
      blackView.frame = window.frame
      window.addSubview(blackView)
      window.addSubview(alertView)
      alertView.addSubview(titleLabel)
      alertView.addSubview(descriptionLabel)
      alertView.addSubview(buttonStackView)
      
      NSLayoutConstraint.activate([
        alertView.centerYAnchor.constraint(equalTo: window.centerYAnchor),
        alertView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 52),
        alertView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -52),
        
        titleLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
        titleLabel.widthAnchor.constraint(equalTo: alertView.widthAnchor, constant: 16),
        titleLabel.centerYAnchor.constraint(equalTo: alertView.centerYAnchor, constant: -24),
        
        descriptionLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
        descriptionLabel.widthAnchor.constraint(equalTo: alertView.widthAnchor, constant: 16),
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 8),
        
        buttonStackView.heightAnchor.constraint(equalToConstant: 48),
        buttonStackView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 0),
        buttonStackView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: 0),
        buttonStackView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 0)
      ])
    }
  }
}
