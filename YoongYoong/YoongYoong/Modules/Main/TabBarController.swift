//
//  TabBarController.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/04/17.
//

import UIKit
import RxSwift

enum TabBarItem: Int {
  case home, feed, post, myPage
  
  private func controller(with viewModel: ViewModel, navigator: Navigator) -> UIViewController {
    switch self {
    case .home:
      let vc = MapViewController(viewModel: viewModel, navigator: navigator)
      return NavigationController(rootViewController: vc)
//    case .feed:
//    case .post:
//    case .myPage:
    default:
      return ViewController(viewModel: viewModel, navigator: navigator)
    }
  }
  
  var image: UIImage? {
    switch self {
    case .home: return UIImage(named: "icTabbarHome_inactive")
    case .feed: return UIImage(named: "icTabbarFeed_inactive")
    case .post: return UIImage(named: "icTabbarPost_inactive")
    case .myPage: return UIImage(named: "icTabbarMyPage_inactive")
    }
  }
  
  var title: String {
    switch self {
    case .home: return "홈"
    case .feed: return "피드"
    case .post: return "포스트"
    case .myPage: return "마이페이지"
    }
  }
  
  func getController(with viewModel: ViewModel, navigator: Navigator) -> UIViewController {
      let vc = controller(with: viewModel, navigator: navigator)
      let item = UITabBarItem(title: title, image: image, tag: rawValue)
      vc.tabBarItem = item
      return vc
  }
}

class TabBarController: UITabBarController, Navigatable {
  let disposeBag = DisposeBag()
  
  var viewModel: TabBarViewModel?
  var navigator: Navigator!
  
  init(viewModel: ViewModel?, navigator: Navigator) {
    self.viewModel = viewModel as? TabBarViewModel
    self.navigator = navigator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bindViewModel()
  }
  
  func setupUI() {
    self.tabBar.items?.forEach { item in
      item.title = TabBarItem(rawValue: item.tag)?.title
    }
    
    self.setViewControllers(self.viewControllers, animated:false)
    self.selectedIndex = 0
  }
  
  func bindViewModel() {
    guard let viewModel = viewModel else { return }
    
    let input = TabBarViewModel.Input()
    let output = viewModel.transform(input: input)
    
    output.tabBarItems.drive(onNext: { [weak self] tabBarItems in
      guard let self = self else { return }
      let controllers = tabBarItems.map {
        $0.getController(
          with: viewModel.viewModel(for: $0),
          navigator: self.navigator)
      }
      self.setViewControllers(controllers, animated: true)
    }).disposed(by: self.disposeBag)
  }
}
