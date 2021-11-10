//
//  JCImageManager.swift
//  JavaClub
//
//  Created by Roy on 2021/11/10.
//

import UIKit
import Kingfisher

class JCImageManager {
    static let shared = JCImageManager()
    
    private init() {}
}


// MARK: Shared Methods -
extension JCImageManager {
    
    func fetch(from path: String, _ completion: @escaping (ImageLoadingResult?) -> Void) {
        guard let imgURL = URL(string: path) else {
            completion(nil)
            return
        }
        
        fetch(from: imgURL, completion)
    }
    
    func fetch(from url: URL, _ completion: @escaping (ImageLoadingResult?) -> Void) {
        ImageDownloader.default.downloadImage(with: url) { result in
            switch result {
                case .success(let data):
                    completion(data)
                    
                case .failure(let error):
                    print("DEBUG: Fetch Event Image Failed With Error: \(String(describing: error))")
                    completion(nil)
            }
        }
    }
    
    func local(for key: String, _ completion: @escaping (UIImage?) -> Void) {
        ImageCache.default.retrieveImage(forKey: key) { result in
            switch result {
                case .success(let data):
                    print("DEBUG: Using Local Cached Image.")
                    completion(data.image)
                    
                case .failure(let error):
                    print("DEBUG: Get Local Image Failed With Error: \(String(describing: error))")
                    completion(nil)
            }
        }
    }
    
    func store(_ data: Data, forKey key: String) {
        ImageCache.default.storeToDisk(data, forKey: key)
    }
}
