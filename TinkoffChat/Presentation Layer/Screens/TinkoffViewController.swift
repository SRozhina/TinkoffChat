//
//  TinkoffViewController.swift
//  TinkoffChat
//
//  Created by Sofia on 30/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import UIKit

class TinkoffViewController: UIViewController {
    private var pan: UIPanGestureRecognizer!
    private var tap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPanGestureRecognizer()
    }
    
    private func addPanGestureRecognizer() {
        pan = UIPanGestureRecognizer(target: self, action: #selector(handleGestureRecognizer))
        tap = UITapGestureRecognizer(target: self, action: #selector(handleGestureRecognizer))
        view.addGestureRecognizer(pan)
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func handleGestureRecognizer(_ recognizer: UIGestureRecognizer) {
        let animationRectSize: CGFloat = 150
        let imageStartSize: CGFloat = 15
        let location = recognizer.location(in: view)
        let image = UIImage(named: "logo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageStartSize, height: imageStartSize))
        imageView.center = location
        imageView.image = image
        view.addSubview(imageView)
        let animationRect = CGRect(x: location.x - animationRectSize / 2,
                                   y: location.y - animationRectSize / 2,
                                   width: animationRectSize,
                                   height: animationRectSize)
        var endPoint = animationRect.origin
        endPoint.x += CGFloat(arc4random_uniform(UInt32(animationRectSize)))
        endPoint.y += CGFloat(arc4random_uniform(UInt32(animationRectSize)))
        
        UIView.animate(withDuration: 1,
                       animations: {
                        imageView.center = endPoint
                        imageView.alpha = 0
                        imageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        },
                       completion: { _ in
                        imageView.removeFromSuperview()
        })
    }
    
    func removeTinkoffPanGesture() {
        view.removeGestureRecognizer(pan)
    }
    
    func removeTinkoffTapGesture() {
        view.removeGestureRecognizer(tap)
    }
}
