

import Foundation
import Photos

struct DataModel: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var value: String?
    var index: Int?
}


struct PhotoAsset: Identifiable {
    var id: String { identifier }
    var identifier: String = UUID().uuidString
    var index: Int?
    var phAsset: PHAsset?
    
    
    init(phAsset: PHAsset, index: Int?) {
        self.phAsset = phAsset
        self.index = index
        self.identifier = phAsset.localIdentifier
    }
    
    func setIsFavorite(_ isFavorite: Bool) async {
        guard let phAsset = phAsset else { return }
        Task {
            do {
                try await PHPhotoLibrary.shared().performChanges {
                    let request = PHAssetChangeRequest(for: phAsset)
                    request.isFavorite = isFavorite
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func delete() async {
        guard let phAsset = phAsset else { return}
        do {
            try await PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.deleteAssets([phAsset] as NSArray)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension PhotoAsset: Equatable {
    static func == (lhs: PhotoAsset, rhs: PhotoAsset) -> Bool {
        (lhs.identifier == rhs.identifier)
    }
}


