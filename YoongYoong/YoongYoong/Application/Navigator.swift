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
    case splash(viewModel: SplashViewModel)
    case tabs(viewModel: TabBarViewModel)
    case login(viewModel: LoginViewModel)
    case kakaoLogin(viewModel: KakaoLoginViewModel)
    case findPassword(viewModel: FindPasswordViewModel)
    case findPasswordCode(viewModel: FindPasswordCodeViewModel)
    case findPasswordInput(viewModel: FindPasswordInputViewModel)
    case registrationTerms(viewModel: RegistrationTermsViewModel)
    case registrationEmail(viewModel: RegistrationEmailViewModel)
    case registrationPassword(viewModel: RegistrationPasswordViewModel)
    case registrationProfile(viewModel: RegistrationProfileViewModel)
    case map(viewModel: MapViewModel)
    case mapSearch(viewModel: MapSearchViewModel)
    case mapSearchResult(viewModel: MapSearchResultViewModel)
    case tip(viewModel: TipViewModel)
    case feedProfile(viewModel: FeedProfileViewModel)
    case feedDetail(viewModel: FeedDetailViewModel)
    case onboarding(viewModel: ViewModel? = nil)
    case post(viewModel: PostSearchViewModel)
    case postMap(viewModel: PostMapViewModel)
    case selectImage(viewModel: PostImageSelectionViewModel)
    case selectMenu(viewModel: SelectMenuViewModel)
    case selectContainer(viewModel: SelectContainerViewModel)
    case addReview(viewModel: PostReviewViewModel)
    case alertList(viewModel: AlertViewModel)
    case settingList(viewModel: SettingViewModel)
    case store(viewModel: StoreViewModel)
    case editProfile(viewModel: EditProfileViewModel)
  }
  
  enum Transition {
    enum Direction {
      case left
      case right
    }
    
    case root(in: UIWindow)
    case navigation(_ direction: Direction = .right, animated: Bool = true, hidesTabbar: Bool = false)
    case post
    case customModal
    case modal
    case modalFullScreen
    case detail
    case alert
    case setting
    case custom
  }
  
  func get(segue: Scene) -> UIViewController? {
    switch segue {
    case .splash(let viewModel):
      let splashVC = SplashViewController(viewModel: viewModel, navigator: self)
      return splashVC
    case .tabs(let viewModel):
      let rootVC = TabBarController(viewModel: viewModel, navigator: self)
      return rootVC
    case .login(let viewModel):
      let loginVC = LoginViewController(viewModel: viewModel, navigator: self)
      let nav = NavigationController(rootViewController: loginVC)
      return nav
    case .kakaoLogin(let viewModel):
      let kakaoLoginVC = KakaoLoginViewController(viewModel: viewModel, navigator: self)
      return kakaoLoginVC
    case .findPassword(let viewModel):
      let findPasswordVC = FindPasswordViewController(viewModel: viewModel, navigator: self)
      return findPasswordVC
    case .findPasswordCode(let viewModel):
      let findPasswordCodeVC = FindPasswordCodeViewController(viewModel: viewModel, navigator: self)
      return findPasswordCodeVC
    case .findPasswordInput(let viewModel):
      let findPasswordInputVC = FindPasswordInputViewController(viewModel: viewModel, navigator: self)
      return findPasswordInputVC
    case .registrationTerms(let viewModel):
      let regTermsVC = RegistrationTermsViewController(viewModel: viewModel, navigator: self)
      return regTermsVC
    case .registrationEmail(let viewModel):
      let regEmailVC = RegistrationEmailViewController(viewModel: viewModel, navigator: self)
      return regEmailVC
    case .registrationPassword(let viewModel):
      let regPasswordVC = RegistrationPasswordViewController(viewModel: viewModel, navigator: self)
      return regPasswordVC
    case .registrationProfile(let viewModel):
      let regProfileVC = RegistrationProfileViewController(viewModel: viewModel, navigator: self)
      return regProfileVC
    case let .map(viewModel):
      let mapVC = MapViewController(viewModel: viewModel, navigator: self)
      return mapVC
    case let .mapSearch(viewModel):
      let mapSearchVC = MapSearchViewController(viewModel: viewModel, navigator: self)
      return mapSearchVC
    case let .mapSearchResult(viewModel):
      let mapSearchResultVC = MapSearchResultViewController(viewModel: viewModel, navigator: self)
      return mapSearchResultVC
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
    case .addReview(let viewModel):
      let reviewVC = PostReviewViewController(viewModel: viewModel, navigator: self)
      return reviewVC
    case .feedProfile(let viewModel):
      let feedProfileVC = FeedProfileViewController(viewModel: viewModel, navigator: self)
      return feedProfileVC
    case .alertList(viewModel: let viewModel):
      let alertListVC = AlertListViewController(viewModel: viewModel, navigator: self)
      alertListVC.hidesBottomBarWhenPushed = true
      return alertListVC
    case .settingList(viewModel: let viewModel):
      let settingVC = SettingViewController(viewModel: viewModel, navigator: self)
      settingVC.hidesBottomBarWhenPushed = true
      return settingVC
    case .feedDetail(let viewModel):
      let feedDetailVC = FeedDetailViewController(viewModel: viewModel, navigator: self)
      feedDetailVC.hidesBottomBarWhenPushed = true
      return feedDetailVC
    case .store(let viewModel):
      let storeVC = StoreViewController(viewModel: viewModel, navigator: self)
      return storeVC
    case .editProfile(let viewModel):
      let editProfileVC = EditProfileViewController(viewModel: viewModel, navigator: self)
      editProfileVC.hidesBottomBarWhenPushed = true
      return editProfileVC
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
    case let .navigation(direction, animated, hidesTabbar):
      if let nav = sender.navigationController {
        // push controller to navigation stack
        switch direction{
        case .left:
          var vcs = nav.viewControllers
          vcs.insert(target, at: vcs.count - 1)
          nav.setViewControllers(vcs, animated: false)
          nav.popViewController(animated: animated)
        case .right:
          target.hidesBottomBarWhenPushed = hidesTabbar
          nav.pushViewController(target, animated: animated)
        }
      }
    case .modal:
      // present modally
      DispatchQueue.main.async {
        let nav = NavigationController(rootViewController: target)
        sender.present(nav, animated: true, completion: nil)
      }
      
    case .post:
      DispatchQueue.main.async {
        let nav = PostNavigationController(rootViewController: target)
        nav.modalPresentationStyle = .fullScreen
        sender.present(nav, animated: true, completion: nil)
      }
      
    case .modalFullScreen:
      DispatchQueue.main.async {
        target.modalPresentationStyle = .fullScreen
        sender.present(target, animated: true, completion: nil)
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
