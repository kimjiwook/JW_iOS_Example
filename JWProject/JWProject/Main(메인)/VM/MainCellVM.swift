//
//  MainCellVM.swift
//  JWProject
//
//  Created by JW_Macbook on 2021/04/12.
//
/*
 메인화면 CollectionView Cell 구성하는 ViewModel
 */

import UIKit

struct MainCellVM {
    // 객체 ID
    var uuid:MainMenuId = .none
    
    // 제목
    var title = ""
    let titleFont = UIFont(name: APP_FONT, size: CGFloat(FONT_TITLE))
    let titleColor:UIColor = .black
    
    // 내용
    var content = ""
    let contentFont = UIFont(name: APP_FONT, size: CGFloat(FONT_CONTENT))
    let contentColor:UIColor = .lightGray
    
    // 상세 이동하는 부분
    var detailVC:UIViewController?
    
    // 초기값
    init(uuid:MainMenuId, title:String, content:String) {
        self.uuid = uuid
        self.title = title
        self.content = content
    }
}


enum MainMenuId {
    case none // 디폴트
    
    /// UIMenu
    case UIMenu
    
    /// SPM Sample ViewController
    case SPMSampleVC
    
    /// Apple - SFSymbols
    case SFSSymbols_Apple
}
