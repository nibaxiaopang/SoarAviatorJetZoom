//
//  GameSceneTwo.swift
//  SoarAviatorJetZoom
//
//  Created by SoarAviatorJetZoom on 2024/11/29.
//


import SpriteKit

class AviatorGameSceneTwo: SKScene, SKPhysicsContactDelegate {
    var plane: SKSpriteNode!
    var score = 0
    var energy: CGFloat = 100
    var health = 3
    var isGameOver = false
    var viewController: AviatorPlaneFlyVCPage!
    var background1: SKSpriteNode!
    var background2: SKSpriteNode!

    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = .zero
        setupBackground()
        setupPlane()
        startObstacleSpawner()
    }

    func setupBackground() {
        background1 = SKSpriteNode(imageNamed: "bg2")
        background1.size = CGSize(width: size.width, height: size.height)
        background1.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(background1)

        background2 = SKSpriteNode(imageNamed: "bg2")
        background2.size = CGSize(width: size.width, height: size.height)
        background2.position = CGPoint(x: size.width * 1.5, y: size.height / 2)
        addChild(background2)

        let moveAction = SKAction.moveBy(x: -size.width, y: 0, duration: 0.3)
        let resetAction = SKAction.moveBy(x: size.width, y: 0, duration: 0)
        let sequence = SKAction.sequence([moveAction, resetAction])
        let repeatAction = SKAction.repeatForever(sequence)

        background1.run(repeatAction)
        background2.run(repeatAction)
    }

    func setupPlane() {
        plane = SKSpriteNode(imageNamed: "plane")
        plane.size = CGSize(width: 60, height: 60)
        plane.position = CGPoint(x: frame.width * 0.2, y: frame.height / 2)

        plane.physicsBody = SKPhysicsBody(rectangleOf: plane.size)
        plane.physicsBody?.categoryBitMask = AviatorPhysicsCategory.plane
        plane.physicsBody?.contactTestBitMask = AviatorPhysicsCategory.obstacle
        plane.physicsBody?.collisionBitMask = 0
        plane.physicsBody?.affectedByGravity = false

        addChild(plane)
    }

    func spawnObstacle() {
        let birdFrames: [SKTexture] = [
            SKTexture(imageNamed: "1"),
            SKTexture(imageNamed: "2"),
            SKTexture(imageNamed: "3"),
            SKTexture(imageNamed: "4")
        ]

        let obstacle = SKSpriteNode(texture: birdFrames[0])
        obstacle.size = CGSize(width: 70, height: 70)
        let randomY = CGFloat.random(in: 50...(frame.height - 50))
        obstacle.position = CGPoint(x: frame.width + obstacle.size.width, y: randomY)

        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.categoryBitMask = AviatorPhysicsCategory.obstacle
        obstacle.physicsBody?.contactTestBitMask = AviatorPhysicsCategory.plane
        obstacle.physicsBody?.collisionBitMask = 0
        obstacle.physicsBody?.affectedByGravity = false

        addChild(obstacle)

        let animation = SKAction.animate(with: birdFrames, timePerFrame: 0.1)
        let repeatAnimation = SKAction.repeatForever(animation)
        obstacle.run(repeatAnimation)

        let moveAction = SKAction.moveBy(x: -frame.width - obstacle.size.width, y: 0, duration: 4.0)
        let removeAction = SKAction.removeFromParent()
        obstacle.run(SKAction.sequence([moveAction, removeAction]))
    }

//    func increaseScore() {
//        score += 1
//        viewController.updateScore(score)
//    }

    func decreaseEnergy() {
        energy -= 10
        viewController.updateEnergy(energy)
    }

    func decreaseHealth() {
        health -= 1
        viewController.updateHealth(health)
    }

    func startObstacleSpawner() {
        let spawn = SKAction.run { [weak self] in
            self?.spawnObstacle()
        }
        let delay = SKAction.wait(forDuration: 2.0)
        run(SKAction.repeatForever(SKAction.sequence([spawn, delay])))
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if contactMask == (AviatorPhysicsCategory.plane | AviatorPhysicsCategory.obstacle) {
            handleCollision()
        }
    }

    func handleCollision() {
        isGameOver = true

        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(gameOverLabel)

        self.isPaused = true

        showGameOverAlert()
    }

    func showGameOverAlert() {
        let alert = UIAlertController(title: "Game Over", message: "Restart Game", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { [weak self] _ in
            self?.restartGame()
        }))
        alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: { [weak self] _ in
            self?.exitGame()
        }))
        viewController.present(alert, animated: true, completion: nil)
    }

    func restartGame() {
        score = 0
        energy = 100
        health = 3
       // viewController.updateScore(score)
        viewController.updateEnergy(energy)
        viewController.updateHealth(health)

        isGameOver = false
        self.isPaused = false
        removeAllChildren()
        setupBackground()
        setupPlane()
        startObstacleSpawner()
    }

    func exitGame() {
        viewController.navigationController?.popViewController(animated: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            if touchLocation.y > self.frame.midY {
                let moveUpAction = SKAction.moveBy(x: 0, y: 50, duration: 0.2)
                plane.run(moveUpAction)
            } else {
                let moveDownAction = SKAction.moveBy(x: 0, y: -50, duration: 0.2)
                plane.run(moveDownAction)
            }
        }
    }
}
