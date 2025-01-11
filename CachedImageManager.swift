import Photos
import SwiftUI

class CachedImageManager {
    
    @Published var imageCache: [String: UIImage] = [:]
    
    private let imageManager = PHCachingImageManager()
    
    private lazy var requestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        return options
    }()
    
    private var cachedAssetIdentifiers = [String : Bool]()
    
    var cachedImageCount: Int {
        cachedAssetIdentifiers.keys.count
    }
    
    func requestImage(for asset: PHAsset, targetSize: CGSize, completion: @escaping(Image) -> Void) {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .opportunistic
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, _ in
            if let image = image {
                completion(Image(uiImage: image))
            }
        }
    }
    
    func requestImage(for asset: PhotoAsset, targetSize: CGSize, 
                      completion: @escaping((image: Image?, isLowerQuality: Bool)?) -> Void) -> PHImageRequestID? {
        guard let phAsset = asset.phAsset else {
            completion(nil)
            return nil
        }
        let requestID = imageManager.requestImage(for: phAsset,
                                                  targetSize: targetSize,
                                                  contentMode: PHImageContentMode.aspectFit,
                                                  options: requestOptions) { image, info in
            if let error = info?[PHImageErrorKey] as? Error {
                print(error.localizedDescription)
                completion(nil)
            }
            else if let cancelled = (info?[PHImageCancelledKey] as? NSNumber)?.boolValue, cancelled {
                print("CacheedImageManger request cancelled")
                completion(nil)
            }
            else if let image = image {
                let isLowerQualityImage = (info?[PHImageResultIsDegradedKey] as? NSNumber)?.boolValue ?? false
                let result = (image: Image(uiImage: image), isLowerQuality: isLowerQualityImage)
                completion(result)
            }
        }
        return requestID
    }
    
    func startCaching(for assets: [PhotoAsset], targetSize: CGSize) {
        let phAssets = assets.compactMap { $0.phAsset }
        phAssets.forEach {
            cachedAssetIdentifiers[$0.localIdentifier] = true
        }
        imageManager.startCachingImages(for: phAssets, targetSize: targetSize, contentMode: .aspectFit, options: requestOptions)
    }
    
    func stopCaching(for assets: [PhotoAsset], targetSize: CGSize) {
        let phAssets = assets.compactMap { $0.phAsset }
        phAssets.forEach {
            cachedAssetIdentifiers[$0.localIdentifier] = true
        }
        imageManager.stopCachingImages(for: phAssets, targetSize: targetSize, contentMode: .aspectFit, options: requestOptions)
    }
    
    func stopCaching() {
        imageManager.stopCachingImagesForAllAssets()
    }
}
