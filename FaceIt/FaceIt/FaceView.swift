//
//  FaceView.swift
//  FaceIt
//
//  Created by Bell, Courtney on 7/18/16.
//  Copyright © 2016 Bell, Courtney. All rights reserved.
//

import UIKit
@IBDesignable
class FaceView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() }}
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() }}
    @IBInspectable
    var color: UIColor = UIColor.blue() { didSet { setNeedsDisplay() }}
    @IBInspectable
    var mouthCurvature: Double = -1.0{ didSet { setNeedsDisplay() }} //1 full smill -1 full frown
    @IBInspectable
    var eyesOpen: Bool = false { didSet { setNeedsDisplay() }}
    @IBInspectable
    var eyeBrowTilt: Double = -0.5 { didSet { setNeedsDisplay() }} //-1 full furrow 1 fully relaxed
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed,.ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    private var skullRadius: CGFloat{
            return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private var skullCenter: CGPoint{
            return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private struct Ratios{
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
        static let SkullRadiusToBrowOffset: CGFloat = 5
    }
    
    private enum Eye{
        case Right
        case Left
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint
    {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye{
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        
        return eyeCenter
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath
    {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)
        if eyesOpen{
            return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
        }else{
            let path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            path.lineWidth = lineWidth
            return path
        }
        
    }
    
    private func pathForBrow(eye: Eye) -> UIBezierPath
    {
        var tilt = eyeBrowTilt
        switch eye{
        case .Left: tilt *= -1.0
        case .Right: break
        }
        var browCenter = getEyeCenter(eye: eye)
        browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffset
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForMouth() -> UIBezierPath
    {
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width/3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width/3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI),
            clockwise: false)
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect){
        
        let skull = pathForCircleCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius)
        color.set()
        skull.stroke()
        pathForEye(eye: .Left).stroke()
        pathForEye(eye: .Right).stroke()
        pathForMouth().stroke()
        pathForBrow(eye: .Left).stroke()
        pathForBrow(eye: .Right).stroke()
        
    }

}
