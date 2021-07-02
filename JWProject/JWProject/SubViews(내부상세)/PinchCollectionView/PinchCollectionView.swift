//
//  PinchCollectionView.swift
//  JWProject
//
//  Created by JW_Macbook on 2021/07/01.
//

import UIKit
import JWLibrary

class PinchCollectionView: UIViewController {

    // MARK: - UI
    var mainCollectionView: UICollectionView? = nil
    
    let cellId:String = "PinchCell"
    let displayVMs:[CellVM] = CellVM.cellVMs() // 객체들 생성
    var groupCellCount:Int = 10
    var pinchGesture:UIPinchGestureRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDzViews()
    }
    
    /// 생성자 추가.
    open class func instanse() -> PinchCollectionView {
        let desc = PinchCollectionView()
        return desc
    }
    
    @objc func doPinch(_ pinch: UIPinchGestureRecognizer) {
        guard let collection = mainCollectionView else { return }
        guard let layout = collection.collectionViewLayout as? UICollectionViewCompositionalLayout else { return }

        switch pinch.state {
            case .began:
                print("시작")
            case .changed:
                var temp = CGFloat(groupCellCount) / pinch.scale
                // print("진행중 \(pinch.scale), \(Int(temp))")
                
                print("카운트 시작 : \(temp)")
                
                if 1 > temp {
                    temp = 1
                } else if 35 < temp {
                    temp = 35
                }
                print("카운트 종료 : \(temp)")
                // 변경될때마다 scale 초기화
                if groupCellCount != Int(temp) {
                    pinchGesture?.scale = 1.0 // 초기화
                    // 값 적용.
                    groupCellCount = Int(temp)
                }
                
                // Cell들을 줌 하는 형식으로
                for cell in collection.visibleCells {
                    cell.transform = cell.transform.scaledBy(x: pinch.scale, y: 1)
                }
                
        
                layout.invalidateLayout()
                
            case .ended:
                // 완료시점
                for cell in collection.visibleCells {
                    cell.transform = cell.transform.scaledBy(x: 1, y: 1)
                }
                layout.invalidateLayout()
            default:
              break
            }
    }
    
}

extension PinchCollectionView: JWViewProtocol {
    func initDzViews() {
        self.view.backgroundColor = .white
        
        // 1. CollectionView
        if mainCollectionView == nil {
            mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createCompositionalLayout())
            mainCollectionView?.delegate = self
            mainCollectionView?.dataSource = self
            self.view.addSubview(mainCollectionView!)
            self.mainCollectionView?.register(UINib.init(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
            
            // Pinch 기능 추가함.
            pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(doPinch(_:)))
            mainCollectionView?.addGestureRecognizer(pinchGesture!)
        }
        
        self.updateDzViews()
    }
    
    func updateDzViews() {
        // 1. CollectionView
        self.mainCollectionView?.snp.remakeConstraints({ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        })
    }
    
    func setDzNavigationViews() {
        
    }
    
    func doDzBackAction() {
        
    }
}

// MARK: - Layout
extension PinchCollectionView : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Section당 아이템 개수.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Key 별 item 갯수
        return displayVMs.count
    }
    
    // Make Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
        let vm:CellVM = self.displayVMs[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PinchCell
        if 0 == indexPath.row % 3 {
            cell.backgroundColor = .yellow
        } else if 1 == indexPath.row % 3 {
            cell.backgroundColor = .brown
        } else {
            cell.backgroundColor = .cyan
        }
        
        return cell
    }
    
    // 셀 선택했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    
    /// 1. 세션별 크기 구하기
    /// - Returns: UICollectionViewCompositionalLayout
    @objc func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let height:NSCollectionLayoutDimension = .estimated(50) // 디폴트
            let width:NSCollectionLayoutDimension = .estimated(50) // 디폴트
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: width,
                                                                                 heightDimension: height))
            
            let hGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: height)
            let hGroup = NSCollectionLayoutGroup.horizontal(layoutSize: hGroupSize, subitem: item, count: self.groupCellCount)
            hGroup.interItemSpacing = .fixed(0)
            
            // section 구성
            let section = NSCollectionLayoutSection(group: hGroup)
            section.orthogonalScrollingBehavior = .none
            
            // section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12)
            
            section.interGroupSpacing = 0
            section.boundarySupplementaryItems = []
            // section.decorationItems = [self.createSectionBackground(count: array.count)] // 디폴트 배경화면 필요한 항목
            return section
        }
        
        return layout
    }
}
