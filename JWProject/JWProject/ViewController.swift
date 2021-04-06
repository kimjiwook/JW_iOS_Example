//
//  ViewController.swift
//  JWProject
//
//  Created by JW_Macbook on 2021/03/29.
//

import UIKit
import JWLibrary

public class sample {
    public static let shared = sample()
    
    func temp() {
        
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initDzViews()
    }
}

/// 1. 프로토콜 상속받기!!
extension ViewController: JWViewProtocol {
    func initDzViews() {
        sample.shared.temp()
    }
    
    func updateDzViews() {
        
    }
    
    func setDzNavigationViews() {
        
    }
    
    func doDzBackAction() {
        
    }
}

