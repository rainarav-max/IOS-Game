//
//  MainMenu.swift
//  midTerm
//
//  Created by Xcode User on 2020-10-30.
//  Copyright © 2020 Xcode User. All rights reserved.
//


import SpriteKit
import GameplayKit

class MainMenu: SKScene{
    
    private var label : SKLabelNode?
    private var button : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        button = SKSpriteNode(imageNamed: "play.jpg")
        button?.position = CGPoint(x: 10, y: 10)        
        addChild(button!)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches){
            let location = touch.location(in: self)
            if self.atPoint(location) == self.button{
                let scene = GameScene(fileNamed: "GameScene.sks")
                scene?.scaleMode = .aspectFill
                self.view?.presentScene(scene)
            }
        }
    }
    
}
