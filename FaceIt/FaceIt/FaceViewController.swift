//
//  ViewController.swift
//  FaceIt
//
//  Created by Bell, Courtney on 7/18/16.
//  Copyright © 2016 Bell, Courtney. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    var expression = FacialExpression(eyes: .Closed, eyeBrows: .Relaxed, mouth: .Smirk){ didSet{ updateUI() }}
    
    @IBOutlet weak var faceView: FaceView!{
        didSet
        {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView, action: #selector(FaceView.changeScale(recognizer:))
            ))
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.increaseHappiness)
            )
            let sadderSwiperGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.decreaseHappiness)
            )
            happierSwipeGestureRecognizer.direction = .up
            sadderSwiperGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            faceView.addGestureRecognizer(sadderSwiperGestureRecognizer)
            updateUI()
        }
    }
    
    @IBAction func toggleEyes(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended{
            switch expression.eyes{
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
        }
    }
    
    func increaseHappiness()
    {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    func decreaseHappiness()
    {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown: -1.0,.Grin: 0.5,.Smile: 1.0,.Smirk: -0.5,.Neutral: 0.0]
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed: 0.5, .Furrowed: -0.5, .Normal: 0.0]
    
    private func updateUI()
    {
        if faceView != nil{
            switch expression.eyes{
            case .Open: faceView.eyesOpen = true
            case .Closed: faceView.eyesOpen = false
            case .Squinting: faceView.eyesOpen = false
            }
     
        
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
    
           }
    }
 
}

