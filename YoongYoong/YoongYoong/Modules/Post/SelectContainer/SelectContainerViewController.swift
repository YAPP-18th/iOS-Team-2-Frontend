//
//  SelectContainerViewController.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/04.
//

import UIKit
import RxSwift
import RxCocoa


let sections = ["자주 쓰는 용기", "밀폐용기", "냄비", "텀블러", "보온 도시락", "프라이팬"]

class SelectContainerViewController: ViewController {
  
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
    $0.delegate?.collectionView?($0, didSelectItemAt: IndexPath(row: 0, section: 0))
    $0.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
  }
  private let indicator = UIView().then { $0.backgroundColor = .black }
  private let tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func bindViewModel() {
    super.bindViewModel()
  }
  
  override func setupView() {
    super.setupView()
    view.adds([containerListTabBar, tableView, indicator])
  }
  
  override func setupLayout() {
    super.setupLayout()
    
    containerListTabBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.left.right.equalTo(view)
      $0.height.equalTo(50)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(containerListTabBar.snp.bottom).offset(8)
      $0.left.right.bottom.equalTo(view)
    }
  
    indicator.snp.makeConstraints {
      $0.width.equalTo(25)
      $0.bottom.equalTo(containerListTabBar.snp.bottom)
      $0.height.equalTo(2)
      $0.centerX.equalTo(60)
    }
    
  }
  
  override func configuration() {
    super.configuration()
    view.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9176470588, alpha: 1)
    tableView.do {
      $0.register(ContainerListItemCell.self, forCellReuseIdentifier: ContainerListItemCell.reuseIdentifier)
      $0.register(ContainerListHeaderView.self, forHeaderFooterViewReuseIdentifier: ContainerListHeaderView.reuseIdentifier)
      $0.separatorStyle = .none
      $0.rowHeight = ContainerListItemCell.cellHeight
      $0.delegate = self
      $0.dataSource = self
    }
    
  }
  var flag = false

}

// MARK: - TableView
extension SelectContainerViewController: UITableViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    flag = true
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let indexPaths = tableView.indexPathsForVisibleRows else { return }
    guard let topSection = indexPaths.min(), let cell = containerListTabBar.cellForItem(at: IndexPath(row: topSection.section, section: 0)) as? ContainerListTabBarCell else { return }

    if flag {
      containerListTabBar.selectItem(at: IndexPath(row: topSection.section, section: 0), animated: true, scrollPosition: .centeredHorizontally)
      self.animateIndicator(cell, IndexPath(row: topSection.section, section: 0))
    }

  }
  
  func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
      guard let indexPaths = tableView.indexPathsForVisibleRows else { return }
      guard let topSection = indexPaths.min(), let cell = containerListTabBar.cellForItem(at: IndexPath(row: topSection.section, section: 0)) as? ContainerListTabBarCell else { return }

      if flag {
        containerListTabBar.selectItem(at: IndexPath(row: topSection.section, section: 0), animated: true, scrollPosition: .centeredHorizontally)
      
        self.animateIndicator(cell, IndexPath(row: topSection.section, section: 0))
      }

  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ContainerListHeaderView.reuseIdentifier) as? ContainerListHeaderView else { return UIView()}
    header.imageView.image = #imageLiteral(resourceName: "star.green")
    header.title.text = sections[section]
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat(32)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
  }
}

extension SelectContainerViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 9
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ContainerListItemCell.reuseIdentifier) as? ContainerListItemCell else {
      return UITableViewCell()
    }
    cell.favoriteDidTap = {
      
    }
    return cell
  }
}

// MARK: - CollectionView
extension SelectContainerViewController: UICollectionViewDelegate {
  private func animateIndicator(_ cell: ContainerListTabBarCell, _ indexPath: IndexPath) {
    indicator.snp.removeConstraints()
    indicator.snp.makeConstraints {
      $0.centerX.equalTo(cell)
      $0.width.equalTo(25)
      $0.bottom.equalTo(containerListTabBar.snp.bottom)
      $0.height.equalTo(2)
    }
    UIView.animate(withDuration: 0.3, animations: view.layoutIfNeeded )
    containerListTabBar.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? ContainerListTabBarCell else { return }
    flag = false
    animateIndicator(cell, indexPath)
    tableView.scrollToRow(at: IndexPath(row: 0, section: indexPath.row), at: .top, animated: true)
  }
  
}

extension SelectContainerViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 6
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContainerListTabBarCell.reuseIdentifier, for: indexPath) as? ContainerListTabBarCell else {
      return UICollectionViewCell()
    }
    cell.setTitle(sections[indexPath.row])
    return cell
  }
  
}

extension SelectContainerViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return ContainerListTabBarCell.cellSize(availableHeight: 40, title: sections[indexPath.row])
  }
}
