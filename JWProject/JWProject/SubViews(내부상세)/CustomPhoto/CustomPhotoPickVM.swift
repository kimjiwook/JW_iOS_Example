//
//  CustomPhotoPickVM.swift
//  JWProject
//
//  Created by JWMacBook on 2022/10/07.
//

import UIKit
import SwiftUI
import PhotosUI

class CustomPhotoPickVM: ObservableObject {
    @Published var fetchedImage:PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
    @Published var selectIdentifier:[String] = [String]()
    
    @Published var albumTitle:String = "전체사진"
    @Published var selectedAlbum:PHAssetCollection = PHAssetCollection()
    @Published var fetchedAlbum:[PHAssetCollection] = [PHAssetCollection]()
    
    var maxSelectCount:Int = 10 // 최대 30장까지 선택가능함
    
    // Cahing PhAsset 저장 (identifier 기준)
    // 앨범 기준 썸네일 저장
    // 사진들/앨범 기준 저장
    var thumImages:[String:UIImage] = [String:UIImage]()
    
    init() {
        // 생성과 동시에 이미지 가져오기.
        fetchImages()
    }
    
    // MARK: - 이미지 불러오기
    func fetchImages() {
        let option = PHFetchOptions()
        
        // 숨겨진항목 가져오는 여부
        option.includeHiddenAssets = false
        option.includeAssetSourceTypes = [.typeUserLibrary]
        // 정렬기준(생성일자)
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        // 기본형에서는 괜찮은데, 앨범에서 선택시에는 통으로 나오기 때문에 추가작업을함.
        // option.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        // 그대로 넣기
        // fetchedImage = PHAsset.fetchAssets(with: .image, options: option)
        
        
//        // asset 화 시키기 (이부분이 속도 저하의 주된 원인 (40000개 For문 돌리고 넣는건데 당연하겠지.)
//        var count = 1
//        PHAsset.fetchAssets(with: .image, options: option).enumerateObjects { asset, _, _ in
//            print("\(count)")
//            count = count + 1
//            // 여기다 생성문제.
//            let imageAsset:CustomImageAsset = .init(asset: asset)
//            self.fetchedImage.append(imageAsset)
//        }
        
        // subType에 따라 나오는 앨범의 종류가 틀림.
        
        let albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil) // 카메라롤 맞긴 맞네(모든자산 앨범)
        /*
         이게 iOS 버전들에 따라서 최근항목, 카메라롤이 안나올수도 있다고 햠..
         내 폰에서는 나오지만 나오지 않을가능성도 있기때문에
         그럴꺼면 전체 이미지, 동영상 가져오는 1번을
         이걸 최근항목(카메라롤) 다국어 지원까지도 안됨..
         PHAsset.fetchAssets(with: .video, options: option)
         앨범들은 만들날짜 기준으로도 정렬해주면 최근항목이 제일 위인듯.
         fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
         */
        
        
        //var albumSum = albums + smartAlbums
        
        if let collection = smartAlbums.firstObject {
            fetchedImage = PHAsset.fetchAssets(in: collection, options: option)
            selectedAlbum = collection
        }
        
        print("")
        /*
         스마트 앨범부터 추가하고 나머지는 아래로 붙여주기.
         */
        for var index in 0..<smartAlbums.count {
            let album = smartAlbums[index]
            let title = album.localizedTitle ?? "앨범"
            print("스마트 앨범 id :\(album.localIdentifier), 이름 : \(title), 카운트 : \(album.estimatedAssetCount)")
            
            fetchedAlbum.append(album)
        }
        
        // 앨범이름들 뽑기
        for index in 0..<albums.count {
            let album = albums[index]
            let title = album.localizedTitle ?? "앨범"
            print("앨범 id :\(album.localIdentifier), 이름 : \(title), 카운트 : \(album.estimatedAssetCount)")
            
            fetchedAlbum.append(album)
        }
        print("")
        
