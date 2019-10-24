//
//  ViewController.swift
//  Millionaire_CV
//
//  Created by Игорь on 03.05.19.
//  Copyright © 2019 Igor. All rights reserved.
//

import UIKit


/*TODO
1) phone call - imagine friend
2) hint labels
3) ending - wrong hint
 4) question randomizer
 5) game progress
 6) reorginize labels maybe with code
*/
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
    private var questions = MyData.shared.questions
    private var qNbr = 0
    private var currentQuestion = 0
    private var isFiftyUsed = false
    private var isAskUsed = false
    private var isCallUsed = false
    private var isFiftyUsedNow = false
    var answerButtons: [UIButton] {
        return [btnA, btnB, btnC, btnD]
    }
    var hintButtons: [UIButton] {
        return [askAudience, callFriendButton, fiftyFifty]
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //let questions = MyData.shared.questions
        AskView.isHidden = true
        afterAnswerView.isHidden = true
        //showQuestionWithNbr(qNbr: 0)
        showNextQuestion(qNbr: 0)
        qNbr = 0
        afterAnswerView.layer.cornerRadius = 10
        AskView.layer.cornerRadius = 10
        for btn in answerButtons {
            btn.layer.cornerRadius = 5
            btn.layer.masksToBounds = true
        }
    }
    
    // MARK: - Buttons actions
    @IBAction private func buttons(_ sender: UIButton) {
        if sender.tag == questions[currentQuestion].correctAns {
            nextQuestion(qNbr: qNbr, tag: sender.tag)
        } else {
            showIncorrectAlert(tag: sender.tag)
        }
    }
    
    @IBAction private func nextButton(_ sender: UIButton) {
        if (nextButton.currentTitle!) == "Продолжить" {
            afterAnswerView.isHidden = true
            self.qNbr += 1
            self.showNextQuestion(qNbr: self.qNbr)
        } else if (nextButton.currentTitle == "OK") {
            performSegue(withIdentifier: "showFinalVC", sender: nil)
            afterAnswerView.isHidden = true
        } else if (nextButton.currentTitle == "Wow!") {
            afterAnswerView.isHidden = true
        } else {
            self.qNbr = 0
            self.showNextQuestion(qNbr: self.qNbr)
            afterAnswerView.isHidden = true
        }
        unblockButtons()
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
        isFiftyUsedNow = true
        isFiftyUsed = true
    }
    
    @IBAction private func askButton(_ sender: UIButton) {
        AskView.isHidden = true
        unblockButtons()
    }
    
    @IBAction private func askAudience(_ sender: UIButton) {
        if isFiftyUsedNow == true {
            askForTwo()
        } else {
            askForFour()
        }
        askAudience.isEnabled = false
        isAskUsed = true
        blockButtons()
    }
    
    @IBAction private func callFriend(_ sender: UIButton) {
        afterAnswerView.isHidden = false
        correctLabel.text = ""
        hintLabel.text = "Небывалая интерактивность! Позвони по номеру +38096-31-44-622 и получишь ответ!"
        self.nextButton.setTitle("Wow!", for: .normal)
        callFriendButton.isEnabled = false
        isCallUsed = true
        blockButtons()
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
        if qNbr == 3/*questions.count - 1*/ {
            correctLabel.text = "Победа!"
            correctLabel.textColor = .red
            //hintLabel.text = questions[qNbr].hintB
            self.nextButton.setTitle("OK", for: .normal)
        } else {
            correctLabel.text = "Правильно!"
//            switch tag {
//            case 0:
//                hintLabel.text = questions[qNbr].hintA
//            case 1:
//                hintLabel.text = questions[qNbr].hintB
//            case 2:
//                hintLabel.text = questions[qNbr].hintC
//            default:
//                hintLabel.text = questions[qNbr].hintD
//            }
            self.nextButton.setTitle("Продолжить", for: .normal)
        }
        for btn in answerButtons {
            if btn.tag == tag {
                btn.backgroundColor = UIColor(red: 255/255, green: 83/255, blue: 13/255, alpha: 1)
                btn.blink(enabled: true, duration: 0.5, stopAfter: 1.5)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    btn.backgroundColor = UIColor(red: 4/255, green: 213/255, blue: 134/255, alpha: 1)
                    self.afterAnswerView.isHidden = false
                    self.blockButtons()
                }
            }
        }
    }
    
    private func blockButtons () {
        let allButtons = answerButtons + hintButtons
        for btn in allButtons {
            btn.isEnabled = false
        }
    }
    
    private func unblockButtons () {
        for btn in answerButtons {
            btn.isEnabled = true
        }
        if isFiftyUsed == false {
            fiftyFifty.isEnabled = true
        }
        if isAskUsed == false {
            askAudience.isEnabled = true
        }
        if isCallUsed == false {
            callFriendButton.isEnabled = true
        }
    }
    private func showIncorrectAlert(tag: Int) {
        correctLabel.text = "Неправильно!"
//        switch tag {
//        case 0:
//            hintLabel.text = questions[qNbr].hintA
//        case 1:
//            hintLabel.text = questions[qNbr].hintB
//        case 2:
//            hintLabel.text = questions[qNbr].hintC
//        default:
//            hintLabel.text = questions[qNbr].hintD
//        }
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
        blockButtons()
    }
    
    private func showNextQuestion(qNbr: Int) {
        let index = Int(arc4random_uniform(UInt32(questions.count - 1)))
        self.currentQuestion = index
        self.btnA.setTitle(self.questions[index].ansA, for: .normal)
        self.btnB.setTitle(self.questions[index].ansB, for: .normal)
        self.btnC.setTitle(self.questions[index].ansC, for: .normal)
        self.btnD.setTitle(self.questions[index].ansD, for: .normal)
        questionText.text = questions[index].text
        for btn in answerButtons {
            btn.backgroundColor = UIColor(red: 2/255, green: 53/255, blue: 143/255, alpha: 1)
            btn.isEnabled = true
        }
        isFiftyUsedNow = false
        if qNbr == 0 {
            isFiftyUsed = false
            isAskUsed = false
            isCallUsed = false
            askAudience.isEnabled = true
            fiftyFifty.isEnabled = true
            callFriendButton.isEnabled = true
            let lblArr = [lblA, lblB, lblC, lblD]
            var pbArr = [pbA, pbB, pbC, pbD]
            for i in 0...3 {
                lblArr[i]!.isHidden = false
                pbArr[i]!.isHidden = false
            }
        }
        print (questions.count)
        questions.remove(at: index)
        print (questions.count)
    }
    
//    private func showQuestionWithNbr(qNbr: Int) {
//        self.btnA.setTitle(self.questions[qNbr].ansA, for: .normal)
//        self.btnB.setTitle(self.questions[qNbr].ansB, for: .normal)
//        self.btnC.setTitle(self.questions[qNbr].ansC, for: .normal)
//        self.btnD.setTitle(self.questions[qNbr].ansD, for: .normal)
//        questionText.text = questions[qNbr].text
//        for btn in answerButtons {
//            btn.backgroundColor = UIColor(red: 2/255, green: 53/255, blue: 143/255, alpha: 1)
//            btn.isEnabled = true
//        }
//        isFiftyUsedNow = false
//        if qNbr == 0 {
//            isFiftyUsed = false
//            isAskUsed = false
//            isCallUsed = false
//            askAudience.isEnabled = true
//            fiftyFifty.isEnabled = true
//            callFriendButton.isEnabled = true
//            let lblArr = [lblA, lblB, lblC, lblD]
//            var pbArr = [pbA, pbB, pbC, pbD]
//            for i in 0...3 {
//                lblArr[i]!.isHidden = false
//                pbArr[i]!.isHidden = false
//            }
//        }
//    }
}
