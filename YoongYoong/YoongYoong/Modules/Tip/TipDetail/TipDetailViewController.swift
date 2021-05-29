//
//  TipDetailViewController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/05/07.
//

import UIKit
import SnapKit

class TipDetailViewController: ViewController {
  
  var topConstraint: Constraint!
  
  let backgroundImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  var safeareaHeight: CGFloat {
    return UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height ?? 0
  }
  
  var bottomPadding: CGFloat {
    return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
  }
  
  var backgroungImage: UIImage?
  
  
  let dimmView = UIView().then {
    $0.backgroundColor = UIColor(red: 18, green: 18, blue: 18).withAlphaComponent(0.7)
    $0.isUserInteractionEnabled = true
  }
  
  var tipView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.backgroundImageView.image = self.backgroungImage
  }
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    if self.isDarkMode {
      self.tipView.backgroundColor = .systemGray05
    } else {
      self.tipView.backgroundColor = .systemGray00
    }
  }
  override func configuration() {
    super.configuration()
    if self.isDarkMode {
      self.tipView.backgroundColor = .systemGray05
    } else {
      self.tipView.backgroundColor = .systemGray00
    }
    
  }
  
  override func setupView() {
    super.setupView()
    self.view.addSubview(backgroundImageView)
    self.view.addSubview(dimmView)
    self.view.addSubview(tipView)
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    backgroundImageView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.top.bottom.equalToSuperview()
    }
    dimmView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    tipView.snp.makeConstraints {
      self.topConstraint = $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(30).constraint
      $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.bottom.equalToSuperview()
    }
    
    let gesture = UITapGestureRecognizer(target: self, action: #selector(hideAndCloseTip))
    self.dimmView.addGestureRecognizer(gesture)
    
    topConstraint.update(offset: self.safeareaHeight + bottomPadding)
    dimmView.alpha = 0.0
  }
  
  @objc func tipPanned(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: self.view)
    let velocity = gesture.velocity(in: self.view)
    switch gesture.state {
    case .began:
      print("began")
    case .changed:
      if translation.y > 30.0 {
        self.topConstraint.update(offset: 30 + translation.y)
      }
    case .ended:
      if velocity.y > 1500.0 {
        hideAndCloseTip()
        return
      }
      if translation.y < ((safeareaHeight + bottomPadding) * 0.25){
        showTip()
      } else {
        hideAndCloseTip()
      }
    default:
      break
    }
  }
  
  @objc func hideAndCloseTip() {
    self.view.layoutIfNeeded()
    
    topConstraint.update(offset: safeareaHeight + bottomPadding)
    
    let showTip = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn) {
      self.view.layoutIfNeeded()
    }
    
    showTip.addAnimations {
      self.dimmView.alpha = 0.0
    }
    
    showTip.addCompletion { (position) in
      if position == .end {
        self.dismiss(animated: true, completion: nil)
      }
    }
    showTip.startAnimation()
  }
  
  private func showTip() {
    self.view.layoutIfNeeded()
    
    topConstraint.update(offset: 30)
    
    let showTip = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn) {
      self.view.layoutIfNeeded()
    }
    
    showTip.addAnimations {
      self.dimmView.alpha = 0.7
    }
    
    
    showTip.startAnimation()
  }
  
  
  
  
}
