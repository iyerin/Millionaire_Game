//
//  ViewController.swift
//  Millionaire_CV
//
//  Created by Игорь on 03.05.19.
//  Copyright © 2019 Igor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var questions = MyData.shared.questions
    var qNbr = 0
    var fiftyIsUsed = 0
    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var btnD: UIButton!
    @IBOutlet weak var questionText: UILabel!
    
    @IBAction func buttons(_ sender: UIButton) {
        if sender.tag == questions[qNbr].correctAns {
            nextQuestion(qNbr: qNbr, tag: sender.tag)
        } else {
            showIncorrectAlert(tag: sender.tag)
        }
    }
    
    @IBOutlet weak var afterAnswerView: UIView!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButton(_ sender: UIButton) {
        if (nextButton.currentTitle!) == "Продолжить" {
            afterAnswerView.isHidden = true
            self.qNbr += 1
            self.showQuestionWithNbr(qNbr: self.qNbr)
            //refreshBtnColors()
        } else {
            self.qNbr = 0
//renew hints
            self.showQuestionWithNbr(qNbr: self.qNbr)
            afterAnswerView.isHidden = true
        }
    }
    
    @IBOutlet weak var fiftyFifty: UIButton!
    @IBAction func fiftyFifty(_ sender: UIButton) {
        fiftyFifty.isEnabled = false
        var arr = [btnA, btnB, btnC, btnD]
        arr.remove(at: questions[qNbr].correctAns)
        let randomIndex = Int(arc4random_uniform(UInt32(3)))
        arr.remove(at: randomIndex)
        for btn in arr {
            btn?.isEnabled = false
            btn?.setTitle("", for: .normal)
        }
        fiftyIsUsed = 1
    }
    
    @IBOutlet weak var AskView: UIView!
    @IBOutlet weak var pbA: UIProgressView!
    @IBOutlet weak var pbB: UIProgressView!
    @IBOutlet weak var pbC: UIProgressView!
    @IBOutlet weak var pbD: UIProgressView!
    @IBOutlet weak var lblA: UILabel!
    @IBOutlet weak var lblB: UILabel!
    @IBOutlet weak var lblC: UILabel!
    @IBOutlet weak var lblD: UILabel!
    @IBAction func askButton(_ sender: UIButton) {
        AskView.isHidden = true
    }
    @IBOutlet weak var askAudience: UIButton!
    
    func askForTwo() {
        let btnArr = [btnA, btnB, btnC, btnD]
        let lblArr = [lblA, lblB, lblC, lblD]
        var pbArr = [pbA, pbB, pbC, pbD]
        let randomVoteA = Int(arc4random_uniform(UInt32(60)) + UInt32(40))
        let randomVoteD = (100 - randomVoteA)
        for i in 0...3 {
            if btnArr[i]?.isEnabled == false {
                lblArr[i]?.isHidden = true
                pbArr[i]?.isHidden = true
            } else {
                if btnArr[i]?.tag == questions[qNbr].correctAns {
                    pbArr[i]?.progress = Float(randomVoteA)/100
                    lblArr[i]?.text = "\(Int((pbArr[i]?.progress)! * 100))%"
                } else {
                    pbArr[i]?.progress = Float(randomVoteD)/100
                    lblArr[i]?.text = "\(Int((pbArr[i]?.progress)! * 100))%"
                }
            }
        }
        lblA.text = "A: " + lblA.text!
        lblB.text = "B: " + lblB.text!
        lblC.text = "C: " + lblC.text!
        lblD.text = "D: " + lblD.text!
        AskView.isHidden = false
    }
    func askForFour() {
        let randomVoteA = Int(arc4random_uniform(UInt32(50)) + UInt32(35))
        let randomVoteB = Int(arc4random_uniform(UInt32(100 - randomVoteA)))
        let randomVoteC = Int(arc4random_uniform(UInt32(100 - randomVoteA - randomVoteB)))
        let randomVoteD = (100 - randomVoteA - randomVoteB - randomVoteC)
        var voteArray = [randomVoteA, randomVoteB, randomVoteC, randomVoteD]
        
        var arrPB = [pbA, pbB, pbC, pbD]
        arrPB[questions[qNbr].correctAns]?.progress = Float(voteArray[0])/100
        arrPB.remove(at: questions[qNbr].correctAns)
        voteArray.remove(at: 0)
        for i in 0..<3 {
            arrPB[i]!.progress = Float(voteArray[i])/100
        }
        lblA.text = "A:  \(Int(pbA.progress * 100))%"
        lblB.text = "B:  \(Int(pbB.progress * 100))%"
        lblC.text = "C:  \(Int(pbC.progress * 100))%"
        lblD.text = "D:  \(Int(pbD.progress * 100))%"
        AskView.isHidden = false
    }
    @IBAction func askAudience(_ sender: UIButton) {
        if fiftyIsUsed == 1 {
            askForTwo()
        } else {
            askForFour()
        }
       askAudience.isEnabled = false
    }

    @IBAction func callFriend(_ sender: UIButton) {

        //let cleanPhoneNumber = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
//        let urlString:String = "tel://+380963144622"
//
//        if let phoneCallURL = URL(string: urlString) {
//            if (UIApplication.shared.canOpenURL(phoneCallURL)) {
//                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
//            }
//        }
    }
    
    func nextQuestion(qNbr: Int, tag: Int) {
        if qNbr == questions.count - 1 {
            correctLabel.text = "Победа!"
            correctLabel.textColor = .red
            hintLabel.text = questions[qNbr].hintA
            self.nextButton.setTitle("Начать сначала", for: .normal)
            let btnArr = [btnA, btnB, btnC, btnD]
            for btn in btnArr {
                if btn?.tag == tag {
                    btn?.backgroundColor = UIColor(red: 255/255, green: 83/255, blue: 13/255, alpha: 1)
                    btn?.blink(enabled: true, duration: 0.5, stopAfter: 1.5)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        btn?.backgroundColor = UIColor(red: 4/255, green: 213/255, blue: 134/255, alpha: 1)
                        self.afterAnswerView.isHidden = false
                    }
                }
            }
            return
        }
        correctLabel.text = "Правильно!"
        switch tag {
        case 0:
            hintLabel.text = questions[qNbr].hintA
        case 1:
            hintLabel.text = questions[qNbr].hintB
        case 2:
            hintLabel.text = questions[qNbr].hintC
        default:
            hintLabel.text = questions[qNbr].hintD
        }
        self.nextButton.setTitle("Продолжить", for: .normal)
        let btnArr = [btnA, btnB, btnC, btnD]
        for btn in btnArr {
            if btn?.tag == tag {
                btn?.backgroundColor = UIColor(red: 255/255, green: 83/255, blue: 13/255, alpha: 1)
                btn?.blink(enabled: true, duration: 0.5, stopAfter: 1.5)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    btn?.backgroundColor = UIColor(red: 4/255, green: 213/255, blue: 134/255, alpha: 1)
                    self.afterAnswerView.isHidden = false
                }
            }
        }
