//
//  LeaderboardScene.swift
//  Squared2.0
//
//  Created by Alexander Gibson on 11/12/17.
//  Copyright © 2017 GibsonDesignGroup. All rights reserved.
//

/* TODO:
 * Need to work on the flow and layout, make sure works for all devices, and all medals show
 * add labels for the different medals and lock
 *
 */

import SpriteKit
import GameplayKit
import AVFoundation

class LeaderboardScene: SKScene {
    var lbHSLabel = SKLabelNode(fontNamed: "Helvetica")
    var lbHS = SKLabelNode(fontNamed: "Helvetica")
    var hasntMedal = [SKLabelNode(fontNamed: "Helvetica")]
    var hasMedal = [SKLabelNode(fontNamed: "Helvetica")]
    var medals = [SKSpriteNode()]
    var medalBG = [SKSpriteNode()]
    var lock = [SKSpriteNode()]
    var lockProng = SKSpriteNode()
    var lockBody = SKSpriteNode()
    
    var popup = SKSpriteNode()
    var exit =  SKSpriteNode()
    
    var hasUnlocked = [false, false, false]
    var GOLD_MEDAL_SCORE = 100
    var SILVER_MEDAL_SCORE = 28
    var BRONZE_MEDAL_SCORE = 14
    
    var MEDAL_SIZE = CGFloat()
    var EXIT_SIZE : CGFloat = 60
    
    let userDefault = Foundation.UserDefaults.standard
    
    var highScore = 0
    
