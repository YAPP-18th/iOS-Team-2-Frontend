//
//  SettingViewController.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/12.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Moya

class SettingViewController : ViewController {
  private let settingTableView = UITableView().then{
    $0.backgroundColor = .white
    $0.separatorStyle = .none
    $0.rowHeight = UITableView.automaticDimension
    $0.register(settingTableViewCell.self, forCellReuseIdentifier: settingTableViewCell.identifier)
    $0.register(settingTableViewHeader.self, forHeaderFooterViewReuseIdentifier: settingTableViewHeader.identifier)
  }
  private var sections: [String] = ["알림 설정", "계정 관리","기타"]
  private var items: [[String]] = [["알림 받기"],
                                   ["계정 이메일"],
                                   ["로그아웃", "탈퇴하기", "약관 및 정책"]]
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpTableview()
  }
  override func setupLayout() {
    self.view.add(settingTableView)
    settingTableView.snp.makeConstraints{
      $0.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
}
extension SettingViewController : UITableViewDelegate, UITableViewDataSource {
  func setUpTableview() {
    settingTableView.rx.setDelegate(self).disposed(by: disposeBag)
    settingTableView.rx.setDataSource(self).disposed(by: disposeBag)
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: settingTableViewHeader.identifier) as? settingTableViewHeader else {
      return nil
    }
    view.layout()
    view.titleLabel.text = sections[section]
    return view
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items[section].count
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: settingTableViewCell.identifier, for: indexPath) as? settingTableViewCell else {
      return UITableViewCell()
    }
    cell.layout()
    if indexPath.section == 0 && indexPath.row == 0 {
      cell.radioBtn.isHidden = false
    }
    cell.titleLabel.text = items[indexPath.section][indexPath.row]
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      print("알림 선택")
    case 1:
      print("계정 이메일 뷰로")
    case 2 :
      switch indexPath.row {
      case 0 :
        AlertAction.shared.showAlertView(title: "정말 로그아웃을 하시겠습니까?", grantMessage: "확인", denyMessage: "취소", okAction: {
          LoginManager.shared.makeLogoutStatus()
          if let window = self.view.window {
            self.navigator.show(segue: .splash(viewModel: SplashViewModel()), sender: self, transition: .root(in: window))
          }
        }, cancelBtnAction: nil)
        print("로그아웃")
      case 1 :
        AlertAction.shared.showAlertView(title: "정말 탈퇴 하시겠습니까?", grantMessage: "확인", denyMessage: "취소", okAction: {
          self.navigationController?.popToRootViewController(animated: true)
        }, cancelBtnAction: nil)
        print("탈퇴하기")
      case 2:
        let vc = CheckTermViewController(viewModel: nil, navigator: self.navigator)
        self.navigationController?.pushViewController(vc, animated: true)
        print("약관 뷰")
      default :
        print()
      }
    default :
      print()
    }
  }
}
class settingTableViewHeader : UITableViewHeaderFooterView, Identifiable {
  let titleLabel = UILabel().then {
    $0.font = .sdGhothicNeo(ofSize: 16, weight: .bold)
    $0.textColor = .black
    $0.backgroundColor = .white
  }
  func layout() {
    self.contentView.backgroundColor = .white
    self.add(titleLabel)
    titleLabel.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.centerY.equalToSuperview()
      $0.top.equalToSuperview().offset(21)
    }
  }
}
class settingTableViewCell : UITableViewCell {
  let titleLabel = UILabel().then {
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .regular)
  }
  let radioBtn = UISwitch().then{
    $0.onTintColor = #colorLiteral(red: 0.08600000292, green: 0.80400002, blue: 0.5649999976, alpha: 1)
    $0.isHidden = true
  }
  
  func layout() {
    self.selectionStyle = .none
    self.backgroundColor = .white
    self.adds([titleLabel, radioBtn])
    titleLabel.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(16)
      $0.centerY.equalToSuperview()
      $0.top.equalToSuperview().offset(8)
    }
    radioBtn.snp.makeConstraints{
      $0.trailing.equalToSuperview().offset(-16)
      $0.centerY.equalToSuperview()
      $0.width.equalTo(51)
      $0.height.equalTo(31)
    }
  }
}
