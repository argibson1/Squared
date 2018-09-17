//
//  HelpScene.swift
//  Squared2.0
//
//  Created by Alexander Gibson on 11/12/17.
//  Copyright © 2017 GibsonDesignGroup. All rights reserved.
//

import SpriteKit
import GameplayKit

class HelpScene: SKScene {
    
    var IMG_SIZE = CGSize()
    var GAME_PLAY_SIZE : CGFloat = 300
    var EXIT_SIZE : CGFloat = 60
    
    var popup = SKSpriteNode()
    var exit =  SKSpriteNode()
    
    var helpLabel = SKSpriteNode()
    var helpButton = SKSpriteNode()
    var helpHeader = SKLabelNode(fontNamed: "Helvetica Bold")
    var helpGroup = [String : SKLabelNode]()
    var instructions = [SKLabelNode(fontNamed: "Helvetica")]
    var helpLine = [SKSpriteNode()]
    var img = [SKSpriteNode()]
    
    var paragraph1 = [SKLabelNode(fontNamed: "Helvetica")]
    var text1 = ["Welcome to Squared, the first",
                 "game developed by Disco Games.",
                 "Squared is a simple game for all",
                 "players. If you enjoy playing,",
                 "challenge your frineds to beat your",
                 "highscore!"]
    
    var text2 = ["1. To begin, select the PLAY button", "on the Main Menu."]
    var text3 = ["2. The image below shows the user's", "square."]
    var text4 = ["3. To move the square, first check the",
                 "settings to see if MOVE type is set to",
                 "SWIPE or TAP. For swipe the user",
                 "square can be moved while playing by",
                 "swipping in the direction of desired",
                 "motion. For tap the user square can",
                 "be moved by tapping the portion of",
                 "the screen which the user desires to",
                 "move towards."]
    
    var text5 = ["4. The goal of the game is to move",
                 "the user square to the same colored",
                 "target square once it has grown to",
                 "full size."]
    
    var text6 = ["5. If the MOVE type is set to swipe",
                 "the user can double tap the screen",
                 "to fast-forward to the next cycle",
                 "if the user square is in the correct",
                 "position. If MOVE type is set to tap",
                 "the same can be achieved by pressing",
                 "the FWD button in the lower right",
                 "corner."]
    
    var text7 = ["Good luck!"]
    
    var text8 = ["Email: thediscogames@gmail.com",
                 "Phone: (916)367-2922"]
    
    var VERTICAL_LINE_ADJUSTMENT: CGFloat = 40
    var scrollInitialTouch = CGPoint()
    var helpScroll : CGFloat = 0
    
    // Booleans
    
    var SWIPING = false
    
    override func didMove(to view: SKView) {
        scene?.scaleMode = SKSceneScaleMode.aspectFit
        initNodes()
        exit.position = CGPoint(x: self.frame.maxX - exit.size.width / 2 - 10,
                                y: self.frame.maxY - exit.size.height / 2 - 10)
        
        self.addChild(exit)
        self.addChild(popup)
        // self.addChild(helpHeader)
        
        //   self.addChild(helpGroup["General"]!)
        self.addChild(helpGroup["HowToPlay"]!)
        self.addChild(helpGroup["Contact"]!)
        
        for lines in helpLine{
            self.addChild(lines)
        }
        for line in instructions{
            self.addChild(line)
        }
        for image in img{
            self.addChild(image)
        }
        
        for lines in paragraph1{
            self.addChild(lines)
        }
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
        } else {
            SWIPING = true
            scrollInitialTouch = location
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : UITouch = touches.first!
        let location =  touch.location(in: self)
        
        if SWIPING {
            var scrollLength : CGFloat =  scrollInitialTouch.y - location.y
            if(helpScroll + scrollLength > 0){
                scrollLength = -helpScroll
            }
            if  self.frame.minY + 400 < helpGroup["Contact"]!.position.y - scrollLength{
                scrollLength = 0
            }
            if (helpScroll + scrollLength <= 0 && self.frame.minY + 400 >= helpGroup["Contact"]!.position.y - scrollLength){
                helpScroll += scrollLength
                helpGroup["General"]?.position.y -= scrollLength
                helpGroup["HowToPlay"]?.position.y -= scrollLength
                helpGroup["Contact"]?.position.y -= scrollLength
                helpHeader.position.y -= scrollLength
                for line in helpLine{
                    line.position.y -= scrollLength
                    scrollInitialTouch = location
                }
                for i in img {
                    i.position.y -= scrollLength
                }
                for i in instructions{
                    i.position.y -= scrollLength
                }
                for lines in paragraph1{
                    lines.position.y -= scrollLength
                }
            }
        }
    }
    
