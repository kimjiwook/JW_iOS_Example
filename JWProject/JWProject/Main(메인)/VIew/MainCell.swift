//
//  MainCell.swift
//  JWProject
//
//  Created by JW_Macbook on 2021/04/13.
//

import UIKit

class MainCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    
    // MARK: - 내부, 외부 변수
    private var localVM:MainCellVM?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initView()
    }
    
    /// Cell 초기값
    func initView() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    /// 하일라이트일때 액션 체크중.
    override var isHighlighted: Bool {
        didSet {
            // 애니메이션 처리 해보기
            if isHighlighted {
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                })
            }
            else {
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            }
        }
    }
    
    func configrationCell(vm:MainCellVM) {
        // 변수 저장
        self.localVM = vm
        
        // 꾸미는 부분
        
        // self.iconImage.image // 아직 고민중
        
        self.lbTitle.text = vm.title
        self.lbTitle.font = vm.titleFont
        self.lbTitle.textColor = vm.titleColor
        
        self.lbContent.text = vm.content
        self.lbContent.font = vm.contentFont
        self.lbContent.textColor = vm.contentColor
    }
}