/*
 зеленый
 4
 213
 134
 
 оранжевй
 255
 83
 13
 
 красный
 255
 29
 32
*/
    }
    
    func showIncorrectAlert(tag: Int) {
        correctLabel.text = "Неправильно!"
        switch tag {
        case 0:
            hintLabel.text = questions[qNbr].hintA
        case 1:
            hintLabel.text = questions[qNbr].hintB
        case 2:
            hintLabel.text = questions[qNbr].hintC
        default:
            hintLabel.text = questions[qNbr].hintD
        }
        self.nextButton.setTitle("Начать сначала", for: .normal)
       // afterAnswerView.isHidden = false
        let btnArr = [btnA, btnB, btnC, btnD]
        for btn in btnArr {
            if btn?.tag == tag {
                btn?.backgroundColor = UIColor(red: 255/255, green: 83/255, blue: 13/255, alpha: 1)
                btn?.blink(enabled: true, duration: 0.5, stopAfter: 1.5)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    btn?.backgroundColor = UIColor(red: 255/255, green: 29/255, blue: 32/255, alpha: 1)
                    self.afterAnswerView.isHidden = false
                }
            }
        }
    }
    
    func showQuestionWithNbr(qNbr: Int) {
        self.btnA.setTitle(self.questions[qNbr].ansA, for: .normal)
        self.btnB.setTitle(self.questions[qNbr].ansB, for: .normal)
        self.btnC.setTitle(self.questions[qNbr].ansC, for: .normal)
        self.btnD.setTitle(self.questions[qNbr].ansD, for: .normal)
        questionText.text = questions[qNbr].text
        let btnArr = [btnA, btnB, btnC, btnD]
        for btn in btnArr {
            btn?.backgroundColor = UIColor(red: 2/255, green: 53/255, blue: 143/255, alpha: 1)
            btn?.isEnabled = true
        }
        if qNbr == 0 {
            fiftyIsUsed = 0
            askAudience.isEnabled = true
            fiftyFifty.isEnabled = true
            let lblArr = [lblA, lblB, lblC, lblD]
            var pbArr = [pbA, pbB, pbC, pbD]
            for i in 0...3 {
                lblArr[i]!.isHidden = false
                pbArr[i]!.isHidden = false
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        AskView.isHidden = true
        afterAnswerView.isHidden = true
        showQuestionWithNbr(qNbr: 0)
        
    }

}

extension UIButton {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self.bounds.contains(point) ? self : nil
    }
    func blink(enabled: Bool = true, duration: CFTimeInterval = 1.0, stopAfter: CFTimeInterval = 0.0 ) {
        enabled ? (UIView.animate(withDuration: duration, //Time duration you want,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 0.0 },
            completion: { [weak self] _ in self?.alpha = 1.0 })) : self.layer.removeAllAnimations()
        if !stopAfter.isEqual(to: 0.0) && enabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + stopAfter) { [weak self] in
                self?.layer.removeAllAnimations()
            }
        }
    }
}

