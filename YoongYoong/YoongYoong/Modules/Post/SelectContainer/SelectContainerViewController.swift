//
//  SelectContainerViewController.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class SelectContainerViewController: ViewController {
  
  let topIndicatorView = UIView().then {
    $0.backgroundColor = .systemGray05
    $0.layer.cornerRadius = 2.5
    $0.layer.masksToBounds = true
  }
  
  private let layout = UICollectionViewFlowLayout().then {
    $0.scrollDirection = .horizontal
  }
  private lazy var containerListTabBar = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
    $0.register(ContainerListTabBarCell.self, forCellWithReuseIdentifier: ContainerListTabBarCell.reuseIdentifier)
    $0.collectionViewLayout = layout
    $0.backgroundColor = .white
    $0.showsHorizontalScrollIndicator = false
    $0.delegate = self
    $0.dataSource = self
    $0.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
  }
  private let indicator = UIView().then { $0.backgroundColor = .black }
  private let tableView = UITableView()
  private let grayLine = UIView().then {
    $0.backgroundColor = .systemGray05
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    
    guard let viewModel = viewModel as? SelectContainerViewModel else { return }
    
    
    let input = SelectContainerViewModel.Input(favoriteDidTap: PublishSubject<IndexPath>(), itemSelected: tableView.rx.itemSelected.asObservable())
    
    let output = viewModel.transform(input: input)
    
    let datasource = RxTableViewSectionedReloadDataSource<ContainerSection>(configureCell: { datasource, tv, indexPath, item in
      guard let cell = tv.dequeueReusableCell(withIdentifier: ContainerListItemCell.reuseIdentifier, for: indexPath) as? ContainerListItemCell else { return UITableViewCell()}
      
      cell.configureCell(item)
      cell.bind()
      cell.isFavoirite
        .map { indexPath }
        .bind(to: input.favoriteDidTap)
        .disposed(by: self.disposeBag)
      
      return cell
    })
    
    output.containers
      .bind(to: tableView.rx.items(dataSource: datasource))
      .disposed(by: disposeBag)
    
    output.dismiss
      .subscribe(onNext: { [weak self] in
        self?.dismiss(animated: true, completion: nil)
      }).disposed(by: disposeBag)
    
  }
  
  override func setupView() {
    super.setupView()
    view.adds([topIndicatorView,containerListTabBar, grayLine, tableView, indicator])
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    topIndicatorView.snp.makeConstraints {
      $0.width.equalTo(58)
      $0.height.equalTo(5)
      $0.centerX.equalTo(view)
      $0.top.equalTo(view).offset(14)
    }
    
    containerListTabBar.snp.makeConstraints {
      $0.top.equalTo(topIndicatorView.snp.bottom).offset(30)
      $0.left.right.equalTo(view)
      $0.height.equalTo(50)
    }
    
    grayLine.snp.makeConstraints {
      $0.top.equalTo(containerListTabBar.snp.bottom)
      $0.left.right.equalTo(view)
      $0.height.equalTo(8)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(grayLine.snp.bottom)
      $0.left.right.bottom.equalTo(view)
    }

    
  }
  
  override func configuration() {
    super.configuration()
    view.backgroundColor = .white
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    view.layer.cornerRadius = 15
    
    tableView.do {
      $0.register(ContainerListItemCell.self, forCellReuseIdentifier: ContainerListItemCell.reuseIdentifier)
      $0.register(ContainerListHeaderView.self, forHeaderFooterViewReuseIdentifier: ContainerListHeaderView.reuseIdentifier)
      $0.separatorStyle = .none
      $0.rowHeight = ContainerListItemCell.cellHeight
    }
    
   tableView.rx.setDelegate(self).disposed(by: disposeBag)
    
  }
  
  private var currentTopSection = 0
  private var flag = false

}

// MARK: - TableView
extension SelectContainerViewController: UITableViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    if scrollView is UITableView {
      flag = true
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if flag == true {
      guard let indexPaths = tableView.indexPathsForVisibleRows, let topSection = indexPaths.map({$0.section}).min(), currentTopSection != topSection else { return }

      currentTopSection = topSection
      containerListTabBar.selectItem(at: IndexPath(row: topSection, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
  }
 
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ContainerListHeaderView.reuseIdentifier) as? ContainerListHeaderView else { return UIView()}
    header.imageView.image = Container.sectionImage(section)
    header.title.text = Container.sectionTitle(section)
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat(32)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
  }
}

// MARK: - CollectionView
extension SelectContainerViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    containerListTabBar.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    tableView.scrollToRow(at: IndexPath(row: 0, section: indexPath.row), at: .top, animated: true)
    currentTopSection = indexPath.row
    flag = false
  }
}

extension SelectContainerViewController: UICollectionViewDataSource {
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

extension SelectContainerViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return ContainerListTabBarCell.cellSize(availableHeight: 50, title: Container.sectionTitle(indexPath.row))

  }
}
