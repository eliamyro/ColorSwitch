//
//  MenuScene.swift
//  ColorSwitch
//
//  Created by Elias Myronidis on 07/03/2019.
//  Copyright © 2019 Elias Myronidis. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    lazy var logo: SKSpriteNode = {
        let spriteNode = SKSpriteNode(imageNamed: "logo")
        spriteNode.size = CGSize(width: frame.size.width / 4, height: frame.size.width / 4)
        spriteNode.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height / 4)
        
        return spriteNode
    }()
    
    lazy var playLabel: SKLabelNode = {
        let labelNode = SKLabelNode(text: "Tap to Play!")
        labelNode.fontName = "AvenirNext-Bold"
        labelNode.fontSize = 50.0
        labelNode.fontColor = .white
        labelNode.position = CGPoint(x: frame.midX, y: frame.midY)
        
        return labelNode
    }()
    
    lazy var highscoreLabel: SKLabelNode = {
        let labelNode = SKLabelNode(text: "Highscore: \(UserDefaults.standard.integer(forKey: "highscore"))")
        labelNode.fontName = "AvenirNext-Bold"
        labelNode.fontSize = 40.0
        labelNode.fontColor = .white
        labelNode.position = CGPoint(x: frame.midX, y: frame.midY - labelNode.frame.size.height * 4)
        
        return labelNode
    }()
    
    lazy var recentScoreLabel: SKLabelNode = {
        let labelNode = SKLabelNode(text: "Recent Score: \(UserDefaults.standard.integer(forKey: "recentScore"))")
        labelNode.fontName = "AvenirNext-Bold"
        labelNode.fontSize = 40.0
        labelNode.fontColor = .white
        labelNode.position = CGPoint(x: frame.midX, y: highscoreLabel.position.y - labelNode.frame.size.height * 2)
        
        return labelNode
    }()

    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        addLogo()
        addLabels()
        updateLabels()
    }
    
    private func addLogo() {
        addChild(logo)
    }
    
    private func addLabels() {
        addChild(playLabel)
        addChild(highscoreLabel)
        addChild(recentScoreLabel)
        
        animate(label: playLabel)
    }
    
    private func updateLabels() {
        let recentScore = UserDefaults.standard.integer(forKey: "recentScore")
        let highscore = UserDefaults.standard.integer(forKey: "highscore")
        
        highscoreLabel.text = "Highscore: \(highscore)"
        recentScoreLabel.text = "Recent Score: \(recentScore)"
        
    }
    
    private func animate(label: SKLabelNode) {
//        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
//        let fadeIn = SKAction.fadeIn(withDuration: 0.5)

        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        playLabel.run(SKAction.repeatForever(sequence))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view = view else { return }
        let gameScene = GameScene(size: view.bounds.size)
        view.presentScene(gameScene)
    }
}
