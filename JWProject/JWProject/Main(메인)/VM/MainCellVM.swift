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
    let uuid = UUID().uuidString
    
    // 제목
    let title = ""
    let titleFont = UIFont(name: APP_FONT, size: CGFloat(FONT_TITLE))
    
    // 내용
    let content = ""
    let contentFont = UIFont(name: APP_FONT, size: CGFloat(FONT_CONTENT))
    
    // 초기값
    init(title:String, content:String) {
        
    }
}