        /*
         앨범들의 첫번째 썸네일 가져오는 작업만 먼저해놓기
         내부 dispatch 걸어둠.
         */
        fetchedAlbum.forEach { album in
            self.getAlbumFirstCahing(album)
        }
    }
    
    func selectedAlbum(_ album:PHAssetCollection) {
        selectedAlbum = album
        
        let option = PHFetchOptions()
        
        // 숨겨진항목 가져오는 여부
        option.includeHiddenAssets = false
        option.includeAssetSourceTypes = [.typeUserLibrary]
        // 정렬기준(생성일자)
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        // 기본형에서는 괜찮은데, 앨범에서 선택시에는 통으로 나오기 때문에 추가작업을함.
        // option.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        fetchedImage = PHFetchResult<PHAsset>() // 초기화 후 요청
        fetchedImage = PHAsset.fetchAssets(in: album, options: option)
    }
    
    
    /// 선택정보 체크
    func selectIdentifier(_ identifiers:[String]) {
        /*
         필터링으로 있는건 빼주고, 없는건 넣어주고, Index 표기 해줘야함
         Max 값 지정된 만큼도 설정 필요함
         */
        identifiers.forEach { id in
            withAnimation {
                if checkIdentifier(id) {
                    // 기존에 있으면 제거
                    selectIdentifier.removeAll(where: {
                        $0 == id
                    })
                } else {
                    // 없을시 추가.
                    // 최대갯수 증가하면 추가안됨.
                    guard maxSelectCount > selectIdentifier.count else {
                        return
                    }
                    
                    selectIdentifier.append(id)
                }                
            }
        }
    }
    
    /// 해당 identifier 체크 후 삭제
    /// - Parameter identifier: String
    func removeIdentifier(_ identifier:String) {
        withAnimation {
            if checkIdentifier(identifier) {
                selectIdentifier.removeAll(where: {
                    $0 == identifier
                })
            }
        }
    }
    
    /// identifier 기준 선택되어 있는지 체크
    func checkIdentifier(_ identifier:String) -> Bool {
        return selectIdentifier.filter({
            $0 == identifier
        }).count > 0
    }
    
    /// identifier 기준 PHAsset 가져오기
    /// - Parameter identifier: String
    /// - Returns: PHAsset
    func getAsset(_ identifier:String) -> PHAsset {
        let option = PHFetchOptions()
        // 숨겨진항목 가져오는 여부 (정리해서 같이써야겠는데)
        option.includeHiddenAssets = false
        option.includeAssetSourceTypes = [.typeUserLibrary]
        // 정렬기준(생성일자)
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        if let result = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: option).firstObject {
            return result
        } else {
            return PHAsset()
        }
    }
    
    /// 현재선택된 정보중 몇번째로 선택되어있는지 체크
    /// - Parameter identifier: String
    /// - Returns: String (Display 성)
    func getSelectedDisplayIndex(_ identifier:String) -> String {
        let index = selectIdentifier.firstIndex(of: identifier) ?? -1
        
        /*
         Display 성이기때문에 1부터 시작이며,
         0아래의 값이 전달될 시에는 값 "" 으로 전달
         */
        var result = ""
        if 0 <= index {
            result = "\(index + 1)"
        }
        return result
        
    }
    
    func getAlbumCount(_ album:PHAssetCollection) -> String {
        /*
         estimatedAssetCount 빠르게 계산되지 않는경우 포인터 이상한값이 내려옴
         결국 앨범에서 직접 카운트 확인하는게 제일좋음
         var count = album.estimatedAssetCount
         */
        var count = album.estimatedAssetCount
        
        // 값이 없을때는 조회함
        if count == NSNotFound {
            let option = PHFetchOptions()
            
            // 숨겨진항목 가져오는 여부
            option.includeHiddenAssets = false
            option.includeAssetSourceTypes = [.typeUserLibrary]
            // 정렬기준(생성일자)
            option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            // 기본형에서는 괜찮은데, 앨범에서 선택시에는 통으로 나오기 때문에 추가작업을함.
            // option.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            
            var tempFetchedImage = PHFetchResult<PHAsset>() // 초기화 후 요청
            tempFetchedImage = PHAsset.fetchAssets(in: album, options: option)
            
            count = tempFetchedImage.count
        }
        

        // 천단위 구분기호
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        return numberFormatter.string(from: NSNumber(value: count))!
    }
    
    func getAlbumFirstCahing(_ album:PHAssetCollection) {
        DispatchQueue.global().async {
            let collectionOption = PHFetchOptions()
            
            // 숨겨진항목 가져오는 여부
            collectionOption.includeHiddenAssets = false
            collectionOption.includeAssetSourceTypes = [.typeUserLibrary]
            collectionOption.fetchLimit = 1 // 1장만 가져오기
            // 정렬기준(생성일자)
            collectionOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            // 기본형에서는 괜찮은데, 앨범에서 선택시에는 통으로 나오기 때문에 추가작업을함.
            // collectionOption.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            
            guard let asset = PHAsset.fetchAssets(in: album, options: collectionOption).firstObject else {
                return
            }
            
            let option = PHImageRequestOptions()
            option.isNetworkAccessAllowed = true
            
            PHCachingImageManager().requestImage(for: asset, targetSize: CGSize(width: 80, height: 80), contentMode: .aspectFill, options: option) { image, _ in
                if let image = image {
                    // 앨범의 썸네일 미리 넣어놓기
                    DispatchQueue.main.async {
                        self.thumImages[album.localIdentifier] = image
                    }
                }
            }
        }
    }

    /// 동영상의 경우 시간정보 가져오기
    /// - Parameter asset: PHAsset
    /// - Returns: String (00:00:00 or 00:00)
    func getMediaTime(_ asset:PHAsset) -> String {
        var displayCount = ""
        
        let duration = Int(asset.duration) // Sec 로 표현되서 전달해줌.
//        let durationTime = CMTimeGetSeconds(duration)
        // let hours = duration/(60 * 60)
        let minutes = duration/60
        let seconds = String(format: "%02d", duration%60) // 초는 무조건 두자리!
        displayCount = "\(minutes):\(seconds)"
        // 시간까지는 표현 안해줌..
//        if 0 < hours {
//            displayCount = "\(hours):\(minutes):\(seconds)"
//        }
        // 00:00:00 시간존재시에는 이렇게 표현해주기.
        // 초는 2자리가 아니여도 2자리로 보이기
        
        return displayCount
    }
}
