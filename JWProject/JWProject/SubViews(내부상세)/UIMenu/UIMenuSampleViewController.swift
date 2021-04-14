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
    // 샘플용 버튼
    var defaultLb:UILabel?
    var defaultBtn:UIButton?
    var lineLb:UILabel?
    var lineBtn:UIButton?
    
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
            mainStackView?.spacing = 8
            
            self.view.addSubview(mainStackView!)
        }
        // 시스템 아이콘 이름들
        // https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/system-icons/
        
        // 설명 1
        if nil == defaultLb {
            defaultLb = UILabel()
            defaultLb?.numberOfLines = 0
            defaultLb?.textColor = .black
            defaultLb?.textAlignment = .center
            defaultLb?.text = "1. UIMenu 기본적으로 롱클릭(트랙패드 우클릭)형식으로 실행가능"
            self.mainStackView?.addArrangedSubview(defaultLb!)
        }
        
        // 1. 버튼 관련
        if nil == defaultBtn {
            defaultBtn = UIButton(type: .system)
            defaultBtn?.setTitle("UIMenu 버튼(기본)", for: .normal)
            defaultBtn?.addAction(UIAction(handler: { (action) in
                print("UIMenu 버튼 클릭됨.")
            }), for: .touchUpInside)
            
            // 버튼의 기본 메뉴 넣어보기
            
            let action1 = UIAction(title: "액션?!", image: UIImage(systemName: "scribble")) { (action) in
                print("액션 클릭시 발생함 action1")
            }
            
            defaultBtn?.menu = UIMenu(title: "UIMenu 제목부분",
                                    image: nil,
                                    identifier: nil,
                                    options: .displayInline,
                                    children: [action1])
            
            mainStackView?.addArrangedSubview(defaultBtn!)
        }
        
        
        if nil == lineLb {
            lineLb = UILabel()
            lineLb?.numberOfLines = 0
            lineLb?.textColor = .black
            lineLb?.textAlignment = .center
            lineLb?.text = """
2. UIMenu 내 UIMenu, UIAction 으로 구성이 가능함
메뉴 > 메뉴 선택적으로 띄울수 있음.
체크박스 형식도 사용가능! (Flag 관리는 직접해줘야함)
"""
            self.mainStackView?.addArrangedSubview(lineLb!)
        }
        
        // 조금더 응용하기
        if nil == lineBtn {
            lineBtn = UIButton(type: .system)
            lineBtn?.setTitle("응용1 버튼", for: .normal)
            
            // 액션 부분
            let action1 = UIAction(title: "편집", image: UIImage(systemName: "square.and.pencil")) { (action) in
                print("액션 클릭시 발생함 [편집]")
            }
            let action2 = UIAction(title: "저장", image: UIImage(systemName: "tray.and.arrow.down")) { (action) in
                print("액션 클릭시 발생함 [저장]")
            }
            
            // 메뉴 추가
            let inAction1 = UIAction(title: "폴더생성", image: UIImage(systemName: "folder.badge.plus")) { (action) in
                print("액션 클릭시 발생함 [폴더생성]")
            }
            let inAction2 = UIAction(title: "공유", image: UIImage(systemName: "square.and.arrow.up")) { (action) in
                print("액션 클릭시 발생함 [저장]")
            }
            
            let menu1 = UIMenu(title: "in메뉴", image: nil, identifier: nil, options: .displayInline, children: [inAction1, inAction2])
            
            // 체크 박스
            let check1 = UIAction(title: "즐겨찾기", image: UIImage(systemName: "star"), state: .on) { (action) in
                print("체크 박스 선택1")
            }
            
            let check2 = UIAction(title: "누구지", image: UIImage(systemName: "person.fill.questionmark"), state: .off) { (action) in
                print("체크 박스 선택2")
            }
            
            let menu2 = UIMenu(title: "내부메뉴", image: nil, identifier: nil, options: .destructive, children: [check2, check1, action2, action1])
            
            // 순서도 있구나
            lineBtn?.menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [menu2, menu1, action2, action1])
            lineBtn?.showsMenuAsPrimaryAction = true // 버튼클릭시 UIMenu 발생함
            
            mainStackView?.addArrangedSubview(lineBtn!)
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
