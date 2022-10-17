//
//  CustomPhotoViewController.swift
//  JWProject
//
//  Created by JWMacBook on 2022/10/07.
//

import UIKit
import JWLibrary
import SwiftUI

class CustomPhotoViewController: UIViewController {
    // UI 관련
    var mainStackView:UIStackView? // 메인 스택뷰
    
    class func instance() -> CustomPhotoViewController {
        let desc = CustomPhotoViewController()
        return desc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDzViews()
    }
}

extension CustomPhotoViewController: JWViewProtocol {
    func initDzViews() {
        self.view.backgroundColor = .white
                
        // SwiftUI
        let host = UIHostingController(rootView: CustomPhotoPickView())
        self.addChild(host)
        self.view.addSubview(host.view)
        //mainStackView?.addArrangedSubview(host.view)
        host.didMove(toParent: self)
        host.view.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        updateDzViews()
    }
    
    func updateDzViews() {
        
    }
    
    func setDzNavigationViews() {
        
    }
    
    func doDzBackAction() {
        
    }
    
    
}
