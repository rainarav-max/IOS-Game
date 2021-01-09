//
//  GameOver.swift
//  midTerm
//
//  Created by Xcode User on 2020-10-30.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import SpriteKit

class GameOver: SKScene {
  
     private var button : SKSpriteNode?
    override func didMove(to view: SKView) {
        button = SKSpriteNode(imageNamed: "Restart.png")
        button?.position = CGPoint(x: 10, y: 10)
        addChild(button!)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches){
            let location = touch.location(in: self)
            if self.atPoint(location) == self.button{
                let scene = MainMenu(fileNamed: "MainMenu")
                scene?.scaleMode = .aspectFit
                self.view?.presentScene(scene)
            }
        }
    }
}
