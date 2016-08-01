//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Bell, Courtney on 7/19/16.
//  Copyright © 2016 Bell, Courtney. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {
    
    private let emotionalFaces: Dictionary<String, FacialExpression> = [
        "Show Anger" : FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Frown),
        "Show Happy" : FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
        "Show Worry" : FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smirk),
        "Show Mischevious" : FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin)
    ]
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationvc = segue.destinationViewController
        if let navcon = destinationvc as? UINavigationController{
                destinationvc = navcon.visibleViewController ?? destinationvc
        }
        if let facevc = destinationvc as? FaceViewController{
            if let identifier = segue.identifier{
                if let expression = emotionalFaces[identifier] {
                    facevc.expression = expression
                    if let sendingButton = sender as? UIButton{
                        facevc.navigationItem.title = sendingButton.currentTitle
                    }
                }
            }
        }
    }

}
