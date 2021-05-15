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
    case login(viewModel: LoginViewModel)
    case registrationTerms(viewModel: RegistrationTermsViewModel)
    case registrationEmail(viewModel: RegistrationEmailViewModel)
    case registrationPassword(viewModel: RegistrationPasswordViewModel)
    case tip(viewModel: TipViewModel)
    case feedProfile(viewModel: FeedProfileViewModel)
    case onboarding(viewModel: ViewModel? = nil)
    case post(viewModel: PostSearchViewModel)
    case postMap(viewModel: PostMapViewModel)
    case selectImage(viewModel: PostImageSelectionViewModel)
    case selectMenu(viewModel: SelectMenuViewModel)
    case selectContainer(viewModel: SelectContainerViewModel)
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
    case modalFullScreen
    case detail
    case alert
    case custom
  }
  
  func get(segue: Scene) -> UIViewController? {
    switch segue {
    case .tabs(let viewModel):
      let rootVC = TabBarController(viewModel: viewModel, navigator: self)
      return rootVC
    case .login(let viewModel):
      let loginVC = LoginViewController(viewModel: viewModel, navigator: self)
      return loginVC
    case .registrationTerms(let viewModel):
      let regTermsVC = RegistrationTermsViewController(viewModel: viewModel, navigator: self)
      return regTermsVC
    case .registrationEmail(let viewModel):
      let regEmailVC = RegistrationEmailViewController(viewModel: viewModel, navigator: self)
      return regEmailVC
    case .registrationPassword(let viewModel):
      let regPasswordVC = RegistrationPasswordViewController(viewModel: viewModel, navigator: self)
      return regPasswordVC
    case.tip(let viewModel):
      let tipVC = TipViewController(viewModel: viewModel, navigator: self)
      return tipVC
    case .onboarding(let viewModel) :
      if let vm = viewModel {
        let vc = LoginViewController(viewModel: vm, navigator: self)
        return vc
      }
      else {
        let onboardingVC = OnboradingViewController(viewModel: nil, navigator: self)
        let navi = UINavigationController()
        navi.viewControllers = [onboardingVC]
        return navi
      }
    case.post(let viewModel):
      let postVC = PostSearchViewController(viewModel: viewModel, navigator: self)
      return postVC
    case .postMap(let viewModel):
      let postMapVC = PostMapViewController(viewModel: viewModel, navigator: self)
      return postMapVC
    case .selectImage(let viewModel):
    let vc = PostImageSelectionViewController(viewModel: viewModel, navigator: self)
    return vc
    case .selectMenu(let viewModel):
    let selectMenuVc = SelectMenuViewController(viewModel: viewModel, navigator: self)
    return selectMenuVc
    case .selectContainer(let viewModel):
    let selectContainerVC = SelectContainerViewController(viewModel: viewModel, navigator: self)
    return selectContainerVC
      
    case .feedProfile(let viewModel):
      let feedProfileVC = FeedProfileViewController(viewModel: viewModel, navigator: self)
      return feedProfileVC
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
      return
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
      
    case .modalFullScreen:
      DispatchQueue.main.async {
        let nav = NavigationController(rootViewController: target)
        nav.modalPresentationStyle = .fullScreen
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
