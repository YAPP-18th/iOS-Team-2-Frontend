//
//  CheckTermsViewController.swift
//  YoongYoong
//
//  Created by 김태훈 on 2021/05/15.
//

import Foundation
import UIKit
import RxSwift
class CheckTermViewController : ViewController{
    private var terms : [TermView] = [TermView().then { $0.termTitle.text = "서비스 이용 약관"
        $0.detailBtn.tag = 0
    },
    TermView().then { $0.termTitle.text = "개인정보 처리방침"
        $0.detailBtn.tag = 1
    },
    TermView().then { $0.termTitle.text = "위치 기반 서비스"
        $0.detailBtn.tag = 2
    },
    TermView().then { $0.termTitle.text = "마케팅 정보 수신 동의"
        $0.detailBtn.tag = 3
    }]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSimpleNavigationItem(title: "약관 및 정책")
        
    }
    override func setupLayout() {
        self.view.adds(terms)
        self.view.backgroundColor = .white
        for term in terms {
            term.snp.makeConstraints{
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(38)
            }
        }
        terms[0].snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(4)
        }
        for i in 1..<terms.count {
            terms[i].snp.makeConstraints{
                $0.top.equalTo(terms[i - 1].snp.bottom).offset(4)
            }
        }
    }
    func setupNavigationItem() {
        let leftButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "icBtnBack.png"),
            style: .plain,
            target: self,
            action: #selector(popViewController)
        )
        let titleLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "약관 및 정책"
            $0.font = .sdGhothicNeo(ofSize: 14, weight: .bold)
            return $0
        }(UILabel(frame: .zero))
        
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.titleView = titleLabel
    }
    @objc
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}

class TermView :UIView {
    var termTitle = UILabel().then {
        $0.font = .sdGhothicNeo(ofSize: 14, weight: .regular)
        $0.textColor = .black
    }
    var detailBtn = UIButton().then {
        let attrString = NSAttributedString(
            string: "자세히",
            attributes: [
                NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
            ])
        $0.setAttributedTitle(attrString, for: .normal)
        $0.titleLabel?.font = .sdGhothicNeo(ofSize: 14, weight: .regular)
        $0.setTitleColor(#colorLiteral(red: 0.5569999814, green: 0.5569999814, blue: 0.5759999752, alpha: 1), for: .normal)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func layout() {
        self.adds([termTitle, detailBtn])
        termTitle.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        detailBtn.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-31)
        }
        detailBtn.addTarget(self, action: #selector(checkTerm), for: .touchUpInside)
    }
    @objc
    func checkTerm(sender:UIButton) {
        if let topVC = UIApplication.shared.topViewController() as? CheckTermViewController {
            let vc = TermViewControlelr(viewModel: nil, navigator: topVC.navigator)
            vc.tag = sender.tag
            topVC.navigationController?.pushViewController(vc, animated: true)
        }
        print(sender.tag)
        
    }
}
