//
//  CXGRoundedCornersView.swift
//  CXGTools
//
//  Created by CuiXg on 2021/8/24.
//

/// 设置不规则圆角
import UIKit

struct CXGRoundedCornersRadius {
    let topLeft: CGFloat
    let topRight: CGFloat
    let bottomLeft: CGFloat
    let bottomRight: CGFloat
}

class CXGRoundedCornersView: UIView {

    /// 圆角半径
    var cornersRadius: CXGRoundedCornersRadius?
    /// 边框颜色( 与 borderColors 二选一, 优先级高)
    var borderColor: UIColor?
    /// 边框颜色,渐变色( 与 borderColors二选一, 优先级低)
    var borderColors: [UIColor]?
    /// 边框宽度
    var borderWidth: CGFloat?
    /// 边框和内容间距颜色(必须设置边框才有效)
    var paddingColor: UIColor?
    /// 边框和内容间距宽度(必须设置边框才有效)
    var paddingWidth: CGFloat?

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if let cornersRadius = cornersRadius {
            let minX = bounds.minX
            let minY = bounds.minY
            let maxX = bounds.maxX
            let maxY = bounds.maxY
            // 左上角中心
            let topLeftCenter = CGPoint(x: minX + cornersRadius.topLeft, y: minY + cornersRadius.topLeft)
            // 右上角中心
            let topRightCenter = CGPoint(x: maxX - cornersRadius.topRight, y: minY + cornersRadius.topRight)
            // 左下角中心
            let bottomLeftCenter = CGPoint(x: minX + cornersRadius.bottomLeft, y: maxY - cornersRadius.bottomLeft)
            // 右下角中心
            let bottomRightCenterX = CGPoint(x: maxX - cornersRadius.bottomRight, y: maxY - cornersRadius.bottomRight)


            let path = UIBezierPath()
            // 左上
            path.addArc(withCenter: topLeftCenter, radius: cornersRadius.topLeft, startAngle: .pi, endAngle: .pi / 2 * 3, clockwise: true)
            // 右上
            path.addArc(withCenter: topRightCenter, radius: cornersRadius.topRight, startAngle: .pi / 2 * 3, endAngle: 0, clockwise: true)
            // 右下
            path.addArc(withCenter: bottomRightCenterX, radius: cornersRadius.bottomRight, startAngle: 0, endAngle: .pi / 2, clockwise: true)
            // 左下
            path.addArc(withCenter: bottomLeftCenter, radius: cornersRadius.bottomLeft, startAngle: .pi / 2, endAngle: .pi, clockwise: true)

            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer

            // 内边框
            if let paddingColor = paddingColor, let paddingWidth = paddingWidth, let borderWidth = borderWidth {

                let paddingWidth_2 = paddingWidth / 2 + borderWidth
                let paddingPath = UIBezierPath()
                // 左上
                paddingPath.addArc(withCenter: topLeftCenter, radius: cornersRadius.topLeft - paddingWidth_2, startAngle: .pi, endAngle: .pi / 2 * 3, clockwise: true)
                // 右上
                paddingPath.addArc(withCenter: topRightCenter, radius: cornersRadius.topRight - paddingWidth_2, startAngle: .pi / 2 * 3, endAngle: 0, clockwise: true)
                // 右下
                paddingPath.addArc(withCenter: bottomRightCenterX, radius: cornersRadius.bottomRight - paddingWidth_2, startAngle: 0, endAngle: .pi / 2, clockwise: true)
                // 左下
                paddingPath.addArc(withCenter: bottomLeftCenter, radius: cornersRadius.bottomLeft - paddingWidth_2, startAngle: .pi / 2, endAngle: .pi, clockwise: true)

                paddingPath.close()

                let context = UIGraphicsGetCurrentContext()
                context?.addPath(paddingPath.cgPath)
                // 边框颜色
                context?.setStrokeColor(paddingColor.cgColor)
                // 边框宽度
                context?.setLineWidth(paddingWidth)
                context?.strokePath()
            }

            // 边框
            if let borderColor = borderColor, let borderWidth = borderWidth {
                let borderWidth_2 = borderWidth / 2
                let borderPath = UIBezierPath()
                // 左上
                borderPath.addArc(withCenter: topLeftCenter, radius: cornersRadius.topLeft - borderWidth_2, startAngle: .pi, endAngle: .pi / 2 * 3, clockwise: true)
                // 右上
                borderPath.addArc(withCenter: topRightCenter, radius: cornersRadius.topRight - borderWidth_2, startAngle: .pi / 2 * 3, endAngle: 0, clockwise: true)
                // 右下
                borderPath.addArc(withCenter: bottomRightCenterX, radius: cornersRadius.bottomRight - borderWidth_2, startAngle: 0, endAngle: .pi / 2, clockwise: true)
                // 左下
                borderPath.addArc(withCenter: bottomLeftCenter, radius: cornersRadius.bottomLeft - borderWidth_2, startAngle: .pi / 2, endAngle: .pi, clockwise: true)

                borderPath.close()

                let context = UIGraphicsGetCurrentContext()
                context?.addPath(borderPath.cgPath)
                // 边框颜色
                context?.setStrokeColor(borderColor.cgColor)
                // 边框宽度
                context?.setLineWidth(borderWidth)
                context?.strokePath()

            }else if let borderColors = borderColors, let borderWidth = borderWidth {

                let borderWidth_2 = borderWidth / 2

                let borderPath = UIBezierPath()
                // 左上
                borderPath.addArc(withCenter: topLeftCenter, radius: cornersRadius.topLeft - borderWidth_2, startAngle: .pi, endAngle: .pi / 2 * 3, clockwise: true)
                // 右上
                borderPath.addArc(withCenter: topRightCenter, radius: cornersRadius.topRight - borderWidth_2, startAngle: .pi / 2 * 3, endAngle: 0, clockwise: true)
                // 右下
                borderPath.addArc(withCenter: bottomRightCenterX, radius: cornersRadius.bottomRight - borderWidth_2, startAngle: 0, endAngle: .pi / 2, clockwise: true)
                // 左下
                borderPath.addArc(withCenter: bottomLeftCenter, radius: cornersRadius.bottomLeft - borderWidth_2, startAngle: .pi / 2, endAngle: .pi, clockwise: true)

                borderPath.close()

                let context = UIGraphicsGetCurrentContext()
                context?.addPath(borderPath.cgPath)
                // 边框宽度
                context?.setLineWidth(borderWidth)

                // 边框颜色
                let loc = 1.0 / CGFloat(borderColors.count - 1)
                var locations: [CGFloat] = []
                for i in 0 ..< borderColors.count {
                    locations.append(CGFloat(i) * loc)
                }

                if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: borderColors.map { $0.cgColor } as CFArray, locations: locations) {
                    context?.replacePathWithStrokedPath()
                    context?.clip()
                    context?.drawLinearGradient(gradient, start: CGPoint.zero, end: CGPoint(x: bounds.maxX, y: bounds.maxY), options: .drawsBeforeStartLocation)
                }else {
                    context?.setStrokeColor(UIColor.black.cgColor)
                }
                context?.strokePath()
            }
        }
    }
}

