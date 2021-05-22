//
//  MyPostCollectionViewCell.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/02.
//

import UIKit
import RxSwift
import RxCocoa

class MyPostCollectionViewCell: UICollectionViewCell {
  let disposeBag = DisposeBag()
  private let monthlyInformationView = UIView().then{
    $0.backgroundColor = UIColor.brandColorGreen01.withAlphaComponent(0.5)
  }
  private let timeStampLabel = UILabel().then{
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .bold)
    $0.textAlignment = .center
    $0.textColor = .black
  }
  private let postImage = UIImageView().then {
    $0.image = UIImage(named: "")
  }
  private let postCount = UILabel().then{
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .bold)
  }
  private let packageImage = UIImageView().then {
    $0.image = UIImage(named: "")
  }
  private let packageCount = UILabel().then{
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .bold)
  }
  private let tableView = UITableView().then{
    $0.rowHeight = UITableView.automaticDimension
    $0.estimatedRowHeight = 130
    $0.backgroundColor = .systemGray
    $0.separatorStyle = .none
    $0.register(MyPostTableViewCell.self,
                forCellReuseIdentifier: MyPostTableViewCell.identifier)
    $0.isScrollEnabled = true
  }
  let nextMonthBtn = UIButton().then{
    $0.setImage(UIImage(named: ""), for: .normal)
  }
  let lastMonthBtn = UIButton().then{
    $0.setImage(UIImage(named: ""), for: .normal)
  }
  private var cellCount = 0
}
extension MyPostCollectionViewCell{
  func bindCell(model: PostListModel) {
    cellCount = model.postList.count
    layout()
    self.timeStampLabel.text = model.month
    self.postCount.text = "\(model.postCount)"
    self.packageCount.text = "\(model.packageCount)"
    Observable.just(model.postList)
      .bind(to: tableView.rx.items(cellIdentifier: MyPostTableViewCell.identifier,
                                   cellType: MyPostTableViewCell.self)) { row, data, cell in
        cell.bind(model: data)
      }.disposed(by: disposeBag)
    Observable.zip(tableView.rx.itemSelected,
                   tableView.rx.modelSelected(PostSimpleModel.self))
    tableView.rx
        .observeWeakly(CGSize.self, "contentSize")
        .compactMap { $0?.height }
        .distinctUntilChanged()
        .bind { [weak self] height in
          self?.tableView.snp.updateConstraints{
            $0.height.equalTo(height)
          }
        }
        .disposed(by: disposeBag)
    
  }
  
}
extension MyPostCollectionViewCell {
  private func layout() {
    self.contentView.adds([monthlyInformationView,tableView])
    monthlyInformationView.adds([timeStampLabel,
                                 postImage,
                                 postCount,
                                 packageImage,
                                 packageCount,
                                 nextMonthBtn,
                                 lastMonthBtn])
    monthlyInformationView.snp.makeConstraints{
      $0.leading.trailing.top.equalToSuperview()
      $0.height.equalTo(80)
    }
    timeStampLabel.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(12)
    }
    nextMonthBtn.snp.makeConstraints{
      $0.centerY.trailing.equalToSuperview()
      $0.width.height.equalTo(40)
      $0.top.equalToSuperview().offset(20)
    }
    lastMonthBtn.snp.makeConstraints{
      $0.centerY.leading.equalToSuperview()
      $0.width.height.equalTo(40)
      $0.top.equalToSuperview().offset(20)
    }
    postImage.snp.makeConstraints{
      $0.top.equalTo(timeStampLabel.snp.bottom).offset(11)
      $0.centerX.equalToSuperview().offset(-87)
      $0.width.height.equalTo(24)
    }
    postCount.snp.makeConstraints{
      $0.centerY.equalTo(postImage)
      $0.leading.equalTo(postImage.snp.trailing).offset(4)
    }
    packageImage.snp.makeConstraints{
      $0.top.equalTo(timeStampLabel.snp.bottom).offset(11)
      $0.centerX.equalToSuperview().offset(87)
      $0.width.height.equalTo(24)
    }
    packageCount.snp.makeConstraints{
        $0.centerY.equalTo(packageImage)
        $0.leading.equalTo(packageImage.snp.trailing).offset(4)
    }
    tableView.snp.makeConstraints{
      $0.top.equalTo(monthlyInformationView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
        $0.height.equalTo(300)
    }
  }
}
