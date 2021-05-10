//
//  PostNavigationController.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/08.
//

import UIKit
import SnapKit

enum Post: Int{
  case search = 1, map,selectImage, selectMenu, post
  
  static func title(_ rawValue: Int) -> String? {
    switch Post(rawValue: rawValue) {
    case .search:
      return "위치 입력"
    case .map:
      return "매장 선택"
    case .selectImage:
      return "사진 선택"
    case .selectMenu:
      return "메뉴, 용기 입력"
    case .post:
     return "후기 작성"
    default:
      return nil
    }
  }
  
}

class PostNavigationController: UINavigationController {
  static let postDepth: Float = 5.0
  
  let progressView = UIProgressView().then {
    $0.progressTintColor = .brandColorGreen01
    $0.progress = 0.0
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
    setupNavigationBar()
  }
  
  private func setupNavigationBar() {
    // layout
    navigationBar.addSubview(progressView)
    progressView.snp.makeConstraints {
      $0.left.right.bottom.equalToSuperview()
    }
    
    // attributes
    navigationBar.backgroundColor = .white
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = false
    navigationBar.tintColor = .brandColorGreen01
    navigationBar.titleTextAttributes = [.foregroundColor: UIColor.brandColorGreen01,
                                         .font: UIFont.krTitle2]
    
  }
  
}

extension PostNavigationController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    let flowProgress = Float(navigationController.viewControllers.count)/PostNavigationController.postDepth
    self.progressView.setProgress(flowProgress, animated: animated)

    viewController.navigationItem.title = Post.title(navigationController.viewControllers.count)
    
    if navigationController.viewControllers.count == 1 {
      viewController.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "closeButtonGreen"), style: .done, target: self, action: #selector(dismissVC))]
    } else {
      viewController.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "icBtnNavBack"), style: .done, target: self, action: #selector(popVC))]
    }
    
  }
  
  @objc
  private func popVC() {
    self.popViewController(animated: true)
  }
  @objc
  private func dismissVC() {
    self.dismiss(animated: true, completion: nil)
  }
}
