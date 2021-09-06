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
    @Default(.avatarURL) var avatarURL
    @Default(.avatarLocal) var avatarLocal
    @Default(.bannerURL) var bannerURL
    @Default(.bannerLocal) var bannerLocal
    @State var avatarImg: UIImage?
    @State var bannerImg: UIImage?
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                if let bannerPath = bannerLocal, let img = loadImg(fileURL: bannerPath) {
                    Image(uiImage: img)
                        .centerCropped(height: 230)
                } else {
                    KFImage(bannerURL)
                        .placeholder {
                            Text("封面加载中...")
                                .fixedSize()
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
                            Text("头像加载中...")
                                .fixedSize()
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
