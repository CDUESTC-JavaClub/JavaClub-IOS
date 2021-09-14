//
//  STHeaderView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/4.
//

import SwiftUI
import Kingfisher
import Defaults

struct STHeaderView: View {
    @Binding var user: JCUser?
    @Default(.avatarURL) private var avatarURL
    @Default(.avatarLocal) private var avatarLocal
    @Default(.bannerURL) private var bannerURL
    @Default(.bannerLocal) private var bannerLocal
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                if let bannerPath = bannerLocal, let img = loadImg(fileURL: bannerPath) {
                    Image(uiImage: img)
                        .centerCropped(height: 230)
                } else {
                    KFImage(bannerURL)
                        .placeholder {
                            Color.secondary
                        }
                        .retry(maxCount: 5, interval: .seconds(3))
                        .cacheOriginalImage()
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: 230)
                        .clipped()
                }
                
                if let avatarPath = avatarLocal, let img = loadImg(fileURL: avatarPath) {
                    Image(uiImage: img)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    KFImage(avatarURL)
                        .placeholder {
                            Color.gray
                        }
                        .retry(maxCount: 5, interval: .seconds(3))
                        .cacheOriginalImage()
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .offset(y: 60)
                }
            }
        }
    }
    
    private func loadImg(fileURL: URL) -> UIImage? {
        do {
            let imageData = try Data(contentsOf: fileURL)
            
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error.localizedDescription)")
        }
        
        return nil
    }
}
