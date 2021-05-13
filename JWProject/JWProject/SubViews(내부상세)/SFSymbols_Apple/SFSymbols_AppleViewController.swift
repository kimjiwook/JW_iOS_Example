//
//  SFSymbols_AppleViewController.swift
//  JWProject
//
//  Created by JW_Macbook on 2021/05/06.
//

import UIKit
import JWLibrary

class SFSymbols_AppleViewController: UIViewController {

    //MARK: - IBOutlet
    /// 코드에서 추가해볼 StackView
    @IBOutlet weak var codeInsertStackView: UIStackView!
    /// 코드에서 이름 변경해볼 Label
    @IBOutlet weak var codeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDzViews()
    }
    
    /// 생성자 추가.
    open class func instanse() -> SFSymbols_AppleViewController {
        let desc = SFSymbols_AppleViewController(nibName: "SFSymbols_AppleViewController", bundle: nil)
        return desc
    }
}

extension SFSymbols_AppleViewController: JWViewProtocol {
    func initDzViews() {
        /*
         1. UIImage 사용할때 systemImage 을 사용할 수 있는곳에 전부 사용이 가능함.
         */
        let commandImage = UIImageView(image: UIImage(systemName: "command"))
        let optionImage = UIImageView(image: UIImage(systemName: "option"))
        let altImage = UIImageView(image: UIImage(systemName: "alt"))
        
        self.codeInsertStackView.addArrangedSubview(commandImage)
        self.codeInsertStackView.addArrangedSubview(optionImage)
        self.codeInsertStackView.addArrangedSubview(altImage)
        
        /*
         2. 이름 영역에 특정 기호 넣어보기 (기호복사를 통해 사용이 가능함)
         􀆔, 􀆕, 􀆖, 􀆝, 􀆮, 􀖃, 􀇑
         이것저것 다 복사됨
         */
        self.codeLabel.text = "기호복사 [􀆔, 􀆕, 􀆖, 􀆝, 􀆮, 􀖃, 􀇑]"
    }
    
    func updateDzViews() {
        
    }
    
    func setDzNavigationViews() {
        
    }
    
    func doDzBackAction() {
        
    }
    
    
}
