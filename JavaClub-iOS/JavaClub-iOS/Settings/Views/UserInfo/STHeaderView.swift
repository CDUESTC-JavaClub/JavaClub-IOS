//
//  STHeaderView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/4.
//

import SwiftUI
import Kingfisher

struct STHeaderView: View {
    @Binding var user: JCUser?
    @State var avatar: URL?
    @State var banner: URL?
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                KFImage(banner)
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
                
                KFImage(avatar)
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
            // FIXME: Images not loaded if View is not showing for the first time
            .valueChanged(value: user) { newUser in
                
                if
                    let avatarStr = newUser?.avatar,
                    let avatarURL = URL(string: avatarStr)
                {
                    avatar = avatarURL
                }

                if
                    let bannerStr = newUser?.banner,
                    let bannerURL = URL(string: bannerStr)
                {
                    banner = bannerURL
                }
            }
        }
    }
}
