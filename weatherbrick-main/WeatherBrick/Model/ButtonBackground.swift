//
//  GradientButtonBackground.swift
//  WeatherBrick
//
//  Created by Антон Заверуха on 11.08.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

struct ButtonBackground {
    func gradientBack(button: UIButton) {
        let firstColor = UIColor(displayP3Red: 255/255.0, green: 153/255.0, blue: 96/255.0, alpha: 1)
        let secondColor = UIColor(displayP3Red: 249/255.0, green: 80/255.0, blue: 27/255.0, alpha: 1)
        let gradient = CAGradientLayer()
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        gradient.frame = button.bounds
        button.layer.insertSublayer(gradient, at: 0)
    }

    func transparentBack(button: UIButton) {
        let cornerRadius: CGFloat = 15.5

        button.setTitle("Hide", for: UIControl.State.normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(displayP3Red: 87/255.0, green: 87/255.0, blue: 87/255.0, alpha: 1).cgColor
        button.layer.cornerRadius = cornerRadius
    }
}
