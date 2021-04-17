//
//  Navigator.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/17.
//

import UIKit
import RxSwift
import RxCocoa

protocol Navigatable {
  var navigator: Navigator! { get set }
}

class Navigator {
  static var shared = Navigator()
  
  enum Scene {
    case tabs(viewModel: TabBarViewModel)
  }
  
  enum Transition {
    case root(in: UIWindow)
    case navigation
    case customModal
    case modal
    case detail
    case alert
    case custom
  }
  
  func get(segue: Scene) -> UIViewController? {
    switch segue {
    case .tabs(let viewModel):
      let rootVC = TabBarController(viewModel: viewModel, navigator: self)
      return rootVC
    }
  }
  
  func show(segue: Scene, sender: UIViewController?, transition: Transition) {
    if let target = get(segue: segue) {
      show(target: target, sender: sender, transition: transition)
    }
  }
  
  private func show(target: UIViewController, sender: UIViewController?, transition: Transition) {
    switch transition{
    case .root(in: let window):
      window.rootViewController = target
    default:
      break
    }
  }
}
