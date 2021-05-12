//
//  SFSymbols_AppleViewController.swift
//  JWProject
//
//  Created by JW_Macbook on 2021/05/06.
//

import UIKit

class SFSymbols_AppleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /// 생성자 추가.
    open class func instanse() -> SFSymbols_AppleViewController {
        let desc = SFSymbols_AppleViewController(nibName: "SFSymbols_AppleViewController", bundle: nil)
        return desc
    }
}
