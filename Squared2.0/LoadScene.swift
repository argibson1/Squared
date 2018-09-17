//
//  LoadScene.swift
//  Squared2.0
//
//  Created by Alexander Gibson on 11/12/17.
//  Copyright © 2017 GibsonDesignGroup. All rights reserved.
//

import SpriteKit
import GameplayKit

class LoadScene: SKScene {
    
    var logo = SKSpriteNode()
    var startup : Timer = Timer()
    var time : Float = 0.0
    var LOGO_DURATION : Float = 3
    var isLogo = false
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor.black
        logo = SKSpriteNode(texture: SKTexture(imageNamed:"DiscoGames.png"), size: CGSize(width: self.frame.width , height: self.frame.width))
        
        logo.alpha = 0
        logo.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        logo.zPosition = 4
        self.addChild(logo)
        isLogo = true
        if time <= 1.9 && time > 1{
            logo.alpha = CGFloat(time - 1)
        }
        if time > 1.2 {
            logo.alpha = CGFloat(2.1 - time)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Move to main menu
        let scene : SKScene = MainMenu(size: self.size)
        self.view?.presentScene(scene, transition: SKTransition.init())
    }

    override func update(_ currentTime: TimeInterval) {
        if isLogo {
            updateTimer(length: LOGO_DURATION)
        }
        if time > 1.9 {
            logo.alpha = CGFloat(2.9 - time)
        }        //print(time)

        if time <= 1.9 && time > 1{
            logo.alpha = CGFloat(time - 1)
        }
    }

    func updateTimer(length: Float){
        time += 0.01
        if Float(time) >= length {
            isLogo = false
            // Move to main menu
            let scene : SKScene = MainMenu(size: self.size)
            self.view?.presentScene(scene, transition: SKTransition.init())
        }
    }
}
