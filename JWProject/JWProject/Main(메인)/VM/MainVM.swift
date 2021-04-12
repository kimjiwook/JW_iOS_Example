//
//  MainVM.swift
//  JWProject
//
//  Created by JW_Macbook on 2021/04/12.
//
/*
 메인화면 구성하는 ViewModel
 */

import UIKit

struct MainVM {
    // Cell 구성 요소
    var itmes:[MainCellVM] = MainVM.getItems()
    
    // 초기값
    init() {
        
    }
    
    /// Cell Item 꾸며준 내용
    /// 고정 형식이다 보니 네트워크 통신 없는 형식입니다.
    /// - Returns: [MainCellVM]
    class func getItems() -> [MainCellVM] {
        var result = [MainCellVM]()
        
        MainCellVM
        
        
        return result
    }
}


