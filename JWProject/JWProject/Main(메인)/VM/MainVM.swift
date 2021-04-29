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
    var itmes:[MainCellVM] = [MainCellVM]()
    
    let cellId = "MainCell"
    
    // 초기값
    init() {
        itmes = getItems()
    }
    
    /// Cell Item 꾸며준 내용
    /// 고정 형식이다 보니 네트워크 통신 없는 형식입니다.
    /// - Returns: [MainCellVM]
    func getItems() -> [MainCellVM] {
        var result = [MainCellVM]()
        
        // 1. UIMenu 샘플 소스
        result.append(MainCellVM(uuid:.UIMenu, title: "UIMenu", content: "UIMenu Sample Source"))
        
        // 2. SPM 등록된 ViewController
        result.append(MainCellVM(uuid: .SPMSampleVC, title: "SPMSampleViewController", content: "SPM에서 만든 ViewController"))
        
        // 3. 회사 SPM 등록된 ViewController
        result.append(MainCellVM(uuid: .SPMDZSampleVC, title: "SPMDZSampleViewController", content: "SPM에서 만든 회사 ViewController"))
        
        
        return result
    }
}


