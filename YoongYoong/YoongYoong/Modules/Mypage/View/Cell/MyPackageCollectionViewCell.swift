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
  private var collectionView : UICollectionView!
  private let disposeBag = DisposeBag()
  lazy var dataSource = DataSource<PackageSectionType> (
    configureCell: configureCell
  )
}
extension MyPackageCollectionViewCell {
  func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = UICollectionViewFlowLayout.automaticSize
    layout.estimatedItemSize = CGSize(width: 63, height: 28)
    layout.minimumLineSpacing = 4
    layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    self.collectionView.register(MyPackageFilterCollectionViewCell.self,
                                  forCellWithReuseIdentifier: MyPackageFilterCollectionViewCell.identifier)
    self.collectionView.backgroundColor = .white
    self.collectionView.showsVerticalScrollIndicator = false
    self.collectionView.showsHorizontalScrollIndicator = false
  }
}
extension MyPackageCollectionViewCell: UITableViewDelegate {
  func setupTableView() {
    tableView.rowHeight = 40
    tableView.sectionHeaderHeight = 32
    tableView.separatorStyle = .none
    tableView.register(MyPackageTableViewCell.self,
                       forCellReuseIdentifier: MyPackageTableViewCell.identifier)
    tableView.register(PackageTableViewHeader.self,
                       forHeaderFooterViewReuseIdentifier: PackageTableViewHeader.identifier)
    
    //델리게이트 안쓰고 헤더는 못쓰는건가요...?
    
    
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard  let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: PackageTableViewHeader.identifier) as? PackageTableViewHeader else {
      return UIView()
    }
    view.layout()
    view.image.image = UIImage(named: dataSource[section].model.packageType)
    view.title.text = dataSource[section].model
    return view
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 32
  }
  func bindCell(model : [PackageSectionType]) {
    layout()
    Observable.just(model)
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  
    tableView.rx
        .observeWeakly(CGSize.self, "contentSize")
        .compactMap { $0?.height }
        .distinctUntilChanged()
        .bind { [weak self] height in
          self?.tableView.snp.updateConstraints{
            $0.height.equalTo((height + 1).rounded())
          }
        }
        .disposed(by: disposeBag)
  }
}
extension MyPackageCollectionViewCell {
  private var configureCell: DataSource<PackageSectionType>.ConfigureCell {
    return {[weak self] ds, tableView, indexPath, item -> UITableViewCell in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPackageTableViewCell.identifier) as? MyPackageTableViewCell else {
        return UITableViewCell()
      }
      cell.bind(model: item)
      cell.favorateBtn.rx.tap.takeUntil(cell.rx.methodInvoked(#selector(UITableViewCell.prepareForReuse)))
        .bind{[weak self] in
          print(item)
          cell.favorateBtn.isSelected.toggle()
        }.disposed(by: cell.disposeBag)
      return cell
    }
  }
  
  private func layout() {
    self.contentView.backgroundColor = #colorLiteral(red: 0.92900002, green: 0.92900002, blue: 0.92900002, alpha: 1)
    self.contentView.add(tableView)
    self.contentView.add(collectionView)
    tableView.snp.makeConstraints{
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalToSuperview().offset(48)
      $0.height.equalTo(300)
    }
    collectionView.snp.makeConstraints{
      $0.leading.trailing.top.equalToSuperview()
      $0.bottom.equalTo(tableView.snp.top)
    }
  }
}
class PackageTableViewHeader :UITableViewHeaderFooterView , Identifiable{
  let image = UIImageView()
  let headerView = UIView().then{
    $0.backgroundColor = .brandColorBlue03
  }
  let title = UILabel()
  func layout(){
    self.add(headerView)
    headerView.snp.makeConstraints{
      $0.leading.trailing.top.bottom.equalToSuperview()
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
  }
}
