//
//  InfoViewController.swift
//  WeatherBrick
//
//  Created by Антон Заверуха on 11.08.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    var transparentBack = ButtonBackground()

    @IBAction func hideButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        transparentBack.transparentBack(button: hideButton)
        infoView.layer.cornerRadius = 15.5
        backgroundView.layer.cornerRadius = 15.5
    }
}
