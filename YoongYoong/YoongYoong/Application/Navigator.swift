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
    case tip(viewModel: TipViewModel)
  }
  
  enum Transition {
    enum Direction {
      case left
      case right
    }
    
    case root(in: UIWindow)
    case navigation(_ direction: Direction = .right)
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
    case.tip(let viewModel):
      let tipVC = TipViewController(viewModel: viewModel, navigator: self)
      return tipVC
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
    case .custom:
      return
    default:
      break
    }
    
    guard let sender = sender else {
      fatalError("navigation 또는 model 사용시 sender 전달은 필수입니다.")
    }
    
    switch transition {
    case .navigation(let direction):
      if let nav = sender.navigationController {
        // push controller to navigation stack
        switch direction{
        case .left:
          var vcs = nav.viewControllers
          vcs.insert(target, at: vcs.count - 1)
          nav.setViewControllers(vcs, animated: false)
          nav.popViewController(animated: true)
        case .right:
          nav.pushViewController(target, animated: true)
        }
      }
    case .modal:
      // present modally
      DispatchQueue.main.async {
        let nav = NavigationController(rootViewController: target)
        sender.present(nav, animated: true, completion: nil)
      }
    case .detail:
      DispatchQueue.main.async {
        let nav = NavigationController(rootViewController: target)
        sender.showDetailViewController(nav, sender: nil)
      }
    case .alert:
      DispatchQueue.main.async {
        sender.present(target, animated: true, completion: nil)
      }
    default: break
    }
  }
}
