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
    func loadImage(url: URL, _ completion: @escaping (UIImage?) -> Void) {
        utilityQueue.async {
            guard let data = try? Data(contentsOf: url) else { return }
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    /**
     *  Save an `UIImage` to disk.
     *
     *  - Parameters:
     *      - img: An `UIImage` you wanna store.
     */
    func saveToDisk(_ fileName: String, img: UIImage) -> URL? {
        if let imgData = img.pngData() {
            let fileURL = getDocumentsDirectory()
                .appendingPathComponent(fileName)
                .appendingPathExtension("png")
            
            do {
                try imgData.write(to: fileURL, options: [.atomic])
                
                return fileURL
            } catch {
                print("ERR: \(error.localizedDescription)")
            }
        }
        
        return nil
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
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
