//
//  TabBarController.swift
//  YoongYoong
//
//  Copyright © 2021 YoongYoong. All rights reserved.
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
        case .myPage:
            let vc = MyPageViewController(viewModel: viewModel, navigator: navigator)
            return NavigationController(rootViewController: vc)
        case .post:
            let vc = PostSearchViewController(viewModel: viewModel, navigator: navigator)
            return NavigationController(rootViewController: vc)
        case .feed:
            let vc = FeedViewController(viewModel: viewModel, navigator: navigator)
            return NavigationController(rootViewController: vc)
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
    
    var selectedImage: UIImage? {
        switch self {
        case .home: return UIImage(named: "icTabbarHome_active")
        case .feed: return UIImage(named: "icTabbarFeed_active")
        case .post: return UIImage(named: "icTabbarPost_active")
        case .myPage: return UIImage(named: "icTabbarMyPage_active")
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
        let item = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        item.tag = rawValue
//        let item = UITabBarItem(title: title, image: image, tag: rawValue)
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
        setupShadowStyle()
        
        self.tabBar.tintColor = UIColor.systemGrayText01
        self.tabBar.unselectedItemTintColor = UIColor.systemGrayText01
        self.setViewControllers(self.viewControllers, animated:false)
        self.selectedIndex = 0
        self.delegate = self
    }
    
    func setupTabBarItems() {
        self.tabBar.items?.forEach { item in
            item.title = TabBarItem(rawValue: item.tag)?.title
            item.image = TabBarItem(rawValue: item.tag)?.image
            item.selectedImage = TabBarItem(rawValue: item.tag)?.selectedImage
        }
    }
    
    let tabBarDidSelected = PublishSubject<Void>()
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        let input = TabBarViewModel.Input(postTapDidTap: tabBarDidSelected)
        let output = viewModel.transform(input: input)
        
        output.tabBarItems.drive(onNext: { [weak self] tabBarItems in
            guard let self = self else { return }
            let controllers = tabBarItems.map {
                $0.getController(
                    with: viewModel.viewModel(for: $0),
                    navigator: self.navigator)
            }
            self.setupTabBarItems()
            self.setViewControllers(controllers, animated: true)
        }).disposed(by: self.disposeBag)
        
        output.postView
            .subscribe(onNext: { [weak self] viewModel in
                guard let self = self else { return }
                self.navigator.show(segue: .post(viewModel: viewModel),
                                    sender: self,
                                    transition: .post)
            }).disposed(by: disposeBag)
      output.login.subscribe(onNext: { [weak self] in
        self?.showLoginAlert()
      }).disposed(by: disposeBag)
        output.setting
            .subscribe(onNext: { [weak self] in
                self?.alertSetting()
            }).disposed(by: disposeBag)
        
    }
    
    private func alertSetting() {
        let alertController = UIAlertController(title: "알림", message: "위치 정보 확인을 위해 설정에서 위치 권한을 허용해주세요.", preferredStyle: .alert)
        alertController.addAction(.init(title: "권한설정", style: .default, handler: { _ in
            guard let url = URL(string: "App-prefs:root=Privacy&path=LOCATION") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))
        alertController.addAction(.init(title: "취소", style: .cancel))
        self.present(alertController, animated: true)
    }
    
    func setupShadowStyle() {
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
    }
  
  func showLoginAlert() {
    AlertAction.shared.showAlertView(title: "로그인이 필요한 서비스입니다.",description: "로그인 화면으로 이동하시겠습니까?", grantMessage: "확인", denyMessage: "취소", okAction: { [weak self] in
      LoginManager.shared.makeLogoutStatus()
      if let window = self?.view.window {
          self?.navigator.show(segue: .splash(viewModel: SplashViewModel()), sender: self, transition: .root(in: window))
      }
    })
  }
    
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let viewController = viewController as? NavigationController,
              viewController.topViewController is PostSearchViewController else { return true }
        tabBarDidSelected.onNext(())
        return false
    }
}

extension CALayer {
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}

extension UITabBar {
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
