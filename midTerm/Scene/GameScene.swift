//
//  GameScene.swift
//  midTerm
//
//  Created by Xcode User on 2020-10-30.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import SpriteKit
import GameplayKit

struct physicsCategory{
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let Baddy : UInt32 = 0b1
    static let Hero : UInt32 = 0b10
    static let Projectile : UInt32 = 0b11
    
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var background = SKSpriteNode(imageNamed: "backGround.jpg")
    private var goodGuy : SKSpriteNode?
    private var newScore : SKSpriteNode?
    var count : Int32 = 0
    
    //score
    private var score : Int = 0
    let scoreIncrement = 10
    private var lblScore : SKLabelNode?
    
    //highScore
    private var lbhScore : SKLabelNode?
    
    static var highScore : Int = 0
    
    
    //timer
    private var lbTime : SKLabelNode?
    var timer : Int = 60
    override func didMove(to view: SKView) {
        //background appear
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        background.alpha = 0.2
        addChild(background)
        
        setHighScore()
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        goodGuy = SKSpriteNode(imageNamed: "gCharacter.png")
        goodGuy?.position = CGPoint(x: 330, y: 110)
        addChild(goodGuy!)
        
        //physics to good guy
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self;
        
        goodGuy?.physicsBody = SKPhysicsBody(circleOfRadius: (goodGuy?.size.width)!/2)
        goodGuy?.physicsBody?.isDynamic = true
        goodGuy?.physicsBody?.categoryBitMask = physicsCategory.Hero
        goodGuy?.physicsBody?.contactTestBitMask = physicsCategory.Baddy
        goodGuy?.physicsBody?.contactTestBitMask = physicsCategory.Projectile
        goodGuy?.physicsBody?.collisionBitMask = physicsCategory.None
        goodGuy?.physicsBody?.usesPreciseCollisionDetection = true
        
        //repeat action
         run(SKAction.repeatForever(SKAction.sequence([SKAction.run(badGuy), SKAction.wait(forDuration: 0.5)])))
        //score
        score = 0
        self.lblScore = self.childNode(withName: "//score") as? SKLabelNode
        self.lblScore?.text = "Score: \(score)"
        if let slabel = self.lblScore{
            slabel.alpha = 0.0
            slabel.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
    }
    //highScore
    func saveHighScoreValue(){
        UserDefaults.standard.set(score, forKey: "score")
        if UserDefaults.standard.integer(forKey: "highScore") != nil{
            if UserDefaults.standard.integer(forKey: "highScore") < score {
                UserDefaults.standard.set(self.score, forKey: "highScore")
            }
        }
    }
    
    func setHighScore() {
        if UserDefaults.standard.integer(forKey: "highScore") == nil{
            GameScene.highScore = 0
        }
        else {
            GameScene.highScore = UserDefaults.standard.integer(forKey: "highScore")
        }
        
        self.lbhScore = self.childNode(withName: "//highScore") as? SKLabelNode
        self.lbhScore?.text = "High Score: \(GameScene.highScore)"
        if let slabel = self.lbhScore{
            slabel.alpha = 0.0
            slabel.run(SKAction.fadeIn(withDuration: 2.0))
        }
    }
 
    //bad guy
    func random()-> CGFloat{
        return CGFloat(Float(arc4random()) / 0xffffffff)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max-min) + min
    }
    func addScore(){
        newScore = SKSpriteNode(imageNamed: "good.jpeg")
        newScore!.xScale = newScore!.xScale * -1
        
        let actualY = random(min: newScore!.size.width/2, max: size.width-newScore!.size.width/2)
        newScore!.position = CGPoint(x: actualY, y: size.height + newScore!.size.height/2 )
        addChild(newScore!)
        
        newScore!.physicsBody = SKPhysicsBody(rectangleOf: newScore!.size)
        newScore!.physicsBody?.isDynamic = true;
        newScore!.physicsBody?.categoryBitMask = physicsCategory.Projectile
        newScore!.physicsBody?.contactTestBitMask = physicsCategory.Hero
        newScore!.physicsBody?.collisionBitMask = physicsCategory.None
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let actionMove = SKAction.move(to:  CGPoint(x: actualY, y: -newScore!.size.height/2), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        newScore!.run(SKAction.sequence([actionMove,actionMoveDone]))
    }
    func badGuy(){
        let baddy = SKSpriteNode(imageNamed: "bad.png")
        baddy.xScale = baddy.xScale * -1
        
        let actualY = random(min: baddy.size.width/2, max: size.width-baddy.size.width/2)
        baddy.position = CGPoint(x: actualY, y: size.height + baddy.size.height/2 )
        addChild(baddy)
        self.count = self.count + 1;
        
        //physics to bad guy
        baddy.physicsBody = SKPhysicsBody(rectangleOf: baddy.size)
        baddy.physicsBody?.isDynamic = true;
        baddy.physicsBody?.categoryBitMask = physicsCategory.Baddy
        baddy.physicsBody?.contactTestBitMask = physicsCategory.Hero
        baddy.physicsBody?.collisionBitMask = physicsCategory.None
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let actionMove = SKAction.move(to:  CGPoint(x: actualY, y: -baddy.size.height/2), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        if self.count % 5 == 0{
            baddy.run(SKAction.sequence([SKAction.run(addScore), actionMoveDone]))
        }
        else{
            baddy.run(SKAction.sequence([actionMove,actionMoveDone]))
        }
       
    }
    //collision detection
    func heroDidCollideWithProjectile(hero: SKSpriteNode, projectile: SKSpriteNode){
        print("hit")
        score = score + scoreIncrement
        self.lblScore?.text = "Score: \(score)"
        if let slabel = self.lblScore{
            slabel.alpha = 0.0
            slabel.run(SKAction.fadeIn(withDuration: 2.0))
        }
    }
    func heroDidCollideWithBaddy(hero: SKSpriteNode, baddy: SKSpriteNode){
       let gOver = GameOver(fileNamed: "GameOver")
        self.view?.presentScene(gOver)
    }
    
    func decreaseTime() {
        timer -= 1
        lbTime = self.childNode(withName: "//timeLeft") as! SKLabelNode
        lbTime!.text = "Time Left : \(timer) sec"
        if let elbl = lbTime {
            elbl.alpha = 0.0
            elbl.run(SKAction.fadeIn(withDuration: 2.0))
        }
    }
    
    func die() {
        saveHighScoreValue()
        let scene = GameOver(fileNamed: "GameOver")
        scene?.scaleMode = .aspectFill
        self.view?.presentScene(scene)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if timer > 0 {
            score = score + 1
            self.lblScore?.text = "Score: \(score)"
            
            decreaseTime()
            var firstBody : SKPhysicsBody
            var secondBody : SKPhysicsBody
            
            if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
                firstBody = contact.bodyA
                secondBody = contact.bodyB
            }
            else{
                firstBody = contact.bodyB
                secondBody = contact.bodyA
            }
           
        
           if ((firstBody.categoryBitMask & physicsCategory.Projectile != 0) && (secondBody.categoryBitMask & physicsCategory.Hero != 0)) {
               heroDidCollideWithProjectile(hero: firstBody.node as! SKSpriteNode, projectile: secondBody.node as! SKSpriteNode)
          }
            
            if ((firstBody.categoryBitMask & physicsCategory.Baddy != 0) && (secondBody.categoryBitMask & physicsCategory.Hero != 0)) {
                heroDidCollideWithBaddy(hero: firstBody.node as! SKSpriteNode, baddy: secondBody.node as! SKSpriteNode)
            }
            // else if firstBody.categoryBitMask == physicsCategory.Baddy && //secondBody.categoryBitMask == physicsCategory.Hero {
               //timer = 0
            //}
 
 
        }
            
        else if timer == 0 {
            timer -= 1
            die()
        }
 
    }
    
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let touchLocation = t.location(in: self)
            goodGuy?.position.x = (touchLocation.x)
          
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
