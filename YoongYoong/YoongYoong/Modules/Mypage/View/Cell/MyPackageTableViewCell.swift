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
  private let sizeLabel = UILabel()
  private let favorateBtn = UIButton()
  private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