//        let alert = UIAlertController(title:"Correct!", message: questions[qNbr].hint, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Next Question!", style: .default, handler: {
//            action in
//            self.qNbr += 1
//            self.showQuestionWithNbr(qNbr: self.qNbr)
//        }))
//        self.present(alert, animated: true, completion: nil)

//        let alert = UIAlertController(title:"Incorrect!", message: q1.hint, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Restart!", style: .default, handler: {
//          _ in
//            self.qNbr = 0
////renew hints
//            self.showQuestionWithNbr(qNbr: self.qNbr)
//        }))
//        self.present(alert, animated: true, completion: nil)


//func nextQuestion(qNbr: Int) {
//    let alert = UIAlertController(title:"Correct!", message: questions[qNbr].hint, preferredStyle: .alert)
//    alert.addAction(UIAlertAction(title: "Next Question!", style: .default, handler: {
//        action in
//        self.qNbr += 1
//        self.showQuestionWithNbr(qNbr: qNbr)
//    }))
//    self.present(alert, animated: true, completion: nil)
//
//}
//func showFirstQuestion() {
//    view.backgroundColor = .yellow
//    questionText.text = q1.text
//    btnA.setTitle(q1.ansA, for: .normal)
//    btnB.setTitle(q1.ansB, for: .normal)
//    btnC.setTitle(q1.ansC, for: .normal)
//    btnD.setTitle(q1.ansD, for: .normal)
//}
//        if (sender.tag == 1) {
//            view.backgroundColor = .red
//        } else {
//            view.backgroundColor = .blue
//            sender.setTitle("rara", for: .normal)
//        }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showStartScreen" {
//            let vc = segue.destination as! StartViewController
//        }
//    }

//        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction))
//        btnA.isUserInteractionEnabled = true
//        btnA.addGestureRecognizer(tap)
//        btnB.isUserInteractionEnabled = true
//        btnB.addGestureRecognizer(tap)
//    }

//    @objc func tapFunction(sender:UITapGestureRecognizer) {
//
//        print("tap working")
