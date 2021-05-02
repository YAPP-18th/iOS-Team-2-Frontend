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
    private let disposeBag = DisposeBag()
  private let monthlyInformationView = UIView().then{
    $0.backgroundColor = .brandColorBlue03
  }
  private let timeStampLabel = UILabel().then{
    $0.font = .sdGhothicNeo(ofSize: 12, weight: .bold)
    $0.textAlignment = .center
    $0.textColor = .black
  }
  private let postCount = UILabel().then{
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .bold)
  }
  private let packageCount = UILabel().then{
    $0.font = .sdGhothicNeo(ofSize: 14, weight: .bold)
  }
  let nextMonthBtn = UIButton()
  let lastMonthBtn = UIButton()
}
