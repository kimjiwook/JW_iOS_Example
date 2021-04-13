//
//  ViewController.swift
//  JWProject
//
//  Created by JW_Macbook on 2021/03/29.
//

import UIKit
import SnapKit  //AutoLayout 서포트
import JWLibrary

public class sample {
    public static let shared = sample()
    
    func temp() {
        
    }
}

class ViewController: UIViewController {
    // MARK: - UI 관련
    var mainCollectionView:UICollectionView? = nil
    
    // MARK: - 내부, 외부 변수 관련
    let vm = MainVM()
    
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
        
        // #. 디폴트
        self.title = "JW iOS Sample"
        
        
        // UI 구성하기.
        // 1. 컬렉션뷰
        if nil == self.mainCollectionView {
            self.mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createCompositionalLayout())
            self.mainCollectionView?.backgroundColor = .lightGray
            
            self.mainCollectionView?.register(UINib.init(nibName: vm.cellId, bundle: nil), forCellWithReuseIdentifier: vm.cellId)
            
            self.mainCollectionView?.delegate = self as UICollectionViewDelegate
            self.mainCollectionView?.dataSource = self as UICollectionViewDataSource
            
            self.view.addSubview(self.mainCollectionView!)
        }
        
        // 오토레이아웃 설정
        self.updateDzViews()
    }
    
    func updateDzViews() {
        self.mainCollectionView?.snp.remakeConstraints({ (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        })
    }
    
    func setDzNavigationViews() {
        
    }
    
    func doDzBackAction() {
        
    }
}

// MARK: - #. 컬렉션뷰 델리게이트, 데이터 소스 관련
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.itmes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vm.cellId, for: indexPath) as! MainCell
        
        // 데이터 꾸며주는 부분
        let cellVM:MainCellVM = vm.itmes[indexPath.row]
        cell.configrationCell(vm: cellVM)
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // 액션 진행
        let cellVM:MainCellVM = vm.itmes[indexPath.row]
        switch cellVM.uuid {
        
        // UIMenu Sample 이동
        case .UIMenu:
            let uiMenuVC = UIMenuSampleViewController()
            self.navigationController?.pushViewController(uiMenuVC, animated: true)
            break
            
        default:
            // 아직 정의되지 않은 부분
            break
        }
    }
}

// MARK: - #. 컬렉션뷰 레이아웃
extension ViewController {
//    /// 1. 해더 사이즈 구하기
//    /// - Returns: NSCollectionLayoutBoundarySupplementaryItem
//    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
//        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                heightDimension: .absolute(40))
//        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//
//        return headerElement
//    }
    
    /// 2. 배경 만들기 (그룹이 아니여서 배경이 없음)
//    private func createSectionBackground(count:Int = 0) -> NSCollectionLayoutDecorationItem {
//
//        // 카운트 없을때랑 있을때랑 배경이 조금 다름
//        var kind = self.sectionDefaultBackground
//        if count == 0 {
//            kind = self.sectionEmptyBackground
//        }
//
//        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: kind)
//
//        // 해더의 높이는 빼고 진행합니다.
//        backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: headerHeight, leading: margin, bottom: 0, trailing: margin)
//
//        return backgroundItem
//    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let height:NSCollectionLayoutDimension = .estimated(69) // 디폴트
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: height))
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: height)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                         subitems: [item])
            
            
            // section 구성
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12)
            
            section.interGroupSpacing = 8
            // section.boundarySupplementaryItems = [self.createHeader()]
            // section.decorationItems = [self.createSectionBackground(count: array.count)] // 디폴트 배경화면 필요한 항목
            return section
        }
        
        return layout
    }
}
