//
//  PhotoAndSettingViewController.swift
//  JWProject
//
//  Created by JWMacBook on 2022/09/16.
//

import UIKit
import JWLibrary
import Photos

class PhotoAndSettingViewController: UIViewController {

    // UI 관련
    var mainStackView:UIStackView? // 메인 스택뷰
    
    class func instance() -> PhotoAndSettingViewController {
        let desc = PhotoAndSettingViewController()
        return desc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDzViews()
    }
    
}

extension PhotoAndSettingViewController: JWViewProtocol {
    func initDzViews() {
        self.view.backgroundColor = .white
        
        // #. 스택뷰 관련
        if nil == mainStackView {
            mainStackView = UIStackView()
            mainStackView?.alignment = .center
            mainStackView?.axis = .vertical
            mainStackView?.spacing = 8
            
            self.view.addSubview(mainStackView!)
        }
        
        // 버튼 추가하기
        let photoBtn:UIButton = {
            let btn = UIButton(type: .system)
            btn.setTitle("권한물어보기", for: .normal)
            btn.addAction(UIAction(handler: { _ in
                self.authorization()
            }), for: .touchUpInside)
            return btn
        }()
        
        let settingBtn:UIButton = {
            let btn = UIButton(type: .system)
            btn.setTitle("해당 앱 설정으로 이동하기", for: .normal)
            btn.addAction(UIAction(handler: { _ in
                self.jumpToSetting()
            }), for: .touchUpInside)
            return btn
        }()
        
        mainStackView?.addArrangedSubview(photoBtn)
        mainStackView?.addArrangedSubview(settingBtn)
        
        self.updateDzViews()
    }
    
    func updateDzViews() {
        self.mainStackView?.snp.remakeConstraints({ make in
            make.center.equalToSuperview()
        })
    }
    
    func setDzNavigationViews() {
        
    }
    
    func doDzBackAction() {
        
    }
}

extension PhotoAndSettingViewController {
    /// 권한 물어보기 샘플
    func authorization() {
        // 예시) 사진접근권함
        
        /*
         샘플동영상 : https://youtube.com/shorts/dNa1fGKGgH4?feature=share
         1. info.plist 설정 추가
         https://developer.apple.com/documentation/bundleresources/information_property_list/nsphotolibraryusagedescription
         2. PHPhotoLibrary 접근
         https://developer.apple.com/documentation/photokit/phauthorizationstatus
         */
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { state in
            // state < 접근권한 아래항목과 동일함.
            self.checkAuthorization(state)
        }
    }
    
    func checkAuthorization(_ state:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)) {
        switch state {
            
        case .notDetermined:
            // 사용자가 앱의 인증 상태를 설정하지 않았습니다.
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { _state in
                self.checkAuthorization(state)
            }
            break
        case .restricted:
            // 앱이 사진 라이브러리에 액세스할 수 있는 권한이 없으며 사용자는 이러한 권한을 부여할 수 없습니다.
            alertErrorCheckShow()
            break
        case .denied:
            // 사용자가 사진 라이브러리에 대한 이 앱 액세스를 명시적으로 거부했습니다.
            alertErrorCheckShow()
            break
        case .authorized:
            // 사용자가 명시적으로 이 앱에 사진 라이브러리에 대한 액세스 권한을 부여했습니다.
            alertShow()
            break
        case .limited:
            // 사용자가 이 앱에 제한된 사진 라이브러리 액세스 권한을 부여했습니다.
            alertShow()
            break
        @unknown default:
            break
        }
    }
    
    func alertErrorCheckShow() {
        let alert = UIAlertController(title: "권한", message: "권한이 빠진것 같은데", preferredStyle: .alert)
        let action = UIAlertAction(title: "권한페이지 이동하자", style: .cancel, handler: { _ in
            self.jumpToSetting()
        })
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func alertShow() {
        let alert = UIAlertController(title: "권한", message: "권한이 정상적입니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "잘했어요", style: .default, handler: { _ in
            // self.jumpToSetting()
        })
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    /// 해당 앱 설정 페이지 이동하기
    func jumpToSetting() {
        let openSettingURLString = UIApplication.openSettingsURLString
        if let url = URL(string: openSettingURLString) {
            UIApplication.shared.open(url)
        }
    }
}
