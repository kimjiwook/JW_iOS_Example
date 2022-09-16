//
//  ContentVM.swift
//  JWProject_SwiftUI
//
//  Created by JWMacBook on 2022/03/12.
//
/*
 2022. 03. 12 Kimjiwook
 SwiftUI 시작을 위한 리스트 Item VM 만들기
 */

import UIKit
import Combine

class ContentVM: ObservableObject {
    /// 리스트 아이템
    @Published var listItem:[ContentItemVM] = [ContentItemVM]()
    
    /// 초기값
    init() {
        /*
         샘플앱이기 떄문에 생성시점에 표현할 데이터를 다 만들어줍니다.
         */
        self.listItem = [
            ContentItemVM.instance(.P001)
        ]
    }
}

/// 프로젝트 내용당 Id 부여해주기
enum ContentId:String {
    case P001 = "P001"
    case P002 = "P002"
    case P003 = "P003"
}

class ContentItemVM: ObservableObject, Identifiable {
    /// 키값
    @Published var pid:ContentId = .P001
    /// 생성날짜
    @Published var createDate:Date = Date()
    /// 제목
    @Published var title:String = ""
    /// 내용 부분
    @Published var content:String = ""
    /// 키워드
    @Published var keyword:[String] = [String]()
}

extension ContentItemVM: Equatable {
    /// 비교 연산자
    static func == (lhs: ContentItemVM, rhs: ContentItemVM) -> Bool {
        return lhs.pid == rhs.pid
    }
}


extension ContentItemVM {
    class func instance(_ pid:ContentId) -> ContentItemVM {
        let vm = ContentItemVM()
        
        switch pid {
        case .P001:
            vm.title = "시계샘플 (아날로그시계)"
            vm.content = "아날로그 시계 표현, 도형을 활용한 애니메이션 처리"
            vm.keyword = ["시계", "애니메이션", "도형"]
            break
        default:
            break
        }
        
        
        
        return vm
    }
}
