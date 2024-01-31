//
//  CacheAsyncImage.swift
//  Recipes-App
//
//  Created by Igor Max de Lima Nunes on 27/01/24.
//

import Foundation
import SwiftUI

class CacheManager {
    static let shared = CacheManager() // Singleton
    
    private var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100 // 100mb
        return cache
    }()
    
    func getImageFromCache(name: String) -> UIImage? {
        return imageCache.object(forKey: name as NSString)
    }
    
    func addImageToCache(image: UIImage, name: String) {
        imageCache.setObject(image, forKey: name as NSString)
        print("Added to cache")
    }
}

//struct CachedAsyncImage: View {
//    let url: URL
//    @State private var image: UIImage?
//
//    var body: some View {
//        if let image = CacheManager.shared.getImageFromCache(name: url.absoluteString) {
//            Image(uiImage: image)
//                .resizable()
//                .scaledToFit()
//        } else {
//            AsyncImage(url: url) { phase in
//                
//                switch phase {
//                case .success(let image):
//                    CacheManager.shared.addImageToCache(image: UIImage(data: image), name: url.absoluteString)
//                }
//            }
//        }
//    }
//}
//


