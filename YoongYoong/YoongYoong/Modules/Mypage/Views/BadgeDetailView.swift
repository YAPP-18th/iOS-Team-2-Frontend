//
//  BadgeDetailView.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/02.
//

import Foundation
import UIKit
class showBadgeDetailView : BadgeDetailView {
      typealias PopupDialogButtonAction = () -> Void

      static let shared = showBadgeDetailView()
      var buttonAction: PopupDialogButtonAction?
      override init(frame: CGRect) {
          super.init(frame: frame)

      }

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
extension showBadgeDetailView {
  func showBadge(image: String, title: String, description: String, condition :String, conditionAction :PopupDialogButtonAction? = nil) {
      initializeMainView()
      let style = NSMutableParagraphStyle()
      style.lineSpacing = 28/20
      style.alignment = .center
      buttonAction = conditionAction
      titleLabel.text = title
    self.image.image = UIImage(named: image)
    blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(denyAction)))
    descriptionLabel.text = description
    conditionBtn.setTitle(condition, for: .normal)
      dissmissBtn.addTarget(self,
                            action: #selector(dismissAlertView),
                            for: .allTouchEvents)
      conditionBtn.addTarget(self, action: #selector(denyAction), for: .allTouchEvents)
      if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
          let transform = CGAffineTransform(translationX: 0, y: 300)
        badgeDetailView.transform = transform
          blackView.alpha = 0
          UIView.animate(withDuration: 0.7,
                         delay: 0,
                         usingSpringWithDamping: 1,
                         initialSpringVelocity: 1,
                         options: .curveEaseOut,
                         animations: {
                          self.blackView.alpha = 0.5
                          self.badgeDetailView.transform = .identity
                         }, completion: nil)
      }
  }

  @objc
  func dismissAlertView() {
      if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
          let transform = CGAffineTransform(translationX: 0, y: 200)
          UIView.animate(withDuration: 0.3,
                         delay: 0,
                         usingSpringWithDamping: 1,
                         initialSpringVelocity: 1,
                         options: .curveEaseOut,
                         animations: { [unowned self] in
                          self.badgeDetailView.transform = transform
                          self.badgeDetailView.alpha = 0
                          self.blackView.alpha = 0
                         }, completion: { _ in
                          self.buttonAction?()
                          self.blackView.removeFromSuperview()
                          self.badgeDetailView.removeFromSuperview()
                         })
      }
  }
  @objc
  func denyAction(gestuer : UITapGestureRecognizer) {
      if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil {
          let transform = CGAffineTransform(translationX: 0, y: 200)
          UIView.animate(
              withDuration: 0.3,
              delay: 0,
              usingSpringWithDamping: 1,
              initialSpringVelocity: 1,
              options: .curveEaseOut,
              animations: { [unowned self] in
                  self.badgeDetailView.transform = transform
                  self.badgeDetailView.alpha = 0
                  self.blackView.alpha = 0
              }, completion: { _ in
                  self.blackView.removeFromSuperview()
                  self.badgeDetailView.removeFromSuperview()
              })
      }
  }
}

class BadgeDetailView: UIView{
  lazy var blackView: UIView = { [weak self] in
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = UIColor.black
    $0.alpha = 0.5
    return $0
  }(UIView(frame: .zero))
  
  let badgeDetailView: UIView = {
    $0.backgroundColor = UIColor.white
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    $0.layer.cornerRadius = 16
    $0.translatesAutoresizingMaskIntoConstraints = false
    return $0
  }(UIView(frame: .zero))
  let image = UIImageView()
  let titleLabel = UILabel().then{
    $0.textColor = .black
    $0.font = .sdGhothicNeo(ofSize: 16, weight: .bold)
    $0.textAlignment = .center
  }
  let descriptionLabel = UILabel().then{
    $0.textColor = .systemGrayText02
    $0.font = .krBody2
    $0.textAlignment = .center
    $0.numberOfLines = 2
  }
  let conditionBtn = UIButton().then{
    $0.setTitleColor(.brandColorTertiary01, for: .normal)
    $0.titleLabel?.font = .sdGhothicNeo(ofSize: 14, weight: .regular)
  }
  let dissmissBtn = UIButton()
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    initializeMainView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func initializeMainView() {
    if let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow }) {
      window.endEditing(true)
      badgeDetailView.alpha = 1
      blackView.alpha = 0.5

      blackView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
      window.addSubview(blackView)
      window.addSubview(badgeDetailView)
      badgeDetailView.adds([titleLabel,image,descriptionLabel,conditionBtn,dissmissBtn])
      badgeDetailView.snp.makeConstraints{
        $0.leading.trailing.bottom.equalToSuperview()
        $0.height.equalTo(374)
      }
      dissmissBtn.snp.makeConstraints{
        $0.trailing.equalToSuperview().offset(-16)
        $0.top.equalToSuperview().offset(16)
        $0.width.height.equalTo(22)
      }
      image.snp.makeConstraints{
        $0.top.equalToSuperview().offset(47)
        $0.centerX.equalToSuperview()
        $0.width.height.equalTo(110)
      }
      titleLabel.snp.makeConstraints{
        $0.top.equalTo(image.snp.bottom).offset(24)
        $0.centerX.equalToSuperview()
      }
      descriptionLabel.snp.makeConstraints{
        $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        $0.centerX.equalToSuperview()
      }
      conditionBtn.snp.makeConstraints{
        $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
        $0.centerX.equalToSuperview()
      }
    }
  }
}
