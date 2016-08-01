//
//  ImageViewController.swift
//  Cassini
//
//  Created by Bell, Courtney on 7/19/16.
//  Copyright © 2016 Bell, Courtney. All rights reserved.
//

import UIKit    

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private func fetchImage(){
        if let url = imageURL {
            spinner?.startAnimating()
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED.rawValue)), 0)){
                let contentsOfURL = NSData(contentsOf: url as URL)
                DispatchQueue.main.async {
                    if url = self.imageURL{
                        if let imageData = contentsOfURL{
                            self.image = UIImage(data: imageData as Data)
                        }else{
                            self.spinner.stopAnimating()
                        }
                    }else{
                        print("ignored data returned from url \(url)")
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView?.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var imageView = UIImageView()

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil{
            fetchImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }

}
