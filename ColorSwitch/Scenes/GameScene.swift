//
//  GameScene.swift
//  ColorSwitch
//
//  Created by Elias Myronidis on 05/03/2019.
//  Copyright © 2019 Elias Myronidis. All rights reserved.
//

import SpriteKit

enum PlayColors {
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}

enum SwitchState: Int {
    case red, yellow, green, blue
}

class GameScene: SKScene {
    
    var ball: SKSpriteNode!
    var switchState = SwitchState.red
    var currentColorIndex: Int?
    var score = 0
    var defaultGravity = -2.0
    
    lazy var colorSwitch: SKSpriteNode = {
        let spriteNode = SKSpriteNode(imageNamed: "ColorSwitch")
        spriteNode.size = CGSize(width: frame.size.width / 3, height: frame.size.width / 3)
        spriteNode.position = CGPoint(x: frame.midX, y: frame.minY + spriteNode.size.height)
        spriteNode.zPosition = ZPositions.colorSwitch
        spriteNode.physicsBody = SKPhysicsBody(circleOfRadius: spriteNode.size.width / 2)
        spriteNode.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        spriteNode.physicsBody?.isDynamic = false
        
        return spriteNode
    }()
    
    lazy var scoreLabel: SKLabelNode = {
        let labelNode = SKLabelNode(text: "0")
        labelNode.fontName = "AvenirNext-Bold"
        labelNode.fontSize = 60.0
        labelNode.fontColor = .white
        labelNode.position = CGPoint(x: frame.midX, y: frame.midY)
        labelNode.zPosition = ZPositions.label
        
        return labelNode
    }()
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
    }
    
    private func setupPhysics() {
        updateWorldGravity()
        physicsWorld.contactDelegate = self
    }
    
    private func layoutScene() {
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        addChild(colorSwitch)
        addChild(scoreLabel)
        
        
        spawnBall()
    }
    
    private func spawnBall() {
        currentColorIndex = Int.random(in: 0...3)

        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex!], size: CGSize(width: 30.0, height: 30.0))
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.zPosition = ZPositions.ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none

        addChild(ball)
        
         updateWorldGravity()
    }
    
    private func turnWheel() {
        if let newState = SwitchState(rawValue: switchState.rawValue + 1) {
            switchState = newState
        } else {
            switchState = .red
        }
        
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
    }
    
    private func updateWorldGravity() {
        if score == 0  {
            physicsWorld.gravity = CGVector(dx: 0.0, dy: defaultGravity)
        } else if score % 10 == 0 {
            defaultGravity -= 1.0
            physicsWorld.gravity = CGVector(dx: 0.0, dy: defaultGravity)
        }
    }
    
    private func updateScoreLabel() {
        scoreLabel.text = "\(score)"
    }
    
    private func gameOver() {
        saveScore()
        
        guard let view = view else { return }
        let menuScene = MenuScene(size: view.bounds.size)
        view.presentScene(menuScene)
    }
    
    private func saveScore() {
        UserDefaults.standard.set(score, forKey: "recentScore")
        
        if score > UserDefaults.standard.integer(forKey: "highscore") {
            UserDefaults.standard.set(score, forKey: "highscore")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory {
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                if currentColorIndex == switchState.rawValue {
                    run(SKAction.playSoundFileNamed("bling", waitForCompletion: false))
                    score += 1
                    updateScoreLabel()
                    ball.run(SKAction.fadeOut(withDuration: 0.25)) {
                        ball.removeFromParent()
                        self.spawnBall()
                    }
                } else {
                    gameOver()
                }
            }
        }
    }
}
