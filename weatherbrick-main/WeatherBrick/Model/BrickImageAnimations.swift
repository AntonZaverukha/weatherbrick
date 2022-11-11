//
//  BrickImageAnimations.swift
//  WeatherBrick
//
//  Created by Антон Заверуха on 13.08.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

struct BrickImageAnimations {
    func animateBrickImageView(imageView: UIImageView, brickImage: UIImage) {
        imageView.image = brickImage
        imageView.setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0))
        imageView.rotate()
    }
}

extension UIImageView {
    func rotate() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = NSNumber(value: Double.pi * -0.1)
        rotation.toValue = NSNumber(value: Double.pi * 0.1)
        rotation.duration = 2.3
        rotation.repeatCount = Float.greatestFiniteMagnitude
        rotation.autoreverses = true
        self.layer.add(rotation, forKey: "rotationAnimation")
    }

    func setAnchorPoint(anchorPoint: CGPoint) {
        var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x,
                               y: self.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x,
                               y: self.bounds.size.height * self.layer.anchorPoint.y)

        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)

        var position: CGPoint = self.layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        self.translatesAutoresizingMaskIntoConstraints = true
        self.layer.position = position
        self.layer.anchorPoint = anchorPoint
    }

    func imageDownAndUp() {
        let action = CABasicAnimation(keyPath: "position")

        action.isAdditive = true
        action.fromValue = NSValue(cgPoint: CGPoint.zero)
        action.toValue = NSValue(cgPoint: CGPoint(x: 0.0, y: 70.0))
        action.autoreverses = true
        action.duration = 0.33
        action.repeatCount = 1

        self.layer.add(action, forKey: "animation")
    }
}
