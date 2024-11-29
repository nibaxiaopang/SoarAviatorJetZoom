//
//  ViewController.swift
//  SoarAviatorJetZoom
//
//  Created by jin fu on 2024/11/29.
//

import UIKit

class AviatorFlyPracticeVCPage: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var gameLabel: UILabel!
    
    var timer: Timer?
    var simonTimer: Timer?
    
    var timeInt: Int = 20
    var scoreInt: Int = 0
    var gameStatus: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.text = "Time: \(timeInt)"
        scoreLabel.text = "Score: \(scoreInt)"
        
        gameLabel.layer.cornerRadius = 20
        gameLabel.clipsToBounds = true
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        leftSwipe.direction = .left
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        rightSwipe.direction = .right
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        upSwipe.direction = .up
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        downSwipe.direction = .down
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        if timeInt == 20 {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            startButton.isEnabled = false
            startButton.alpha = 0.5
            gameStatus = 1
            says()
        } else if timeInt == 0 {
            timeInt = 20
            scoreInt = 0
            gameStatus = 0
            timeLabel.text = "Time: \(timeInt)"
            scoreLabel.text = "Score: \(scoreInt)"
            startButton.setTitle("Start Game", for: .normal)
            gameLabel.text = "Simon Says"
        }
    }
    
    @objc func updateTime() {
        timeInt -= 1
        timeLabel.text = "Time: \(timeInt)"
        
        if timeInt == 0 {
            timer?.invalidate()
            simonTimer?.invalidate()
            startButton.isEnabled = true
            startButton.alpha = 1.0
            startButton.setTitle("Restart", for: .normal)
            gameStatus = 0
        }
    }
    
    func says() {
        let actions = ["Swipe Left", "Swipe Right", "Swipe Up", "Swipe Down"]
        let randomAction = actions.randomElement() ?? "Swipe Left"
        gameLabel.text = randomAction
        
        simonTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(saysAgain), userInfo: nil, repeats: false)
    }
    
    @objc func saysAgain() {
        says()
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        guard gameStatus == 1 else { return }
        
        simonTimer?.invalidate()
        
        let direction: String
        switch sender.direction {
        case .left: direction = "Swipe Left"
        case .right: direction = "Swipe Right"
        case .up: direction = "Swipe Up"
        case .down: direction = "Swipe Down"
        default: return
        }
        
        if gameLabel.text == direction {
            scoreInt += 1
        } else {
            scoreInt -= 1
        }
        
        scoreLabel.text = "Score: \(scoreInt)"
        says()
    }
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

