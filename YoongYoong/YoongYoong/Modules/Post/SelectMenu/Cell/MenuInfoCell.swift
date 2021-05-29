//
//  SelectMenuCell.swift
//  YoongYoong
//
//  Created by 원현식 on 2021/05/03.
//

import UIKit
import RxSwift
import RxCocoa

class MenuInfoCell: UITableViewCell {
  
  static let reuseIdentifier = String(describing: MenuInfoCell.self)
  static let height = CGFloat(154)
  
  private var didDelete: () -> () = {}
  private var menuCountChanged: (Int) -> () = {_ in}
  private var containerCountChanged: (Int) -> () = {_ in}
  private var addMenuDidTap: () -> () = {}
  private var changeContainer: () -> () = {}
  
  // MARK: - Rx
  var menuCount = PublishSubject<Int>()
  var containerCount = PublishSubject<Int>()
  var deleteCell = PublishSubject<Void>()
  var addMenuCell = PublishSubject<Void>()
  var menuText  = PublishSubject<String>()
  var showContainerListView = PublishSubject<Void>()
  
  private var disposeBag = DisposeBag()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
    setupLayout()
    setSeletedColor()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  // MARK: - Setup Cell
  func bind() {
    let changingMenuCount = PublishSubject<Int>()
    menuCountChanged = { changingMenuCount.onNext($0)}
    menuCount = changingMenuCount
    
    let changingContainerCount = PublishSubject<Int>()
    containerCountChanged = { changingContainerCount.onNext($0)}
    containerCount = changingContainerCount
    
    let deletingCell = PublishSubject<Void>()
    didDelete = { deletingCell.onNext(())}
    deleteCell = deletingCell
    
    let adding = PublishSubject<Void>()
    addMenuDidTap = {adding.onNext(())}
    addMenuCell = adding
    
    let menuTextEditingDidEnd = PublishSubject<String>()
    self.menuText = menuTextEditingDidEnd
    menuTextField.rx.controlEvent(.editingDidEnd)
      .map{ self.menuTextField.text! }
      .bind(to: menuTextEditingDidEnd)
      .disposed(by: disposeBag)
      
    
    let changingContainer = PublishSubject<Void>()
    changeContainer = { changingContainer.onNext(()) }
    showContainerListView = changingContainer
  }
  
  func setLastCell() {
    self.addMenuButton.isHidden = false
    self.headerView.isHidden = true
    self.bodyView.isHidden = true
  }
  
  func setCellData(_ data: MenuInfo, _ i: Int) {
    self.addMenuButton.isHidden = true
    self.headerView.isHidden = false
    self.bodyView.isHidden = false
    
    cellTitle.text = "구매 정보\(i)"
    menuCountLabel.text = "\(data.menuCount)"
    containerCountLabel.text = "\(data.containerCount)"
    menuTextField.text = "\(data.menu ?? "")"
    
    
    containerTextField.textColor = data.container == nil ? #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.8039215686, alpha: 1) : .black
    if data.container == nil {
      containerTextField.text  = "용기 종류"
    } else {
      containerTextField.text = "\(data.container!) \(data.containerSize!)"

    }
  }
  
  func setSeletedColor() {
    let backgroundView = UIView()
    backgroundView.backgroundColor = .white
    self.selectedBackgroundView = backgroundView
  }

  
  // MARK: - Actions
  @objc
  private func deleteButtonDidTap() {
    didDelete()
  }
  
  @objc
  private func menuPlusButtonDidTap() {
    menuCountChanged(+1)
  }
  @objc
  private func menuMinusButtonDidTap() {
    menuCountChanged(-1)
  }
  
  @objc
  private func containerPlusButtonDidTap() {
    containerCountChanged(+1)
    
  }
  @objc
  private func containerMinusButtonDidTap() {
    containerCountChanged(-1)
  }
  
  @objc
  private func addMenuButtonDidTap() {
    addMenuDidTap()
  }
  
  @objc
  private func containerTextFieldDidTap(_ sender: UITapGestureRecognizer) {
    changeContainer()
  }
  
