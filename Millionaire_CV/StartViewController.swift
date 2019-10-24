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
        helloLabel.text = "Привет! Меня зовут Игорь Ерин и сегодня я хочу сыграть с тобой в игру) В процессе игры ты узнаешь, что происходило со мной от рождения до сегодняшнего дня, и почему мое приложение сейчас на этом экране. Enjoy!"
    }
}
