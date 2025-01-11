//
//  PhotoViewModel.swift
//  NavigationEffect
//
//  Created by window1 on 7/18/24.
//

import SwiftUI
import Photos

class PhotoViewModel: NSObject, ObservableObject {
    
    @Published var data: [DataModel] = []
    @Published var selectedItem: DataModel?
    @Published var animateView: Bool = false
    @Published var showDetailView: Bool = false
    @Published var detailScrollPosition: String?
    @Published var detailIndicatorPosition: String?
    @Published var offset: CGSize = .zero
    @Published var dragProgress: CGFloat = 0
    @Published var allPhotos = PHFetchResult<PHAsset>()
    
    @Published var selectedAssetItem: PhotoAsset?
    @Published var photoCollection = PhotoCollection(smartAlbum: .smartAlbumUserLibrary)
    @Published var imageCache: [String: UIImage] = [:]
    
    override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
        
        Task {
            await fetchImageName()
            try await fetchAsset()
        }
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    //MARK: PhotoLibarayGrid - Method
    
    func checkAuthorization() async -> Bool {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .notDetermined:
            print("Photo library access authroized")
            return await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized
        case .restricted:
            print("Photo library access restricted")
            return false
        case .denied:
            print("Photo library access denied")
            return false
        case .authorized:
            print("Photo library access authorized")
            return true
        case .limited:
            print("Photo library access limited")
            return false
        @unknown default:
            return false
        }
    }
    
    //라이브러리 불러오기
    func fetchAsset() async throws {
        guard await checkAuthorization() else { return }
        Task {
            do {
                try await self.photoCollection.load()
            } catch let error {
                print("Failed to load photo collection \(error.localizedDescription)")
            }
        }
    }

    
    func toggleToPhoto(show: Bool) {
        if show {
            detailScrollPosition = selectedAssetItem?.id
            detailIndicatorPosition = selectedAssetItem?.id
            withAnimation(.easeInOut(duration: 0.2), completionCriteria: .removed) {
                animateView = true
            } completion: {
                self.showDetailView = true
            }
        } else {
            showDetailView = false
            withAnimation(.easeInOut(duration: 0.2), completionCriteria: .removed) {
                animateView = false
                offset = .zero
            } completion: {
                self.resetAnimationPropertiesToPhoto()
            }
        }
    }
    
    func resetAnimationPropertiesToPhoto() {
        selectedAssetItem = nil
        detailScrollPosition = nil
        offset = .zero
        dragProgress = 0
        detailIndicatorPosition = nil
    }
    
    
    func didDetailIndicatorChangedToPhoto() {
        //if let updatedItem = self.selectedAssetItem
        
    }
    
    func loadImage(for asset: PhotoAsset, targetSize: CGSize = CGSize(width: 800, height: 800)) async -> UIImage? {
        guard let phAsset = asset.phAsset else { return nil }
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        return await withCheckedContinuation { continuation in
            PHImageManager.default().requestImage(
                for: phAsset, targetSize: targetSize, contentMode: .aspectFit,
                options: options) { image , _ in
                    if let image = image {
                        DispatchQueue.main.async {
                            self.imageCache[asset.identifier] = image
                        }
                    }
                    continuation.resume(returning: image)
                }
        }
    }

    
    //MARK: PhotoGalley - Method
    func fetchImageName() async {
        let imgList = [
            "bobcat",
            "bullElk",
            "bullElkSparring",
            "bullTuleElkAndTwoFemales",
            "coyoteAndBison",
            "doubleRainbowLowerMammoth",
            "doubleRainbowYellowstone",
            "grizzly",
            "grizzlyCubs",
            "groundSquirrel",
            "harborSeal",
            "harborSealPup",
            "heartSpring",
            "newGrowthOfAntlers",
            "owlsAtMammoth",
            "rainbowAndBadlands",
            "redTailedHawk",
            "riverOtter",
            "soaringTheRainbow",
            "sunriseAtGrottoGeyser",
            "towerCreekBASIN",
            "yellowBelliedMarmot"
        ]
        
         let data = imgList.enumerated().map { index, name in
            DataModel(value: "\(name)", index: index)
        }
        
        await MainActor.run(body: {
            self.data = data
        })
    
    }
    
    func toggleView(show: Bool) {
        if show {
            detailScrollPosition = selectedItem?.id
            detailIndicatorPosition = selectedItem?.id
            withAnimation(.easeInOut(duration: 0.2), completionCriteria: .removed) {
                animateView = true
            } completion: {
                self.showDetailView = true
            }
        } else {
            showDetailView = false
            withAnimation(.easeInOut(duration: 0.2), completionCriteria: .removed) {
                animateView = false
                offset = .zero
            } completion: {
                self.resetAnimationPropertiesToPhoto()
            }
        }
    }
    
    func resetAnimationProperties() {
        selectedItem = nil
        detailScrollPosition = nil
        offset = .zero
        dragProgress = 0
        detailIndicatorPosition = nil
    }
    
    func didDetailPageChanged() {
        if let updatedItem = self.data.first(where: { $0.id == self.detailScrollPosition}) {
            self.selectedItem = updatedItem
            //상단 ScrollView 움직임에 따라 하단 Indicator 순서 맞추기
            withAnimation(.easeInOut(duration: 0.2)) {
                self.detailIndicatorPosition = updatedItem.id
            }
        }
    }
    
    func didDetailIndicatorChanged() {
        if let updatedItem = self.data.first(where: { $0.id == self.detailIndicatorPosition}) {
            self.selectedItem = updatedItem
            //하단 Indicator 움직임에 따라 상단 ScrollView 순서 맞추기
            self.detailScrollPosition = updatedItem.id
        }
    }
}

extension PhotoViewModel: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        Task { @MainActor in
            guard let changes = changeInstance.changeDetails(for: allPhotos) else { return }
            allPhotos = changes.fetchResultAfterChanges
        }
    }
}