    override func didMove(to view: SKView) {
        scene?.scaleMode = SKSceneScaleMode.aspectFit
        initNodes()
        
        if highScore >= GOLD_MEDAL_SCORE{
            hasUnlocked[0] = true
            hasUnlocked[1] = true
            hasUnlocked[2] = true
        } else if highScore >= SILVER_MEDAL_SCORE {
            hasUnlocked[1] = true
            hasUnlocked[2] = true
        } else if highScore >= BRONZE_MEDAL_SCORE {
            hasUnlocked[2] = true
        }
        
        exit.position = CGPoint(x: self.frame.maxX - exit.size.width / 2 - 10, y: self.frame.maxY - exit.size.height / 2 - 10)
        popup.size = CGSize(width: self.frame.width, height: self.frame.height)
        self.addChild(exit)
        self.addChild(popup)
        
        for j in 0..<medals.count {
            if hasUnlocked[j] {
                self.addChild(hasMedal[j])
                self.addChild(medals[j])
            } else {
                self.addChild(hasntMedal[j])
                self.addChild(lock[j])
            }
        }
        for j in 0..<medals.count {
            if hasUnlocked[j] {
                medalBG[j].texture = SKTexture(imageNamed: "greenSquare.png")
            }
            self.addChild(medalBG[j])
        }
        self.addChild(lbHS)
        self.addChild(lbHSLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : UITouch = touches.first!
        let location =  touch.location(in: self)
        let node: SKNode = self.atPoint(location)
        
        if node.name != nil {
            if node.name == "exit"{
                // Change to MainMenu scene
                let scene : SKScene = MainMenu(size: self.size)
                self.view?.presentScene(scene, transition: SKTransition.init())
            }
        }
    }
    
    func initNodes() {
        
        MEDAL_SIZE = 130
        
        highScore = userDefault.integer(forKey: "highscore")
        exit = SKSpriteNode(texture: SKTexture(imageNamed: "exit.png"), size: CGSize(width: EXIT_SIZE, height: EXIT_SIZE))
        exit.name = "exit"
        exit.zPosition = 10
        
        popup = SKSpriteNode(color: UIColor(red: CGFloat( 0 ),green: CGFloat( 0 ),
                                            blue: CGFloat( 0 ), alpha: 1), size: self.frame.size)
        popup.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        popup.zPosition = 2
        
        medals[0] = SKSpriteNode(texture: SKTexture(imageNamed: "GoldMedal.png"),
                                 size: CGSize(width: MEDAL_SIZE, height: MEDAL_SIZE))
        medals[0].position = CGPoint(x: (self.frame.midX + self.frame.minX) / 3, y: self.frame.midY + MEDAL_SIZE * 2 - 100)
        medals[0].zPosition = 10
        
        medals.append(SKSpriteNode(texture: SKTexture(imageNamed: "SilverMedal.png"),
                                   size: CGSize(width: MEDAL_SIZE, height: MEDAL_SIZE)))
        medals[1].position = CGPoint(x: (self.frame.midX + self.frame.minX) / 3, y: self.frame.midY - 100)
        medals[1].zPosition = 10
        
        medals.append(SKSpriteNode(texture: SKTexture(imageNamed: "BronzeMedal.png"),
                                   size: CGSize(width: MEDAL_SIZE, height: MEDAL_SIZE)))
        medals[2].position = CGPoint(x: (self.frame.midX + self.frame.minX) / 3, y: self.frame.midY - MEDAL_SIZE * 2 - 100)
        medals[2].zPosition = 10
        
        lock[0] = SKSpriteNode(texture: SKTexture(imageNamed: "Lock.png"), size: CGSize(width: MEDAL_SIZE + 30, height: MEDAL_SIZE + 30))
        
        if hasUnlocked[0]{
            medalBG[0] = SKSpriteNode(texture: SKTexture(imageNamed: "greenSquare.png"),
                                      size: CGSize(width: MEDAL_SIZE + 30, height: MEDAL_SIZE + 30))
        } else {
            medalBG[0] = SKSpriteNode(texture: SKTexture(imageNamed: "MedalBG.png"),
                                      size: CGSize(width: MEDAL_SIZE + 30, height: MEDAL_SIZE + 30))        }
        for i in 0...2 {
            if i != 0 {
                lock.append(SKSpriteNode(texture: SKTexture(imageNamed: "Lock.png"), size: CGSize(width: MEDAL_SIZE + 30, height: MEDAL_SIZE + 30)))
                hasntMedal.append(SKLabelNode(fontNamed: "Helvetica"))
                hasMedal.append(SKLabelNode(fontNamed: "Helvetica"))
            }
            var medal : Int!
            var metal : String!
            switch i {
            case 2:
                metal = "Bronze"
                medal = BRONZE_MEDAL_SCORE
                break
            case 1:
                metal = "Silver"
                medal = SILVER_MEDAL_SCORE
                break
            case 0:
                metal = "Gold"
                medal = GOLD_MEDAL_SCORE
                break
            default:
                break
            }
            
            lock[i].position = medals[i].position
            lock[i].zPosition = 10
            
            if hasUnlocked[i] {
                if i != 0 {
                    medalBG.append(SKSpriteNode(texture: SKTexture(imageNamed: "greenSquare.png"),
                                                size: CGSize(width: MEDAL_SIZE + 30, height: MEDAL_SIZE + 30)))
                }
            } else {
                medalBG.append(SKSpriteNode(texture: SKTexture(imageNamed: "MedalBG.png"),
                                            size: CGSize(width: MEDAL_SIZE + 30, height: MEDAL_SIZE + 30)))
            }
            medalBG[i].position = medals[i].position
            medalBG[i].zPosition = 9
            
            hasMedal[i].text = "You won \(metal!)!"
            hasntMedal[i].text = "Score \(medal!) to win \(metal!)!"
            
            hasMedal[i].fontSize = 40
            hasntMedal[i].fontSize = 40
            hasMedal[i].position = CGPoint(x: medalBG[i].position.x + 150, y: medalBG[i].position.y)
            hasntMedal[i].position = CGPoint(x: medalBG[i].position.x + 150, y: medalBG[i].position.y)
            hasMedal[i].fontColor = UIColor.white
            hasntMedal[i].fontColor = UIColor.white
            hasMedal[i].zPosition = 10
            hasntMedal[i].zPosition = 10
            hasMedal[i].horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            hasntMedal[i].horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        }
        
        
        
        lbHSLabel.text = "Highscore:"
        lbHSLabel.position = CGPoint(x: self.frame.midX - popup.size.width / 2 + 100, y: medals[0].position.y + 200)
        lbHSLabel.fontColor = UIColor.white
        lbHSLabel.fontSize = 60
        lbHSLabel.zPosition = 10
        lbHSLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        lbHS.text = String(highScore)
        lbHS.position = CGPoint(x: self.frame.midX + popup.size.width / 2  - 200, y: lbHSLabel.position.y)
        lbHS.fontColor = UIColor.green
        lbHS.fontSize = 70
        lbHS.zPosition = 10
        lbHS.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
    }
}