    func initNodes(){
        
        let center = CGPoint(x: self.frame.midX, y: self.frame.midY)
        IMG_SIZE = CGSize(width: 3 * self.frame.size.width / 8 + 12, height: 3 * self.frame.size.width / 8 + 12)
        
        exit = SKSpriteNode(texture: SKTexture(imageNamed: "exit.png"), size: CGSize(width: EXIT_SIZE, height: EXIT_SIZE))
        exit.name = "exit"
        exit.zPosition = 10
        
        popup = SKSpriteNode(color: UIColor(red: CGFloat( 0 ),green: CGFloat( 0 ),
                                            blue: CGFloat( 0 ), alpha: 1), size: self.frame.size)
        popup.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        popup.zPosition = 2
        
        helpHeader.text = "Help"
        helpHeader.fontSize = 80
        helpHeader.fontColor = UIColor.white
        helpHeader.position = CGPoint(x: center.x, y: self.frame.maxY - 150)
        helpHeader.zPosition = 10
        
        let lineColor = UIColor.white
        let lineSize = CGSize(width: self.frame.width - 100, height: 5)
        let leftMargin = self.frame.minX + 50
        
        var i = 0
        
        helpGroup["HowToPlay"] = SKLabelNode(fontNamed: "Helvetica Bold")
        helpGroup["HowToPlay"]?.text = "How To Play"
        helpGroup["HowToPlay"]?.fontSize = 60
        helpGroup["HowToPlay"]?.position = CGPoint(x: leftMargin, y: self.frame.maxY - 100)
        helpGroup["HowToPlay"]?.zPosition = 10
        helpGroup["HowToPlay"]?.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        var j = 0
        for text in text2 {
            if i != 0{
                instructions.append(SKLabelNode(fontNamed: "Helvetica"))
            }
            instructions[i].text = text
            instructions[i].fontSize = 40
            instructions[i].zPosition = 10
            instructions[i].horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            instructions[i].position = CGPoint(x: leftMargin,
                                               y: helpGroup["HowToPlay"]!.position.y - 130 -
                                                CGFloat(j) * VERTICAL_LINE_ADJUSTMENT)
            i += 1
            j += 1
        }
        
        //"1. To begin, select the PLAY button on the Main Menu"
        
        img[0] = SKSpriteNode(texture: SKTexture(imageNamed: "blueSquare.png"), size: IMG_SIZE)
        img[0].position = CGPoint(x: center.x, y: instructions[0].position.y - img[0].size.height / 2 - 100)
        img[0].zPosition = 10
        
        j = 0
        for text in text3 {
            instructions.append(SKLabelNode(fontNamed: "Helvetica"))
            instructions[i].text = text
            instructions[i].fontSize = 40
            instructions[i].zPosition = 10
            instructions[i].horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            instructions[i].position = CGPoint(x: leftMargin,
                                               y: img[0].position.y - CGFloat(j) * VERTICAL_LINE_ADJUSTMENT - 220)
            i += 1
            j += 1
        }
        img.append(SKSpriteNode(texture: SKTexture(imageNamed: "playButton.png"), size: IMG_SIZE))
        img[1].position = img[0].position
        img[1].zPosition = 11
        
        img.append(SKSpriteNode(texture: SKTexture(imageNamed: "redUser.png"), size: IMG_SIZE))
        img[2].position = CGPoint(x: center.x, y: instructions[i - 1].position.y - img[2].size.height / 2 - 60)
        img[2].zPosition = 10
        
        
        
        j = 0
        for text in text4 {
            
            instructions.append(SKLabelNode(fontNamed: "Helvetica"))
            instructions[i].text = text
            instructions[i].fontSize = 40
            instructions[i].zPosition = 10
            instructions[i].horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            instructions[i].position = CGPoint(x: leftMargin,
                                               y: img[2].position.y - CGFloat(j) * VERTICAL_LINE_ADJUSTMENT - 220)
            i += 1
            j += 1
        }
        
        img.append(SKSpriteNode(texture: SKTexture(imageNamed: "GamePlay.png"),
                                size: CGSize(width: GAME_PLAY_SIZE, height:GAME_PLAY_SIZE)))
        img[3].position = CGPoint(x: self.frame.midX,
                                  y: instructions[i - 1].position.y - GAME_PLAY_SIZE / 2 - 100)
        img[3].zPosition = 10
        
        
        
        j = 0
        for text in text5 {
            
            instructions.append(SKLabelNode(fontNamed: "Helvetica"))
            instructions[i].text = text
            instructions[i].fontSize = 40
            instructions[i].zPosition = 10
            instructions[i].horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            instructions[i].position = CGPoint(x: leftMargin,
                                               y: img[3].position.y - CGFloat(j) * VERTICAL_LINE_ADJUSTMENT - 250)
            i += 1
            j += 1
        }
        
        img.append(SKSpriteNode(texture: SKTexture(imageNamed: "GamePlay2.png"),
                                size: CGSize(width: GAME_PLAY_SIZE, height:GAME_PLAY_SIZE)))
        img[4].position = CGPoint(x: self.frame.midX, y: instructions[i - 1].position.y - GAME_PLAY_SIZE / 2 - 100)
        img[4].zPosition = 10
        
        j = 0
        for text in text6 {
            
            instructions.append(SKLabelNode(fontNamed: "Helvetica"))
            instructions[i].text = text
            instructions[i].fontSize = 40
            instructions[i].zPosition = 10
            instructions[i].horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            instructions[i].position = CGPoint(x: leftMargin, y: img[4].position.y - CGFloat(j) * VERTICAL_LINE_ADJUSTMENT - 250)
            i += 1
            j += 1
        }
        
        img.append(SKSpriteNode(texture: SKTexture(imageNamed: "skip.png"), size: IMG_SIZE))
        img[5].position = CGPoint(x: self.frame.midX, y: instructions[i - 1].position.y - 3 * self.frame.size.width / 8 + 12 / 2 - 50)
        img[5].zPosition = 10
        
        j = 0
        for text in text7 {
            if i != 0{
                instructions.append(SKLabelNode(fontNamed: "Helvetica"))
            }
            instructions[i].text = text
            instructions[i].fontSize = 40
            instructions[i].zPosition = 10
            instructions[i].horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            instructions[i].position = CGPoint(x: leftMargin,
                                               y: img[5].position.y - 170 - CGFloat(j) * VERTICAL_LINE_ADJUSTMENT)
            i += 1
            j += 1
        }
        
        helpLine.append(SKSpriteNode())
        
        helpLine.append(SKSpriteNode(color: lineColor, size: lineSize))
        helpLine[2].position = CGPoint(x: center.x, y: instructions[i - 1].position.y - 150)
        helpLine[2].zPosition = 10
        
        helpGroup["Contact"] = SKLabelNode(fontNamed: "Helvetica Bold")
        helpGroup["Contact"]?.text = "Contact"
        helpGroup["Contact"]?.fontSize = 60
        helpGroup["Contact"]?.position = CGPoint(x: leftMargin, y: helpLine[2].position.y - 100)
        helpGroup["Contact"]?.zPosition = 10
        helpGroup["Contact"]?.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        j = 0
        for text in text8 {
            if i != 0{
                instructions.append(SKLabelNode(fontNamed: "Helvetica"))
            }
            instructions[i].text = text
            instructions[i].fontSize = 40
            instructions[i].zPosition = 10
            instructions[i].horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            instructions[i].position = CGPoint(x: leftMargin,
                                               y: helpGroup["Contact"]!.position.y - 100 - CGFloat(j) * VERTICAL_LINE_ADJUSTMENT)
            i += 1
            j += 1
        }
    }
    
}
