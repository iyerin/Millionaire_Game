//
//  FinalViewController.swift
//  Millionaire_CV
//
//  Created by Игорь on 05.05.19.
//  Copyright © 2019 Igor. All rights reserved.
//

import UIKit

class FinalViewController: UIViewController {

    @IBOutlet weak var text: UILabel!
    
    @IBOutlet weak var oneMoreButton: UIButton!
    @IBAction func oneMore(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        text.text = "Поздравляю! Спасибо за участие в игре, надеюсь, все понравилось. Если хочешь увидеть смешные комментарии к другим ответам - просто нажми кнопку"
        let myGif = UIImage.gifImageWithName("1234")
        let imageView = UIImageView(image: myGif)
        imageView.frame = CGRect(x: 20.0, y: 50.0, width: self.view.frame.size.width - 40, height: 150.0)
        view.addSubview(imageView)
    }

    

}
