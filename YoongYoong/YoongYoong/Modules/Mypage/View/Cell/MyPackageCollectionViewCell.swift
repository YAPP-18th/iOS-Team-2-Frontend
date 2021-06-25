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
class MyPackageCollectionViewCell: UICollectionViewCell {
  private let tableView = UITableView()
  private let flowlayout = UICollectionViewFlowLayout().then {
    $0.scrollDirection = .horizontal
  }
  private lazy var containerListTabBar = UICollectionView(frame: .zero, collectionViewLayout: flowlayout).then {
    $0.register(ContainerListTabBarCell.self, forCellWithReuseIdentifier: ContainerListTabBarCell.reuseIdentifier)
    $0.collectionViewLayout = flowlayout
    $0.backgroundColor = .white
    $0.showsHorizontalScrollIndicator = false
//    $0.delegate = self
//    $0.dataSource = self
    $0.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
  }
  let disposeBag = DisposeBag()
  lazy var dataSource = DataSource<ContainerSection> (
    configureCell: configureCell
  )
  private var currentTopSection = 0
  private var flag = false
  var favorateTrigger = PublishSubject<ContainerCellModel>()
  override init(frame: CGRect) {
    super.init(frame: frame)
    layout()

  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
extension MyPackageCollectionViewCell: UITableViewDelegate {
  func setupTableView() {
    tableView.rowHeight = 40
    tableView.sectionHeaderHeight = 32
    tableView.separatorStyle = .none
    tableView.register(MyPackageTableViewCell.self,
                       forCellReuseIdentifier: MyPackageTableViewCell.identifier)
    tableView.register(ContainerListHeaderView.self,
                       forHeaderFooterViewReuseIdentifier: ContainerListHeaderView.reuseIdentifier)
    tableView.delegate = nil
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ContainerListHeaderView.reuseIdentifier) as? ContainerListHeaderView else { return UIView()}
    header.imageView.image = Container.sectionImage(section)
    header.title.text = Container.sectionTitle(section)
    return header
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 32
  }
  func bindCell(model : [ContainerSection]) {
    
    Observable.just(model)
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
//    tableView.rx
//        .observeWeakly(CGSize.self, "contentSize")
//        .compactMap { $0?.height }
//        .distinctUntilChanged()
//        .bind { [weak self] height in
//          self?.tableView.snp.updateConstraints{
//            $0.height.equalTo((height + 1).rounded())
//          }
//        }
//        .disposed(by: disposeBag)
  }
}
extension MyPackageCollectionViewCell {
  private var configureCell: DataSource<ContainerSection>.ConfigureCell {
    return {[weak self] ds, tableView, indexPath, item -> UITableViewCell in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPackageTableViewCell.identifier) as? MyPackageTableViewCell else {
        return UITableViewCell()
      }
      cell.bind(model: item)
      cell.favorateBtn.rx.tap.takeUntil(cell.rx.methodInvoked(#selector(UITableViewCell.prepareForReuse)))
        .bind{[weak self] in
          self?.favorateTrigger.onNext(item)
          cell.favorateBtn.isSelected.toggle()
        }.disposed(by: cell.disposeBag)
      return cell
    }
  }
  
  private func layout() {
    self.contentView.backgroundColor = #colorLiteral(red: 0.92900002, green: 0.92900002, blue: 0.92900002, alpha: 1)
    self.contentView.add(tableView)
    self.contentView.add(containerListTabBar)
    tableView.snp.makeConstraints{
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalToSuperview().offset(48)
    }
    containerListTabBar.snp.makeConstraints{
      $0.leading.trailing.top.equalToSuperview()
      $0.bottom.equalTo(tableView.snp.top)
    }
  }
}
extension MyPackageCollectionViewCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    containerListTabBar.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    tableView.scrollToRow(at: IndexPath(row: 0, section: indexPath.row), at: .top, animated: true)
    currentTopSection = indexPath.row
    flag = false
  }
}

extension MyPackageCollectionViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return Container.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContainerListTabBarCell.reuseIdentifier, for: indexPath) as? ContainerListTabBarCell else {
      return UICollectionViewCell()
    }
    cell.setTitle(Container.sectionTitle(indexPath.row))
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return CGFloat(0.0)

  }
}

extension MyPackageCollectionViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return ContainerListTabBarCell.cellSize(availableHeight: 50, title: Container.sectionTitle(indexPath.row))

  }
}
