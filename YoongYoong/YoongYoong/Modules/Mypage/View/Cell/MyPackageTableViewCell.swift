//
//  MyPackageTableViewCell.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/02.
//

import UIKit
import RxSwift
import RxCocoa
class MyPackageTableViewCell: UITableViewCell {
  private let titleLabel = UILabel()
    .then{
      $0.font = .sdGhothicNeo(ofSize: 12, weight: .regular)
      $0.textColor = .black
    }
  private let sizeLabel = UILabel().then {
    $0.font = .sfProText(ofSize: 14, weight: .regular)
    $0.textColor = .systemGray
  }
  let favorateBtn = UIButton().then{
    $0.setImage(UIImage(named: "packageSelected"), for: .selected)
    $0.setImage(UIImage(named: "packageNotSelected"), for: .normal)
  }
  
  let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  func bind(model: PackageSimpleModel) {
    self.selectionStyle = .none
    layout()
    self.titleLabel.text = model.title
    self.sizeLabel.text = model.size
    self.favorateBtn.isSelected = model.selected
  }
  func bind(model: ContainerCellModel) {
    self.selectionStyle = .none
    layout()
    self.titleLabel.text = model.title
    self.sizeLabel.text = model.size
    self.favorateBtn.isSelected = model.selected
  }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  private func layout() {
    self.contentView.adds([titleLabel, sizeLabel, favorateBtn])
    titleLabel.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(32)
      $0.top.equalToSuperview().offset(12)
    }
    favorateBtn.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(16)
      $0.trailing.equalToSuperview().offset(-31)
      $0.top.equalToSuperview().offset(12)
    }
    sizeLabel.snp.makeConstraints{
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
      $0.trailing.equalTo(favorateBtn.snp.leading).offset(-8)
      $0.width.equalTo(80)
    }
  }
}
