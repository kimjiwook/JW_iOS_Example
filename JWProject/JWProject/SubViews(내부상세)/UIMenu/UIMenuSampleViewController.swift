//
//  UIMenuSampleViewController.swift
//  JWProject
//
//  Created by JW_Macbook on 2021/04/13.
//
/*
 UIMenu 관련 샘플 ViewController
 */

import UIKit
import JWLibrary

class UIMenuSampleViewController: UIViewController {

    // UI 관련
    var mainStackView:UIStackView? // 메인 스택뷰
    var firstBtn:UIButton? // 샘플용 버튼
    
    // 내부, 외부 변수 관련
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDzViews()
    }
}

extension UIMenuSampleViewController: JWViewProtocol {
    func initDzViews() {
        self.view.backgroundColor = .white
        
        // #. 스택뷰 관련
        if nil == mainStackView {
            mainStackView = UIStackView()
            mainStackView?.alignment = .fill
            mainStackView?.axis = .vertical
            
            self.view.addSubview(mainStackView!)
        }
        
        // 1. 버튼 관련
        if nil == firstBtn {
            firstBtn = UIButton(type: .system)
            firstBtn?.setTitle("UIMenu 버튼(기본)", for: .normal)
            firstBtn?.addAction(UIAction(handler: { (action) in
                print("UIMenu 버튼 클릭됨.")
            }), for: .touchUpInside)
            
            // 버튼의 기본 메뉴 넣어보기
            
            let action1 = UIAction(title: "액션?!", image: UIImage(systemName: "scribble")) { (action) in
                print("액션 클릭시 발생함 action1")
            }
            
            firstBtn?.menu = UIMenu(title: "UIMenu 제목부분",
                                    image: nil,
                                    identifier: nil,
                                    options: .displayInline,
                                    children: [action1])
            
            mainStackView?.addArrangedSubview(firstBtn!)
        }
        
        
        // 오토레이아웃
        self.updateDzViews()
        
        // 네비게이션
        self.setDzNavigationViews()
    }
    
    func updateDzViews() {
        self.mainStackView?.snp.remakeConstraints({ (make) in
            make.leading.trailing.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        })
    }
    
    func setDzNavigationViews() {
        // 네비게이션 아래에서 부터 진행
        self.navigationController?.navigationBar.isTranslucent = true
        self.title = "UIMenu"
    }
    
    func doDzBackAction() {
        
    }
    
    
}
