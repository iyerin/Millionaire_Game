//
//  StartViewController.swift
//  Millionaire_CV
//
//  Created by Игорь on 03.05.19.
//  Copyright © 2019 Igor. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.layer.borderColor = UIColor.white.cgColor
        
        startButton.layer.borderWidth = 0.9
        startButton.layer.cornerRadius = 15
        helloLabel.text = ""
    }
}
