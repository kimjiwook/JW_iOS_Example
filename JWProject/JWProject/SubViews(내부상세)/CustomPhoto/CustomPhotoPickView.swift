//
//  CustomPhotoPickView.swift
//  JWProject
//
//  Created by JWMacBook on 2022/10/07.
//

import SwiftUI
import Photos
import UIKit

struct CustomPhotoPickView: View {
    /// ViewModel
    @StateObject var vm:CustomPhotoPickVM = CustomPhotoPickVM()
    /// 앨범선택영역 클릭시
    @State var isAlbumPresent:Bool = false
    
    /// SizeClass 적용을 위한 값
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        VStack {
            // 1. 탑영역
            ZStack(alignment: .center) {
                // 취소 , 확인(카운트) 버튼
                HStack {
                    Text("취소")
                        .foregroundColor(.black)
                    Spacer()
                     
                    if vm.selectIdentifier.count > 0 {
                        Text("\(vm.selectIdentifier.count)")
                            .foregroundColor(.blue)
                            .bold()
                    }
                    Text("확인")
                        .foregroundColor(.black)
                }
                // 제목영역
                HStack {
                    // 1. 앨범명
                    Text("\(vm.selectedAlbum.localizedTitle ?? "앨범")")
                        .foregroundColor(.black)
                    // 2. 화살표
                    Image(systemName: "chevron.down") // 아래방향 화상표
                        .foregroundColor(.black)
                        .rotationEffect(Angle(degrees: isAlbumPresent ? 180 : 0))
                }
                .onTapGesture {
                    print("선택한 identifier : \(vm.selectIdentifier.count)")
                    print(vm.selectIdentifier)
                    isAlbumPresent.toggle()
                }
            }
            .padding()
            
            // 2. 사진표기, 선택값 등등
            ZStack {
                VStack {
                    // 1. 선택한 값이 존재시 노출영역
                    if 0 < vm.selectIdentifier.count {
                        selectedThumViews()
                    }
                    
                    // 2. 사진영역
                    gridPhotoViews()
                }
                
                // 앨범선택창
                if isAlbumPresent {
                    // 3. 앨범선택 화면
                    gridAlbumViews()
                }
            }
        }
    }
}

