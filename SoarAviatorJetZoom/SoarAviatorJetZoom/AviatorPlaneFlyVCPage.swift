//
//  GameTwoViewController.swift
//  SoarAviatorJetZoom
//
//  Created by SoarAviatorJetZoom on 2024/11/29.
//


import UIKit
import SpriteKit

class AviatorPlaneFlyVCPage: UIViewController {
    var skView: SKView!
    var gameScene: AviatorGameSceneTwo!
   // var scoreLabel: UILabel!
    var energyLabel: UILabel!
    var healthLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGameView()
        setupUI()
    }

    func setupGameView() {
        skView = SKView(frame: view.bounds)
        skView.showsFPS = true
        skView.showsNodeCount = true
        view.addSubview(skView)

        gameScene = AviatorGameSceneTwo(size: view.bounds.size)
        gameScene.viewController = self  // Pass reference to the GameScene
        gameScene.scaleMode = .resizeFill
        skView.presentScene(gameScene)
    }

    func setupUI() {

        // Energy Label
        energyLabel = UILabel(frame: CGRect(x: 20, y: 120, width: 200, height: 40))
        energyLabel.text = "Energy: 100%"
        energyLabel.font = UIFont.systemFont(ofSize: 16)
        energyLabel.textColor = .white
        view.addSubview(energyLabel)

        // Health Label
        healthLabel = UILabel(frame: CGRect(x: 20, y: 180, width: 200, height: 40))
        healthLabel.text = "Health: 3"
        healthLabel.font = UIFont.boldSystemFont(ofSize: 16)
        healthLabel.textColor = .red
        view.addSubview(healthLabel)
        
     let backButton = UIButton(frame: CGRect(x: 24, y: 60, width: 100, height: 44))
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor(named: "appColor_black"), for: .normal)
        backButton.backgroundColor = .white
        backButton.addTarget(self, action: #selector(backButtonTapped(_ :)), for: .touchUpInside)
        backButton.clipsToBounds = true
        backButton.cornerRadius = 22
        view.addSubview(backButton)
    }
    
    @objc func backButtonTapped(_ sender : UIButton) {
        navigationController?.popViewController(animated: true)

    }

//    func updateScore(_ score: Int) {
//        scoreLabel.text = "Score: \(score)"
//    }
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func updateEnergy(_ energy: CGFloat) {
        energyLabel.text = "Energy: \(Int(energy))%"
        energyLabel.textColor = energy < 20 ? .red : .black
    }

    func updateHealth(_ health: Int) {
        healthLabel.text = "Health: \(health)"
    }
}
