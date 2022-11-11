//
//  BrickImageSelection.swift
//  WeatherBrick
//
//  Created by Антон Заверуха on 08.08.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

class BrickImageSelection {
    func brickImageSelection(_ condition: String, _ weather: OpenWeatherAPIModel, imageView: UIImageView) -> UIImage {
        switch condition {
        case "Clouds":
            return UIImage(named: "image_stone_normal")!
        case "Fog":
            return UIImage(named: "image_stone_normal")!.setImageAlpha(alpha: 0.5)!
        case "Sunny":
            if weather.main.temp >= 30.0 {
                return UIImage(named: "image_stone_cracks")!
            } else {
                return UIImage(named: "image_stone_normal")!
            }
        case "Rain":
            return UIImage(named: "image_stone_wet")!
        case "Snow":
            return UIImage(named: "image_stone_snow")!
        default:
            if weather.main.temp >= 30.0 {
                return UIImage(named: "image_stone_cracks")!
            } else if weather.main.temp <= 29.9 {
                return UIImage(named: "image_stone_normal")!
            }
        }
        return UIImage(named: "image_stone_normal")!
    }
}

extension UIImage {
    func setImageAlpha(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