// MARK : - ViewBuilder 영역
extension CustomPhotoPickView {
    @ViewBuilder
    /// 1. 사진 영역
    /// - Returns: View
    func gridPhotoViews() -> some View {
        // 3열 만들기.
//        let columns3 = [
//            GridItem(.flexible(), spacing: 1),
//            GridItem(.flexible(), spacing: 1),
//            GridItem(.flexible(), spacing: 1)
//        ]
        let columns3 = Array(repeating: GridItem(.flexible(), spacing: 1), count: 3)
        let columns7 = Array(repeating: GridItem(.flexible(), spacing: 1), count: 7)
//        let columns7 = [
//            GridItem(.flexible(), spacing: 1),
//            GridItem(.flexible(), spacing: 1),
//            GridItem(.flexible(), spacing: 1),
//            GridItem(.flexible(), spacing: 1),
//            GridItem(.flexible(), spacing: 1),
//            GridItem(.flexible(), spacing: 1),
//            GridItem(.flexible(), spacing: 1)
//        ]
        
        // Grid 그리기
        ScrollView(showsIndicators: true) {
            LazyVGrid(columns:(self.verticalSizeClass == .regular && self.horizontalSizeClass == .regular) ? columns7 : columns3, spacing: 1) {
                // 이미지 갯수대로 표현
                ForEach(0..<vm.fetchedImage.count, id:\.self) { index in
                    // 시작전 호출된 Asset 변수.
                    let asset = vm.fetchedImage[index]
                    ZStack {
                        // 이미지 부분
                        Rectangle()
                            .aspectRatio(1, contentMode: .fit)
                            .foregroundColor(.blue.opacity(0.3))
                            .overlay(
                                ThumImages(asset: asset)
                                    .scaledToFill()
                                    .aspectRatio(1, contentMode: .fit)
                                    .clipped()
                                    .id(asset.localIdentifier) // id 부여해놓기.
                                    .environmentObject(vm)
                            )
                            .clipped()
                        
                        // 선택영역
                        Rectangle()
                            .aspectRatio(1, contentMode: .fit)
                            .foregroundColor(vm.checkIdentifier(asset.localIdentifier) ? .black.opacity(0.3) : .clear)
                        
                        // 체크박스(카운트)
                        HStack {
                            Spacer()
                            VStack {
                                let displayText = vm.getSelectedDisplayIndex(asset.localIdentifier)
                                Circle()
                                // 라인 추가하니깐 foregroundColor 안먹음.. 근데 굳이 안해도 괜찮을듯
                                    // .strokeBorder(Color.gray.opacity(0.7), lineWidth: displayText == "" ? 2 : 0)
                                    .foregroundColor(displayText == "" ? .white.opacity(0.7) : .blue)
                                    .frame(width: 20, height: 20)
                                    .overlay (
                                        Text("\(displayText)")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                            .bold()
                                    )
                                Spacer()
                            }
                        }.padding(EdgeInsets(top: 10, leading: 8, bottom: 8, trailing: 10))
                        
                        // 비디오인 경우(시간초 표기)
                        if let asset = asset,
                           asset.mediaType == .video {
                            VStack {
                                Spacer() // 위쪽 여백
                                HStack {
                                    Image(systemName: "video") // 비디오 아이콘
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text(vm.getMediaTime(asset))
                                        .foregroundColor(.white)
                                        .font(.caption)
                                }
                                .padding(EdgeInsets(top: 4, leading: 2, bottom: 4, trailing: 5))
                                .background(Color.black.opacity(0.4))
                            }
                        }
                    }
                    .overlay (
                        // 선택시 테두리및 표기체크
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(vm.checkIdentifier(asset.localIdentifier) ? .blue : .clear, lineWidth: 4)
                            .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                    )
                    .onTapGesture {
                        // 클릭시 이벤트
                        vm.selectIdentifier([asset.localIdentifier])
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    /// 2. 선택한 썸네일 보이는 영역
    /// - Returns: View
    func selectedThumViews() -> some View {
        // 가로스크롤
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.flexible(), spacing: 4)]) {
                Spacer().frame(width: 8) // 제일 맨앞에 여백
                ForEach(vm.selectIdentifier, id:\.self) { identifier in
                    ZStack(alignment: .topTrailing) {
                        // 이미지 부분
                        Rectangle()
                            .aspectRatio(1, contentMode: .fit)
                            .foregroundColor(.blue.opacity(0.3))
                            .overlay(
                                ThumImages(asset: vm.getAsset(identifier))
                                    .scaledToFill()
                                    .aspectRatio(1, contentMode: .fit)
                                    .clipped()
                                    .environmentObject(vm)
                            )
                            .clipped()
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                        // 우측 상단 X 마크
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.black.opacity(0.7))
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .clipped()
                            
                    }
                    .onTapGesture {
                        vm.removeIdentifier(identifier)
                    }
                }
                Spacer().frame(width: 8) // 제일 마지막에 여백
            }
        }
        .frame(height: 60)
        .onChange(of: vm.selectIdentifier) { newValue in
            
        }
    }
    
