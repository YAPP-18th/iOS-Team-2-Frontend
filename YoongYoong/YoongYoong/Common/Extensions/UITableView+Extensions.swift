//
//  UITableView+Extensions.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/12.
//  Copyright © 2021 YoongYoong. All rights reserved.
//

import UIKit

extension UITableView {
  func reloadDataAndKeepOffset() {
    let beforcContentOffset = contentOffset
    reloadData()
    layoutIfNeeded()
    setContentOffset(beforcContentOffset, animated: true)
  }
}
