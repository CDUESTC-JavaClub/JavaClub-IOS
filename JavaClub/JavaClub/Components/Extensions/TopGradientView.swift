//
//  GradientView.swift
//
//  Created by roy on 2022/1/6.
//

import UIKit

enum GradientType: Int {
    case ToBottom = 0 /// 从上到下
    case leftToRight = 1 /// 从左到右
    case bottomTo = 2 /// 从下到上
    case rightToLeft = 3 /// 从右到左
}

class GradientView: UIView {

    public override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updatebgGradientStyle()
    }
    
    public var gradientColors: [UIColor]?
    /// 0 1
    @IBInspectable var gradientType: Int = 1
    
    private func updatebgGradientStyle() {
        guard let bgGradient = layer as? CAGradientLayer else {
            return
        }
        guard let colors = gradientColors else {
            bgGradient.locations = nil
            bgGradient.colors = nil
            return
        }
        
        guard let type = GradientType(rawValue: gradientType)  else {
            return
        }
        
        bgGradient.colors = colors.map({ $0.cgColor })
        bgGradient.locations = [0, 1]
        
        switch type {
        case .ToBottom:
            bgGradient.startPoint = CGPoint(x: 0.5, y: 0)
            bgGradient.endPoint = CGPoint(x: 0.5, y: 1)
        case .bottomTo:
            bgGradient.startPoint = CGPoint(x: 0.5, y: 1)
            bgGradient.endPoint = CGPoint(x: 0.5, y: 0)
        case .leftToRight:
            bgGradient.startPoint = CGPoint(x: 0, y: 0.5)
            bgGradient.endPoint = CGPoint(x: 1, y: 0.5)
        case .rightToLeft:
            bgGradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            bgGradient.endPoint = CGPoint(x: 0, y: 0.5)
        }
    }


}