    @ViewBuilder
    /// 3. 앨범선택 영역
    /// - Returns: View
    func gridAlbumViews() -> some View {
        ZStack(alignment: .top) {
            // 뒷 배경
            Rectangle()
                .foregroundColor(.black.opacity(0.5))
                .onTapGesture {
                    // 닫기
                    isAlbumPresent = false
                }
            // 화살표모양 추가
            JWTriangle()
                .frame(width: 26, height: 20)
                .foregroundColor(Color.white)
            
            // 선택 UI
            ScrollView {
                Spacer()
                    .frame(height: 4) // 초기 첫번째만 띄워주기.
                ForEach(vm.fetchedAlbum, id: \.self) { album in
                    LazyVStack {
                        VStack {
                            Button {
                                // 석택액션
                                isAlbumPresent = false
                                vm.selectedAlbum(album)
                            } label: {
                                HStack(spacing:12) {
                                    // 이미지 부분
                                    Rectangle()
                                        .aspectRatio(1, contentMode: .fit)
                                        .foregroundColor(.blue.opacity(0.3))
                                        .overlay(
                                            ThumImages(assetCollection: album)
                                                .scaledToFill()
                                                .aspectRatio(1, contentMode: .fit)
                                                .cornerRadius(3)
                                                .clipped()
                                                .id(UUID().uuidString) // id 부여해놓기.
                                                .environmentObject(vm)
                                        )
                                        .frame(width: 40, height: 40)
                                        .clipped()
                                    
                                    VStack(alignment: .leading) {
                                        // 앨범명
                                        Text(album.localizedTitle ?? "앨범")
                                            .foregroundColor(.black)
                                        // 카운트
                                        Text(vm.getAlbumCount(album))
                                            .foregroundColor(.gray)
                                            .font(.caption2)
                                        
                                    }
                                    Spacer() // 여백
                                }
                            }

                            
                            Divider()
                                .frame(height: 1)
                        }
                        .padding(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8))
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(5)
            .frame(maxWidth: 360, maxHeight: 400)
            .padding(EdgeInsets(top: 16, leading: 30, bottom: 8, trailing: 30))

        }
        .edgesIgnoringSafeArea(.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


// 썸네일 이미지/동영상 영역
struct ThumImages : View {
    @EnvironmentObject var vm:CustomPhotoPickVM
    @State private var tmpImage:UIImage?
    var asset:PHAsset? // 단일
    var assetCollection: PHAssetCollection? // 앨범(첫번째)
    // private let imageManager:PHImageManager = PHImageManager() // 원본가져올때.
    // 썸네일 영역이기 때문에 캐쉬사용
    private let imageCachingManager:PHCachingImageManager = PHCachingImageManager()
    
    var body: some View {
        ZStack {
            /*
             재사용시 tmpImage 가 nil 로 시작하는경우가 많음.
             데이터는 저장해 놓았는데도
             사진 || 앨범 identifier 기준~
             */
            if let identifier = asset?.localIdentifier ?? assetCollection?.localIdentifier,
               let image = tmpImage ?? vm.thumImages[identifier] {
                Image(uiImage: image)
                    .resizable()
                    .id(identifier)
                    .transition(.opacity.animation(.linear))
            } else {
                Image(systemName: "photo")
            }
            
        }.onAppear {
            // 살아날때마다 확인필요
            getImage()
        }.onDisappear {
            // 취소로직
        }
    }
    
    /// 썸네일 사이즈 이미지 가져오기.
    func getImage() {
        guard let asset = asset else {
            getAlbumFirst() // 없을때 앨범 체크
            return
        }
        
        // 캐쉬체크
        if let cahingImage = vm.thumImages[asset.localIdentifier] {
            tmpImage = cahingImage
            return
        }
        
        
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        self.imageCachingManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: option) { image, _ in
            if let image = image {
                // 갱신처리
                self.tmpImage = image
                vm.thumImages[asset.localIdentifier] = image
            }
        }
    }
    
    /// 앨범에서 첫번쨰
    func getAlbumFirst() {
        guard let album = assetCollection, nil == tmpImage, 0 != album.estimatedAssetCount else {
            return
        }
        
        // 캐쉬체크
        if let cahingImage = vm.thumImages[album.localIdentifier] {
            tmpImage = cahingImage
            return
        }
        
        
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
        self.imageCachingManager.requestImage(for: asset, targetSize: CGSize(width: 80, height: 80), contentMode: .aspectFill, options: option) { image, _ in
            
            if let image = image {
                // 갱신처리
                self.tmpImage = image
                // 앨범의 썸네일 미리 넣어놓기
                self.vm.thumImages[album.localIdentifier] = image
            }
        }
    }
}

/// 삼각형 그릴때 패스로 그려야함.
struct JWTriangle: Shape {
    func path(in rect:CGRect) -> Path {
        var path = Path()
        // 시작점
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        
        // 왼쪽 아래
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        // 오른쪽 아래
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        // 꼭지점
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}


struct CustomPhotoPickView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPhotoPickView()
    }
}
