//
//  JCImageManager.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/4.
//

import UIKit

class JCImageManager {
    static let shared = JCImageManager()
    
    private let cache = NSCache<NSString, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    
    private init() {}
}


extension JCImageManager {
    
    /**
     *  Load image from the server.
     *
     *  - Parameters:
     *      - urlString: URL string for the image.
     *      - completion: A block of what you wanna do with the retrieved image.
     */
    func loadImage(urlString: String, _ completion: @escaping (UIImage?) -> Void) {
        utilityQueue.async {
            guard
                let url = URL(string: urlString),
                let data = try? Data(contentsOf: url)
            else { return }
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    /**
     *  Get a cached image with a defined key.
     *
     *  - Parameters:
     *      - key: The key you define the image.
     */
    func fromCache(forKey key: NSString) -> UIImage? {
        cache.object(forKey: key)
    }
    
    /**
     *  Cache image to local for reuse.
     *
     *  - Parameters:
     *      - image: The `UIImage` you wanna cache.
     *      - key: The key you define the image.
     */
    func cacheImage(_ image: UIImage, forKey key: NSString) {
        cache.setObject(image, forKey: key)
    }
}
