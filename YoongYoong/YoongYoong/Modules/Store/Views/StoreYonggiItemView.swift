//
//  StoreYonggiItemView.swift
//  YoongYoong
//
//  Created by 손병근 on 2021/07/02.
//

import UIKit

class StoreYonggiItemView: UIView {
    
    enum Container: String {
        case 밀폐용기
        case 텀블러
        case 도시락
        case 냄비
        case 프라이팬
        case 없음
        
        var image: UIImage? {
            switch self {
            case .밀폐용기:
                return UIImage(named: "icContainer001")
            case .텀블러:
                return UIImage(named: "icContainer002")
            case .도시락:
                return UIImage(named: "icContainer003")
            case .냄비:
                return UIImage(named: "icContainer004")
            case .프라이팬:
                return UIImage(named: "icContainer005")
            case .없음:
                return UIImage(named: "icContainerEmpty")
            }
        }
    }
  struct ViewModel {
    let container: Container
    let size: String
  }
  
  var viewModel: ViewModel? {
    didSet {
      self.updateView()
    }
  }
  
  let iconImageView = UIImageView()
  
  let titleLabel = UILabel().then {
    $0.font = .krCaption2
    $0.textColor = .brandColorGreen01
  }
  
  // MARK: Object lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Setup
  
  private func setup() {
    configuration()
    setupView()
    setupLayout()
  }
}

extension StoreYonggiItemView {
  private func configuration() {
    
  }
  
  private func setupView() {
    [iconImageView, titleLabel].forEach {
      addSubview($0)
    }
  }
  
  private func setupLayout() {
    iconImageView.snp.makeConstraints {
      $0.top.equalTo(14)
      $0.width.height.equalTo(55)
      $0.centerX.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(iconImageView.snp.bottom).offset(2)
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(-16)
    }
  }
  
  private func updateView() {
    guard let vm = self.viewModel else { return }
    self.iconImageView.image = vm.container.image
    self.titleLabel.text = vm.container == .없음 ? "" : vm.container.rawValue + " \(vm.size)"
    
  }
}
