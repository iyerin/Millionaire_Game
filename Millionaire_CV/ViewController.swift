//
//  ViewController.swift
//  Millionaire_CV
//
//  Created by Игорь on 03.05.19.
//  Copyright © 2019 Igor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var btnA: UIButton!
    @IBOutlet private weak var btnB: UIButton!
    @IBOutlet private weak var btnC: UIButton!
    @IBOutlet private weak var btnD: UIButton!
    @IBOutlet private weak var questionText: UILabel!
    @IBOutlet weak var afterAnswerView: UIView!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var fiftyFifty: UIButton!
    @IBOutlet weak var AskView: UIView!
    @IBOutlet weak var pbA: UIProgressView!
    @IBOutlet weak var pbB: UIProgressView!
    @IBOutlet weak var pbC: UIProgressView!
    @IBOutlet weak var pbD: UIProgressView!
    @IBOutlet weak var lblA: UILabel!
    @IBOutlet weak var lblB: UILabel!
    @IBOutlet weak var lblC: UILabel!
    @IBOutlet weak var lblD: UILabel!
    @IBOutlet weak var askAudience: UIButton!
    @IBOutlet weak var callFriendButton: UIButton!
    
    // MARK: - Properties
    private let questions = MyData.shared.questions
    private var qNbr = 0
    private var fiftyIsUsed = 0
        // TODO: - Refactoring
        // private var isFiftyUsed = false
    var answerButtons: [UIButton] {
        return [btnA, btnB, btnC, btnD]
    }
    
    var isSimulator: Bool {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return true
        #else
            return false
        #endif
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        AskView.isHidden = true
        afterAnswerView.isHidden = true
        showQuestionWithNbr(qNbr: 0)
        afterAnswerView.layer.cornerRadius = 10
        AskView.layer.cornerRadius = 10
        for btn in answerButtons {
            btn.layer.cornerRadius = 5
            btn.layer.masksToBounds = true
        }
    }
    
    // MARK: - Buttons actions
    @IBAction private func buttons(_ sender: UIButton) {
        if sender.tag == questions[qNbr].correctAns {
            nextQuestion(qNbr: qNbr, tag: sender.tag)
        } else {
            showIncorrectAlert(tag: sender.tag)
        }
    }
    
    @IBAction private func nextButton(_ sender: UIButton) {
        if (nextButton.currentTitle!) == "Продолжить" {
            afterAnswerView.isHidden = true
            self.qNbr += 1
            self.showQuestionWithNbr(qNbr: self.qNbr)
            //refreshBtnColors()
        } else if (nextButton.currentTitle == "OK") {
            afterAnswerView.isHidden = true
            callFriendButton.isEnabled = false
        } else {
            self.qNbr = 0
            
            // TODO: - renew hints
            
            self.showQuestionWithNbr(qNbr: self.qNbr)
            afterAnswerView.isHidden = true
        }
    }
    
    @IBAction private func fiftyFifty(_ sender: UIButton) {
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
    
    @IBAction private func askButton(_ sender: UIButton) {
        AskView.isHidden = true
    }
    
    @IBAction private func askAudience(_ sender: UIButton) {
        if fiftyIsUsed == 1 {
            askForTwo()
        } else {
            askForFour()
        }
        askAudience.isEnabled = false
    }
    
    @IBAction private func callFriend(_ sender: UIButton) {
        afterAnswerView.isHidden = false
        correctLabel.text = ""
        hintLabel.text = "Небывалая интерактивность! Позвони по номеру +38096-31-44-622 и получишь ответ!"
        self.nextButton.setTitle("ОК", for: .normal)
    }

    // MARK: - Methods
    
    private func askForTwo() {
        let lblArr = [lblA, lblB, lblC, lblD]
        var pbArr = [pbA, pbB, pbC, pbD]
        let randomVoteA = Int(arc4random_uniform(UInt32(60)) + UInt32(40))
        let randomVoteD = (100 - randomVoteA)
        for i in 0...3 {
            if answerButtons[i].isEnabled == false {
                lblArr[i]?.isHidden = true
                pbArr[i]?.isHidden = true
            } else {
                if answerButtons[i].tag == questions[qNbr].correctAns {
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
    
    private func askForFour() {
        let randomVoteA = Int(arc4random_uniform(UInt32(50)) + UInt32(35))
        let randomVoteB = Int(arc4random_uniform(UInt32(100 - randomVoteA)))
        let randomVoteC = Int(arc4random_uniform(UInt32(100 - randomVoteA - randomVoteB)))
        let randomVoteD = 100 - randomVoteA - randomVoteB - randomVoteC
        var voteArray = [randomVoteA, randomVoteB, randomVoteC, randomVoteD]
        
        var arrPB = [pbA, pbB, pbC, pbD]
        arrPB[questions[qNbr].correctAns]?.progress = Float(voteArray[0])/100
        arrPB.remove(at: questions[qNbr].correctAns)
        voteArray.remove(at: 0)
        
        // TODO: - For int
        
        for i in 0..<3 {
            arrPB[i]!.progress = Float(voteArray[i])/100
        }
        lblA.text = "A:  \(Int(pbA.progress * 100))%"
        lblB.text = "B:  \(Int(pbB.progress * 100))%"
        lblC.text = "C:  \(Int(pbC.progress * 100))%"
        lblD.text = "D:  \(Int(pbD.progress * 100))%"
        AskView.isHidden = false
    }

    private func nextQuestion(qNbr: Int, tag: Int) {
        if qNbr == questions.count - 1 {
            correctLabel.text = "Победа!"
            correctLabel.textColor = .red
            hintLabel.text = questions[qNbr].hintA
            self.nextButton.setTitle("Начать сначала", for: .normal)
        } else {
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
        }
        for btn in answerButtons {
            if btn.tag == tag {
                btn.backgroundColor = UIColor(red: 255/255, green: 83/255, blue: 13/255, alpha: 1)
                btn.blink(enabled: true, duration: 0.5, stopAfter: 1.5)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    btn.backgroundColor = UIColor(red: 4/255, green: 213/255, blue: 134/255, alpha: 1)
                    self.afterAnswerView.isHidden = false
                }
            }
        }
    }
    
    private func showIncorrectAlert(tag: Int) {
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
        for btn in answerButtons {
            if btn.tag == tag {
                btn.backgroundColor = UIColor(red: 255/255, green: 83/255, blue: 13/255, alpha: 1)
                btn.blink(enabled: true, duration: 0.5, stopAfter: 1.5)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    btn.backgroundColor = UIColor(red: 255/255, green: 29/255, blue: 32/255, alpha: 1)
                    self.afterAnswerView.isHidden = false
                }
            }
        }
    }
    
    private func showQuestionWithNbr(qNbr: Int) {
        self.btnA.setTitle(self.questions[qNbr].ansA, for: .normal)
        self.btnB.setTitle(self.questions[qNbr].ansB, for: .normal)
        self.btnC.setTitle(self.questions[qNbr].ansC, for: .normal)
        self.btnD.setTitle(self.questions[qNbr].ansD, for: .normal)
        questionText.text = questions[qNbr].text
        for btn in answerButtons {
            btn.backgroundColor = UIColor(red: 2/255, green: 53/255, blue: 143/255, alpha: 1)
            btn.isEnabled = true
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
    
   
}
