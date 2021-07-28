//
//  AppVariables.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/17.
//  Copyright © 2021 YoongYoong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

let globalUser = BehaviorRelay<UserInfo>(value: UserInfo(email: "", id: 0, imageUrl: "", introduction: "", nickname: ""))