  // MARK: - Setup View
  private func setupView() {
    menuTextFieldView.add(menuTextField)
    containerTextFieldView.add(containerTextField)
    menus.adds([menuLabel ,menuTextFieldView ,menuPlusButton ,menuMinusButton ,menuCountLabel])
    containers.adds([containerLabel ,containerTextFieldView ,containerPlusButton ,containerMinusButton ,containerCountLabel])
    
    headerView.adds([cellTitle, deleteCellButton])
    bodyView.adds([menus, containers])
    contentView.adds([headerView ,bodyView, addMenuButton])
  }
  
  private func setupLayout() {
    
    headerView.snp.makeConstraints {
      $0.top.equalTo(contentView)
      $0.centerX.equalTo(contentView.snp.centerX)
      $0.width.equalTo(346)
      $0.height.equalTo(32)
    }
    
    cellTitle.snp.makeConstraints {
      $0.center.equalTo(headerView.snp.center)
    }
    
    deleteCellButton.snp.makeConstraints {
      $0.right.equalTo(headerView.snp.right).offset(-12)
      $0.centerY.equalTo(headerView.snp.centerY)
      $0.width.height.equalTo(20)
    }
    
    bodyView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom)
      $0.centerX.equalTo(contentView.snp.centerX)
      $0.width.equalTo(346)
      $0.height.equalTo(105)
    }
    
    // Menu
    menus.snp.makeConstraints {
      $0.left.equalTo(bodyView.snp.left).offset(19)
      $0.top.equalTo(bodyView.snp.top).offset(16)
      $0.width.equalTo(315)
      $0.height.equalTo(30)
    }
    
    menuLabel.snp.makeConstraints {
      $0.width.height.equalTo(menus.snp.height)
      $0.left.top.equalTo(menus)
    }
    
    menuTextFieldView.snp.makeConstraints {
      $0.left.equalTo(menuLabel.snp.right).offset(8)
      $0.top.equalTo(menus)
      $0.width.equalTo(186)
      $0.height.equalTo(30)
    }
    
    menuTextField.snp.makeConstraints {
      $0.left.equalTo(menuTextFieldView).offset(12)
      $0.top.equalTo(menuTextFieldView).offset(4)
      $0.bottom.equalTo(menuTextFieldView).offset(-4)
      $0.right.equalTo(menuTextFieldView).offset(-4)
    }
    
    menuMinusButton.snp.makeConstraints {
      $0.width.height.equalTo(menus.snp.height)
      $0.top.equalTo(menus)
      $0.left.equalTo(menuTextFieldView.snp.right).offset(12)
    }
    
    menuCountLabel.snp.makeConstraints {
      $0.left.equalTo(menuMinusButton.snp.right)
      $0.right.equalTo(menuPlusButton.snp.left)
      $0.centerY.equalTo(menus)
    }
    
    menuPlusButton.snp.makeConstraints {
      $0.width.height.equalTo(menus.snp.height)
      $0.top.equalTo(menus)
      $0.right.equalTo(menus.snp.right)
    }
    
    // Container
    containers.snp.makeConstraints {
      $0.left.equalTo(bodyView.snp.left).offset(19)
      $0.top.equalTo(menus.snp.bottom).offset(13)
      $0.width.equalTo(315)
      $0.height.equalTo(30)
    }
    
    containerLabel.snp.makeConstraints {
      $0.width.height.equalTo(containers.snp.height)
      $0.left.top.equalTo(containers)
    }
    
    containerTextFieldView.snp.makeConstraints {
      $0.left.equalTo(containerLabel.snp.right).offset(8)
      $0.top.equalTo(containers)
      $0.width.equalTo(186)
      $0.height.equalTo(30)
    }
    
    containerTextField.snp.makeConstraints {
      $0.left.equalTo(containerTextFieldView).offset(12)
      $0.top.equalTo(containerTextFieldView).offset(4)
      $0.bottom.equalTo(containerTextFieldView).offset(-4)
      $0.right.equalTo(containerTextFieldView).offset(-4)
    }
    
    containerMinusButton.snp.makeConstraints {
      $0.width.height.equalTo(containers.snp.height)
      $0.top.equalTo(containers)
      $0.left.equalTo(containerTextFieldView.snp.right).offset(12)
    }
    
    containerCountLabel.snp.makeConstraints {
      $0.left.equalTo(containerMinusButton.snp.right)
      $0.right.equalTo(containerPlusButton.snp.left)
      $0.centerY.equalTo(containers)
    }
    
    containerPlusButton.snp.makeConstraints {
      $0.width.height.equalTo(containers.snp.height)
      $0.top.equalTo(containers)
      $0.right.equalTo(containers.snp.right)
    }
    
    addMenuButton.snp.makeConstraints {
      $0.width.equalTo(66)
      $0.height.equalTo(18)
      $0.top.equalTo(contentView.snp.top)
      $0.left.equalTo(contentView.snp.left).offset(26)
    }
    
  }
  
  private func configuration() {}

  
  // MARK: - Views
  
  // - UIView
  private let headerView = UIView().then {
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    $0.backgroundColor = UIColor.brandColorGreen02
    $0.layer.cornerRadius = 20
    $0.layer.applySketchShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05), x: 0, y: 6, blur: 20, spread: 0)
  }
  private let bodyView = UIView().then {
    $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    $0.backgroundColor = UIColor.brandColorGreen03
    $0.layer.cornerRadius = 20
    $0.layer.applySketchShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12), x: 0, y: 2, blur: 10, spread: 0)
  }
  private let menus = UIView()
  private let containers = UIView()
  
  private let containerTextFieldView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.brandColorGreen02.cgColor
    $0.layer.cornerRadius = 8
  }
  
  private let menuTextFieldView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.brandColorGreen02.cgColor
    $0.layer.cornerRadius = 8
  }
  
  // UILabel
  private let menuCountLabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = .krBody2
    $0.text = "1"
  }
  
  private let containerLabel = UILabel().then {
    $0.font = .krTitle2
    $0.text = "용기"
    $0.textColor = UIColor.brandColorGreen01
  }
  
  
  private let cellTitle = UILabel().then {
    $0.font = .krTitle3
    $0.textAlignment = .center
    $0.text = "구매 정보"
  }
  
  private let menuLabel = UILabel().then {
    $0.font = .krTitle2
    $0.text = "메뉴"
    $0.textColor = UIColor.brandColorGreen01
  }
  
  private let containerCountLabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = .krBody2
    $0.text = "1"
  }
  
  
  // UIButton
  private lazy var deleteCellButton = UIButton().then {
    $0.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
    $0.setImage(UIImage(named: "closeButtonGreen"), for: .normal)
  }
  
  private lazy var menuPlusButton = UIButton().then {
    $0.setImage(UIImage(named: "plus.circle.blue"), for: .normal)
    $0.addTarget(self, action: #selector(menuPlusButtonDidTap), for: .touchUpInside)
    
  }
  private lazy var menuMinusButton = UIButton().then {
    $0.setImage(UIImage(named: "minus.circle.blue"), for: .normal)
    $0.addTarget(self, action: #selector(menuMinusButtonDidTap), for: .touchUpInside)
  }
  
  private lazy var containerPlusButton = UIButton().then {
    $0.setImage(UIImage(named: "plus.circle.blue"), for: .normal)
    $0.addTarget(self, action: #selector(containerPlusButtonDidTap), for: .touchUpInside)
    
  }
  private lazy var containerMinusButton = UIButton().then {
    $0.setImage(UIImage(named: "minus.circle.blue"), for: .normal)
    $0.addTarget(self, action: #selector(containerMinusButtonDidTap), for: .touchUpInside)
  }
  
  private lazy var addMenuButton = UIButton().then {
    $0.setTitle("메뉴 추가하기", for: .normal)
    $0.addUnderBar(.brandColorGreen01)
    $0.titleLabel?.font = .krTitle3
    $0.setTitleColor(UIColor.brandColorGreen01, for: .normal)
    $0.isHidden = true
    $0.addTarget(self, action: #selector(addMenuButtonDidTap), for: .touchUpInside)
  }
  
  // UITextField
  private let menuTextField = UITextField().then {
    $0.placeholder = "메뉴명"
    $0.borderStyle = .none
    $0.font = .krBody2
    $0.backgroundColor = .white
  }
  
  
  private lazy var containerTextField = UILabel().then {
    $0.text = "용기 종류"
    $0.font = .krBody2
    $0.backgroundColor = .white
    $0.textColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.8039215686, alpha: 1)
    $0.isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerTextFieldDidTap(_:)))
    $0.addGestureRecognizer(tapGesture)
  }
  
}
