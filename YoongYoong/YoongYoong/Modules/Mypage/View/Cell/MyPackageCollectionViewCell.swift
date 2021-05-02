//
//  MyPackageCollectionViewCell.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/02.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
typealias DataSource = RxTableViewSectionedReloadDataSource

typealias PackageSectionType = AnimatableSectionModel<String,PackageSimpleModel>

class MyPackageCollectionViewCell: UICollectionViewCell {
    private let tableView = UITableView()
  private let disposeBag = DisposeBag()
  lazy var dataSource = DataSource<PackageSectionType> (
      configureCell: configureCell
  )
}
extension MyPackageCollectionViewCell: UITableViewDelegate {
  func setupTableView() {
    tableView.rx
        .setDelegate(self)
        .disposed(by: disposeBag)
    tableView.rowHeight = 40
    tableView.register(MyPackageTableViewCell.self,
                       forCellReuseIdentifier: MyPackageTableViewCell.identifier)
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let title = UILabel().then{
      $0.font = .sdGhothicNeo(ofSize: 14, weight: .bold)
      $0.textColor = .black
    }
    let image = UIImageView()
    let headerView = UIView().then{
      $0.backgroundColor = .brandColorBlue03
    }
    headerView.adds([image, title])
    image.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(20)
      $0.width.height.equalTo(22)
      $0.centerY.equalToSuperview()
    }
    title.snp.makeConstraints{
      $0.leading.equalTo(image.snp.trailing).offset(4)
      $0.centerY.equalToSuperview()
    }
    title.text = dataSource[section].model
    image.image = UIImage(named: dataSource[section].model.packageType)
    return headerView
  }
  
}
extension MyPackageCollectionViewCell {
  private var configureCell: DataSource<PackageSectionType>.ConfigureCell {
          return {[weak self] ds, tableView, indexPath, item -> UITableViewCell in
            
             return UITableViewCell()
          }
      }
}
