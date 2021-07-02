//
//  CellVM.swift
//  JWProject
//
//  Created by JW_Macbook on 2021/07/01.
//

import UIKit

class CellVM: NSObject {
    
    
    // 임시생성자
    class func cellVMs() -> [CellVM] {
        var vms:[CellVM] = [CellVM]()
        
        for i in 0..<10000 {
            vms.append(CellVM())
        }
        
        return vms
    }
}
