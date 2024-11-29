//
//  GameScene.swift
//  SoarAviatorJetZoom
//
//  Created by SoarAviatorJetZoom on 2024/11/29.
//

import SpriteKit
import GameplayKit

class AviatorGameScene: SKScene, SKPhysicsContactDelegate {
    let explosion = SKEmitterNode(fileNamed: "PlayerExplosion")
    let rockTexture = SKTexture(imageNamed: "rock")
    var rockPhysics: SKPhysicsBody!
    
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
  
    
    var logo: SKSpriteNode!
    var gameOver: SKSpriteNode!

    var gameState = AviatorGameState.showingLogo
    
    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    // Creating the content of the screen
    override func didMove(to view: SKView) {
        //rockPhysics = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        
        
        createPlayer()
        createSky()
        createBackground()
        createGround()
        createScore()
        createLogos()
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -4.0)
        physicsWorld.contactDelegate = self
    
   
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // put here to make sure that update isnt called when player is nil
        guard player != nil else { return }
        
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
        
        player.run(rotate)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .showingLogo:
            gameState = .playing
            
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let remove = SKAction.removeFromParent()
            let wait = SKAction.wait(forDuration: 0.5)
            let activatePlayer = SKAction.run { [unowned self] in
                self.player.physicsBody?.isDynamic = true
                self.startRocks()
            }
            
            let sequence = SKAction.sequence([fadeOut, wait, activatePlayer, remove])
            logo.run(sequence)
            
        case .playing:
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
        
        case .dead:
            if let scene = AviatorGameScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
                view?.presentScene(scene, transition: transition)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "scoreDetect" || contact.bodyB.node?.name == "scoreDetect" {
            if contact.bodyA.node == player {
                contact.bodyB.node?.removeFromParent()
            } else {
                contact.bodyA.node?.removeFromParent()
            }
            
            let sound = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
            run(sound)
            
            score += 1
            
            return
        }
        
        guard contact.bodyA.node != nil && contact.bodyB.node != nil else {
            return
        }
        
        if contact.bodyA.node == player || contact.bodyB.node == player {
            if let explosion = SKEmitterNode(fileNamed: "PlayerExplosion") {
                explosion.position = player.position
                addChild(explosion)
            }
            let sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
            run(sound)
            
            gameOver.alpha = 1
            gameState = .dead
            
            player.removeFromParent()
            speed = 0
        }
        
    }
    
    func createLogos() {
        logo = SKSpriteNode(imageNamed: "logo")
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(logo)
        
        gameOver = SKSpriteNode(imageNamed: "gameover")
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOver.alpha = 0
        addChild(gameOver)
    }
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        scoreLabel.fontSize = 24
        
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 60)
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontColor = UIColor.black
        
        addChild(scoreLabel)
    }
    
    func createPlayer() {
        // Initialize player textures from a GIF or fallback to image
        guard let gifTextures = SKTexture.textures(fromGif: "playerAnimation") else { return }
        
        // Set the first frame of the GIF as the initial texture for the player
        let initialTexture = gifTextures.first ?? SKTexture(imageNamed: "player-1")
        player = SKSpriteNode(texture: initialTexture)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 4, y: frame.height * 0.75)
        
        // Set custom height and width for the player
        player.size = CGSize(width: 100, height: 100) // Adjust the size as needed
        
        addChild(player)
        
        // Adding physics to the player; simulates real physics
        player.physicsBody = SKPhysicsBody(texture: initialTexture, alphaThreshold: 0.3, size: player.size)
        player.physicsBody?.contactTestBitMask = player.physicsBody?.collisionBitMask ?? 0
        player.physicsBody?.isDynamic = true
        player.physicsBody?.collisionBitMask = 0
        
        // Create animation from the GIF textures
        let animation = SKAction.animate(with: gifTextures, timePerFrame: 0.1, resize: false, restore: true)
        let runForever = SKAction.repeatForever(animation)
        
        player.run(runForever) // Repeat the animation forever
    }


    func createSky() {
        // initialize the sprites for both parts of the sky and set their anchor points (where they are located)
        let topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.67))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.33))
        bottomSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        topSky.position = CGPoint(x: frame.midX, y: frame.height)
        bottomSky.position = CGPoint(x: frame.midX, y: bottomSky.frame.height)
        
        addChild(topSky)
        addChild(bottomSky)
        
        // Make the sky appear as if far away
        bottomSky.zPosition = -40
        topSky.zPosition = -40
    }
    
    
    // Initializes a texture for the background and creates two background elements - each on opposi
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "background")
        backgroundTexture.filteringMode = .nearest

        // Define the desired width and height of the background
        let desiredWidth = UIScreen.main.bounds.width
        let desiredHeight = desiredWidth * 2.075
        
        let moveLeft = SKAction.moveBy(x: -desiredWidth, y: 0, duration: 2)
        let moveReset = SKAction.moveBy(x: desiredWidth, y: 0, duration: 0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)
        
        for i in 0 ..< 2 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -30
            background.anchorPoint = CGPoint.zero
            
            // Set the size of the background
            background.size = CGSize(width: desiredWidth, height: desiredHeight)
            
            // Position the background nodes horizontally
            if UIScreen.main.bounds.height < 800 {
                background.position = CGPoint(x: desiredWidth * CGFloat(i), y: -desiredHeight / 7)
            } else {
                background.position = CGPoint(x: desiredWidth * CGFloat(i), y: -desiredHeight / 5)
            }
            
            addChild(background)
            
            // Create actions for scrolling

            
            // Run the scrolling animation
            background.run(moveForever)
        }
    }

    
    func createGround() {
        let groundTexture = SKTexture(imageNamed: "ground")
        let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 2)
        let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
        
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)
        for i in 0 ..< 2 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10
            ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 2)
            
            // Pixel perfect collision; respond when plane hits the ground but won't be moved itself
            ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
            ground.physicsBody?.isDynamic = false
            
            addChild(ground)
            

            
            ground.run(moveForever)
        }
    }
    
    func startRocks() {
        // closure to run createrocks
        let create = SKAction.run { [unowned self] in
            self.createRocks()
        }
        
        let wait = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        
        run(repeatForever)
    }
    
    func createRocks() {
        // Creating the rock sprites, one rotated at the top, the other regular at the bottom.
        let rockTexture = SKTexture(imageNamed: "rock")
        
        let topRock = SKSpriteNode(texture: rockTexture)
        topRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        topRock.physicsBody?.isDynamic = false
        
        topRock.zRotation = .pi
        topRock.xScale = -1.0
        
        let bottomRock = SKSpriteNode(texture: rockTexture)
        bottomRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        bottomRock.physicsBody?.isDynamic = false
       

        topRock.zPosition = -20
        bottomRock.zPosition = -20
        
        // Create small rectangle to track the collision
        let rockCollision = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 32, height: frame.height))
        rockCollision.physicsBody = SKPhysicsBody(rectangleOf: rockCollision.size)
        rockCollision.physicsBody?.isDynamic = false
        rockCollision.name = "scoreDetect"
        
        addChild(topRock)
        addChild(bottomRock)
        addChild(rockCollision)
        
        // Use random number generator to choose a position for the safe area
        let xPosition = frame.width + (topRock.frame.width)
        
        let max = CGFloat(frame.height / 3)
        let yPosition = CGFloat.random(in: -50...max)
        
        let rockDistance: CGFloat = 70
        
        // Position the rocks at the right end of the screen and animate them left
        // remove them when they are safely off the screen
        topRock.position = CGPoint(x: xPosition, y: yPosition + topRock.size.height + rockDistance)
        bottomRock.position = CGPoint(x: xPosition, y: yPosition - rockDistance)
        rockCollision.position = CGPoint(x: xPosition + (rockCollision.size.width * 2), y: frame.midY)
        
        let endPosition = frame.width + (topRock.frame.width * 2)
        
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6.2)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        
        topRock.run(moveSequence)
        bottomRock.run(moveSequence)
        rockCollision.run(moveSequence)
    }
    
}
