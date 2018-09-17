//
//  GameScene.swift
//  Squared2.0
//
//  Created by Alexander Gibson on 11/12/17.
//  Copyright © 2017 GibsonDesignGroup. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    var targetBack = SKSpriteNode()
    var subTargetBack = SKSpriteNode()
    var sWidth : CGFloat = 0.0
    var TARGET_BACK_INIT_WIDTH : CGFloat = 0
    var TARGET_BACK_INIT_HEIGHT : CGFloat = 0
    var MAX_TARGET_BACK : CGFloat = 0
    var MAX_SIDES = 5
    
    var CYCLES = 4
    var SPEED_CYCLE = 1
    var MAX_SPEED = 8
    
    var hole  = SKSpriteNode()
    var subHole = SKSpriteNode()
    var background = SKSpriteNode()
    
    var squares : Int = 1
    var time : Float = 0.0
    
    var INIT_SIDES = 3
    var sides: Int = 0
    
    var completions : Int  = 0
    var counter = 0
    
    var center = CGPoint()
    
    var xSide = [Int(arc4random_uniform(UInt32(3)))]
    var ySide = [Int(arc4random_uniform(UInt32(3)))]
    
    var CONTINUE : Bool = false
    var RESTART = false
    
    var TAP : Bool = false
    var SWIPE : Bool = true
    var TAPCHECK : Bool = false
    var SWIPING : Bool = false
    var HSCINEMATIC : Bool = false
    var HIGHSCOREPOPUP : Bool = false
    var GOLDCINEMATIC = false, SILVERCINEMATIC = false, BRONZECINEMATIC = false
    
    var PAUSE : Bool = false
    
    var swipeStart = CGPoint()
    
    var cinematicSquares = [SKSpriteNode()]
    var goldLabel = SKSpriteNode()
    var bronzeLabel = SKSpriteNode()
    var silverLabel = SKSpriteNode()
    var cSSize = CGSize(width: 30, height: 30)
    
    var MOVEVOLUME0 : Bool = false
    
    var targets = [SKSpriteNode()]
    var user = SKSpriteNode()
    var users = [SKTexture()]
    var popup = SKSpriteNode()
    var exit =  SKSpriteNode()
    var skip = SKSpriteNode()
    var pauseButton = SKSpriteNode()
    var play = SKSpriteNode()
    
    var volumeSliderNode = [SKSpriteNode()]
    var volumeSliderHeight : CGFloat = 0.0
    var whiteSliderBox = [SKSpriteNode()]
    var blueSliderBox = [SKSpriteNode()]
    var minSlider : CGFloat = 0.0
    var maxSlider : CGFloat = 0.0
    var sliderHeight : CGFloat = 0.0
    
    var selectionBoxWhite = SKSpriteNode()
    var selectionBoxBlue = SKSpriteNode()
    var tapLabel = SKLabelNode(fontNamed: "Helvetica")
    var swipeLabel = SKLabelNode(fontNamed: "Helvetica")
    
    var SFXLabel = SKLabelNode(fontNamed: "Helvetica")
    var musicLabel = SKLabelNode(fontNamed: "Helvetica")
    var motionLabel = SKLabelNode(fontNamed: "Helvetica")
    
    var settingsNodes = [SKSpriteNode()]
    var settingsLabels = [SKLabelNode()]
    
    var borderColor : UIColor = UIColor(red: 40.0/255, green: 40.0/255, blue: 40.0/255, alpha: 1)
    
    var targetIndex = 0
    
    var highScore = 0
    
    // IF I ever want it to start not 3X3 this needs to be sides / 2
    var userX = 1
    var userY = 1
    var move: Bool = false
    
    var INIT_GROWTH_RATE : CGFloat = 0.0
    var GROWTH_RATE : CGFloat = 0.0
    var INITIAL_TIME : Double = 0.0
    var MIN_SWIPE_LENGTH : CGFloat = 100
    
    var GOLD_MEDAL_SCORE = 100
    var SILVER_MEDAL_SCORE = 28
    var BRONZE_MEDAL_SCORE = 14
    
    // GAME OVER Screen
    var gameOver = SKLabelNode(fontNamed: "Damascus")
    var score = SKLabelNode(fontNamed: "DamascusBold")
    var restart = SKLabelNode(fontNamed: "Damascus")
    var mainMenuButton = SKLabelNode(fontNamed: "Damascus")
    
    var hSPopup = SKSpriteNode()
    var hSLabel = SKLabelNode(fontNamed: "DamascusBold")
    var hsLabelNode = SKSpriteNode()
    
    var player = AVAudioPlayer()
    var volume : Float = 1
    
    let userDefault = Foundation.UserDefaults.standard

    override func didMove(to view: SKView) {
        scene?.scaleMode = SKSceneScaleMode.aspectFit
        let tap1 : Bool? = userDefault.bool(forKey: "tap")
        
        if tap1 == nil {
            userDefault.set(false , forKey: "tap")
            TAP = false
        } else {
            TAP = tap1!
            SWIPE = !(tap1!)
        }
        
        let value1 : Int? = userDefault.integer(forKey: "highscore")
        
        if value1 == nil {
            userDefault.set(0, forKey: "highscore")
        }
        
        let value0 : Float? = userDefault.float(forKey: "volume")
        
        if value0 == nil {
            userDefault.set(1.0, forKey: "volume")
        }
        
        volume = userDefault.float(forKey: "volume")
        highScore = userDefault.integer(forKey: "highscore")
        
        initNodes()
        startGame()
    }
    
    var TOP_LR_BORDER : CGFloat = 0.0
    var BOTTOM_LR_BORDER :CGFloat = 0.0
    var INNER_RIGHT : CGFloat = 0.0
    var INNER_LEFT : CGFloat = 0.0
    var LEFT_UD : CGFloat = 0.0
    var RIGHT_UD : CGFloat = 0.0
    var LOWER_TOP : CGFloat = 0.0
    var UPPER_BOTTOM : CGFloat = 0.0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
        let touch : UITouch = touches.first!
        let location =  touch.location(in: self)
        let node: SKNode = self.atPoint(location)
        
        if PAUSE{
            if node.name == "play"{
                if TAP && skip.isHidden {
                    self.addChild(skip)
                } else if SWIPE && !skip.isHidden{
                    skip.removeFromParent()
                }
                CONTINUE = true
                PAUSE = false
                for lb in settingsLabels{
                    lb.removeFromParent()
                }
                for nd in settingsNodes{
                    nd.removeFromParent()
                }
                swipeLabel.removeFromParent()
                hSPopup.removeFromParent()
                play.removeFromParent()
                pauseButton.zPosition = 4
            }
            if node.name != nil{
                switch node.name!{
                case "volume0":
                    MOVEVOLUME0 = true
                case "exit":
                // Change to mainmenu scene
                    let scene : SKScene = MainMenu(size: self.size)
                    self.view?.presentScene(scene, transition: SKTransition.init())
                default:
                    break
                }
                
                if TAP == false && node.name == "Tap"{
                    TAP = true
                    SWIPE = false
                    selectionBoxWhite.position.x = selectionBoxWhite.position.x + 100
                    tapLabel.fontColor = UIColor.white
                    swipeLabel.fontColor = UIColor.blue
                    userDefault.set( true, forKey: "tap")
                }
                else if SWIPE == false && node.name == "Swipe"{
                    TAP = false
                    SWIPE = true
                    selectionBoxWhite.position.x = selectionBoxWhite.position.x - 100
                    tapLabel.fontColor = UIColor.blue
                    swipeLabel.fontColor = UIColor.white
                    userDefault.set( false, forKey: "tap")
                }
                else if node.name == "SwipeTap"{
                    if SWIPE == true{
                        SWIPE = false
                        TAP = true
                        selectionBoxWhite.position.x = selectionBoxWhite.position.x + 100
                        tapLabel.fontColor = UIColor.white
                        swipeLabel.fontColor = UIColor.blue
                        userDefault.set( true, forKey: "tap")
                    } else{
                        TAP = false
                        SWIPE = true
                        selectionBoxWhite.position.x = selectionBoxWhite.position.x - 100
                        tapLabel.fontColor = UIColor.blue
                        swipeLabel.fontColor = UIColor.white
                        userDefault.set( false, forKey: "tap")
                    }
                }
            }
        }
        
        if CONTINUE{
            
            if node.name == "pause"{
                pause()
            }
            else if node.name == "skip"{
                targetBack.size.width = MAX_TARGET_BACK
                targetBack.size.height = MAX_TARGET_BACK
            }
            else if TAP{
                
                // TOUCH LEFT
                if location.x <= INNER_RIGHT && location.x >= self.frame.minX && location.y <= TOP_LR_BORDER
                    && location.y >=       BOTTOM_LR_BORDER && userX != 0 {
                    userX -= 1
                    move = true
                }
                
                // TOUCH RIGHT
                if location.x >= INNER_LEFT && location.x <= self.frame.maxX && location.y <= TOP_LR_BORDER
                    && location.y >= BOTTOM_LR_BORDER && userX != sides - 1{
                    userX += 1
                    move = true
                }
                
                // TOUCH DOWN
                if location.y <= UPPER_BOTTOM && location.y <= self.frame.maxY && location.x >= LEFT_UD
                    && location.x <= RIGHT_UD &&    userY != 0 {
                    userY -= 1
                    move = true
                }
                
                // TOUCH UP
                if location.y >= LOWER_TOP && location.y >= self.frame.minY && location.x >= LEFT_UD
                    && location.x <= RIGHT_UD &&   userY != sides - 1 {
                    userY += 1
                    move = true
                }
            } else if SWIPE{
                if TAPCHECK == true {
                    targetBack.size.width = MAX_TARGET_BACK
                    targetBack.size.height = MAX_TARGET_BACK
                    TAPCHECK = false
                    time = 0
                }
                TAPCHECK = true
                SWIPING = true
                swipeStart = location
            }
        } else if HIGHSCOREPOPUP {
            if HSCINEMATIC == false {
                hSCinematic(new: highScore)
                HSCINEMATIC = true
            }else{
                hSPopup.removeFromParent()
                hSLabel.removeFromParent()
                hsLabelNode.removeFromParent()
                self.removeChildren(in: cinematicSquares)
                time = 0
                
                cinematicSquares.removeAll()
                
                HSCINEMATIC = false
                BRONZECINEMATIC = false
                SILVERCINEMATIC = false
                GOLDCINEMATIC = false
                HIGHSCOREPOPUP = false
                RESTART = true
            }
        }  else if RESTART{
            
            // RESTART the game
            if location.x < restart.position.x + 50 && location.x > restart.position.x - 50
                && location.y < restart.position.y + 30 && location.y > restart.position.y - 30{
                restartGame()
                playAudio(name: "Menu")
            }
            
            if location.x < mainMenuButton.position.x + 50 && location.x > mainMenuButton.position.x - 50
                && location.y < mainMenuButton.position.y + 30 && location.y > mainMenuButton.position.y - 30{
                // Change to mainmenu scene
                let scene : SKScene = MainMenu(size: self.size)
                self.view?.presentScene(scene, transition: SKTransition.init())
                playAudio(name: "Menu")
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch : UITouch = touches.first!
        let location =  touch.location(in: self)
        let node: SKNode = self.atPoint(location)
        
        if SWIPING{
            if pow(location.x - swipeStart.x,2) + pow(location.y - swipeStart.y,2) >= MIN_SWIPE_LENGTH{
                if abs(location.x - swipeStart.x) > abs(location.y - swipeStart.y){
                    //LEFT/RIGHT
                    if location.x - swipeStart.x > 0 && userX != sides - 1{
                        userX += 1
                    }
                    else if location.x - swipeStart.x < 0 && userX != 0{
                        userX -= 1
                    }
                }else{
                    //UP/DOWN
                    if location.y - swipeStart.y > 0 && userY != sides - 1 {
                        userY += 1
                    } else if location.y - swipeStart.y < 0 && userY != 0 {
                        userY -= 1
                    }
                }
                TAPCHECK = false
                time = 0
                move = true
                SWIPING = false
            }
        } else if MOVEVOLUME0 {
            // a node is moving
            if MOVEVOLUME0 && location.x >= minSlider && location.x <= maxSlider{
                volumeSliderNode[0].position = CGPoint(x: location.x, y: volumeSliderHeight)
                blueSliderBox[0].size = CGSize(width: abs(minSlider - volumeSliderNode[0].position.x),
                                               height: sliderHeight)
                blueSliderBox[0].position = CGPoint(x: (minSlider + volumeSliderNode[0].position.x) / 2,
                                                    y: volumeSliderNode[0].position.y)
                whiteSliderBox[0].size = CGSize(width: abs(maxSlider - volumeSliderNode[0].position.x),
                                                height: sliderHeight)
                whiteSliderBox[0].position = CGPoint(x: (maxSlider + volumeSliderNode[0].position.x) / 2,
                                                     y: volumeSliderNode[0].position.y)
            }
            else if volumeSliderNode[0].position.x <= minSlider {
                volumeSliderNode[0].position.x = minSlider
            }
            else if volumeSliderNode[0].position.x >= maxSlider {
                volumeSliderNode[0].position.x = maxSlider
            }
            
            volume = Float((volumeSliderNode[0].position.x - minSlider) / (maxSlider - minSlider))
            if volume < 0.05{
                volume = 0.0
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if MOVEVOLUME0 {
            userDefault.set(volume, forKey: "volume")
        }
        MOVEVOLUME0 = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        if HSCINEMATIC && time < 0.25 {
            if time == 0{
                
                for var i in 0...10 {
                    var texture = SKTexture( imageNamed: "redSquare.png")
                    
                        if GOLDCINEMATIC {
                            texture = SKTexture(imageNamed: "goldSquare.png")
                        } else if SILVERCINEMATIC {
                            texture = SKTexture(imageNamed: "silverSquare.png")
                        } else if BRONZECINEMATIC {
                            texture = SKTexture(imageNamed: "bronzeSquare.png")
                        }else {
                            
                                switch i%4 {
                                case 0:
                                    texture = SKTexture(imageNamed: "redSquare.png")
                                case 1:
                                    texture = SKTexture(imageNamed: "blueSquare.png")
                                case 2:
                                    texture = SKTexture(imageNamed: "yellowSquare.png")
                                case 3:
                                    texture = SKTexture(imageNamed: "greenSquare.png")
                                default:
                                    break
                            }
                    }
                    
                    if i == 0 {
                        if cinematicSquares.isEmpty {
                            cinematicSquares.append(SKSpriteNode())
                        }
                        cinematicSquares[0] = SKSpriteNode(texture: texture, size: cSSize)
                    } else {
                        cinematicSquares.append(SKSpriteNode(texture: texture, size: cSSize))
                    }
                    
                    cinematicSquares[i].physicsBody = SKPhysicsBody(circleOfRadius: cSSize.width/2)
                    cinematicSquares[i].physicsBody?.affectedByGravity = true
                    cinematicSquares[i].physicsBody?.collisionBitMask = 0
                    cinematicSquares[i].position = hSLabel.position
                    cinematicSquares[i].physicsBody?.velocity = CGVector(dx: 150 - CGFloat(arc4random_uniform(300)),
                                                                         dy: CGFloat(arc4random_uniform(600)))
                    cinematicSquares[i].zPosition = 5
                    self.addChild(cinematicSquares[i])
            }
            }
            if TAPCHECK {
                updateTimer(length: 0.25)
            } else {
                time = 1;
            }
        } else if move {
            
            if sides % 2 == 0 {
                let scalarX = Float(userX - sides / 2) + 0.5
                let scalarY = Float(userY - sides / 2) + 0.5
                user.position = CGPoint(x: targetBack.position.x + CGFloat(scalarX) * MAX_TARGET_BACK / CGFloat(sides),
                                        y: targetBack.position.y + CGFloat(scalarY) * MAX_TARGET_BACK / CGFloat(sides))
            } else {
                let scalarX = userX - sides / 2
                let scalarY = userY - sides / 2
                user.position = CGPoint(x: targetBack.position.x + CGFloat(scalarX) * MAX_TARGET_BACK / CGFloat(sides),
                                        y: targetBack.position.y + CGFloat(scalarY) * MAX_TARGET_BACK / CGFloat(sides))
            }
            
            move = false
        }
        
        if CONTINUE {
            updateGame()
        }
        
        if TAPCHECK {
            updateTimer(length: 0.1)
        }
        
        // REFRESH the target square
        if targetBack.size.width >= MAX_TARGET_BACK - 4  && CONTINUE {
            
            // NOT IN HOLE
            if (xSide[targetIndex] != userX || ySide[targetIndex] != userY){
                
                gameOverFunction()
                
            } else {
 
                resetTargets()
                TAPCHECK = false
                time = 0
            }
        }
    }
    
    func updateTimer(length: Float){
        time += 0.01
        if Float(time) >= length {
            
           
            if HSCINEMATIC {
                self.removeChildren(in: cinematicSquares)
                cinematicSquares.removeAll()
            }
            
            if TAPCHECK {
                TAPCHECK = false
                time = 0
            }
        }
    }
    
    func resetTargets() {
        playAudio(name: "LevelPassed")
        
        targetBack.size.width = TARGET_BACK_INIT_WIDTH
        targetBack.size.height = TARGET_BACK_INIT_HEIGHT
        subTargetBack.size = CGSize(width: targetBack.size.width + 4, height: targetBack.size.width + 4)
        
        completions += 1
        
        score.text = "\(completions)"
        
        if completions % SPEED_CYCLE == 0 && Float(GROWTH_RATE) / Float(INIT_GROWTH_RATE) <= 1.6 {
            GROWTH_RATE *= 1.2
        }
        
        // RESIZE TARGET GRID
        if completions % CYCLES == 0 && sides < MAX_SIDES || sides == CYCLES * 3 {
            
            GROWTH_RATE = INIT_GROWTH_RATE
            
            if sides < MAX_SIDES {
                sides += 1
            }
                
            user.size.width = MAX_TARGET_BACK / CGFloat(sides) * 7 / 8
            user.size.height = MAX_TARGET_BACK / CGFloat(sides) * 7 / 8
            
            if sides % 2 == 0{
                
                let scalarX = Float(userX - sides / 2) + 0.5
                let scalarY = Float(userY - sides / 2) + 0.5
                
                user.position = CGPoint(x: targetBack.position.x + CGFloat(scalarX) * MAX_TARGET_BACK / CGFloat(sides),
                                        y:  targetBack.position.y + CGFloat(scalarY) * MAX_TARGET_BACK / CGFloat(sides))
                
            } else {
                
                let scalarX = userX - sides / 2
                let scalarY = userY - sides / 2
                
                user.position = CGPoint(x: targetBack.position.x + CGFloat(scalarX) * MAX_TARGET_BACK / CGFloat(sides),
                                        y:  targetBack.position.y + CGFloat(scalarY) * MAX_TARGET_BACK / CGFloat(sides))
            }
        }
        
        if sides == 4 && completions % CYCLES == 0 {
            
            // ADDING the square number 2
            
            if xSide.endIndex != 1 {
                xSide[1] = Int(arc4random_uniform(UInt32(sides)))
                ySide[1] = Int(arc4random_uniform(UInt32(sides)))
            } else{
                xSide.append(Int(arc4random_uniform(UInt32(sides))))
                ySide.append(Int(arc4random_uniform(UInt32(sides))))
            }
            
            let scalarX = xSide[1] - sides / 2
            let scalarY = ySide[1] - sides / 2
            
            targets[1].size = CGSize( width: Int(targetBack.size.width) / sides, height: Int(targetBack.size.height) / sides)
            
            targets[1].position = CGPoint(x: Int(targetBack.position.x) + scalarX * Int(targets[1].size.width),
                                          y: Int(targetBack.position.y) + scalarY * Int(targets[1].size.height))
            
            squares += 1
            self.addChild(targets[1])
        }
        
        if sides == 5 && completions % CYCLES == 0 && squares == 2 {
            // ADDING the square number 2
            
            if xSide.endIndex != 2 {
                xSide[2] = Int(arc4random_uniform(UInt32(sides)))
                ySide[2] = Int(arc4random_uniform(UInt32(sides)))
            } else{
                xSide.append(Int(arc4random_uniform(UInt32(sides))))
                ySide.append(Int(arc4random_uniform(UInt32(sides))))
            }
            
            let scalarX = xSide[2] - sides / 2
            let scalarY = ySide[2] - sides / 2
            
            targets[2].size = CGSize( width: Int(targetBack.size.width) / sides, height: Int(targetBack.size.height) / sides)
            
            targets[2].position = CGPoint(x: Int(targetBack.position.x) + scalarX * Int(targets[2].size.width),
                                          y: Int(targetBack.position.y) + scalarY * Int(targets[2].size.height))
            
            squares += 1
            self.addChild(targets[2])
        }
        
        if sides == 5 && completions == 3 * CYCLES {
            // ADDING the square number 3
            
            if xSide.endIndex != 3 {
                xSide[3] = Int(arc4random_uniform(UInt32(sides)))
                ySide[3] = Int(arc4random_uniform(UInt32(sides)))
            } else{
                xSide.append(Int(arc4random_uniform(UInt32(sides))))
                ySide.append(Int(arc4random_uniform(UInt32(sides))))
            }
            
            let scalarX = xSide[3] - sides / 2
            let scalarY = ySide[3] - sides / 2
            
            targets[3].size = CGSize( width: Int(targetBack.size.width) / sides, height: Int(targetBack.size.height) / sides)
            
            targets[3].position = CGPoint(x: Int(targetBack.position.x) + scalarX * Int(targets[3].size.width),
                                          y: Int(targetBack.position.y) + scalarY * Int(targets[3].size.height))
            
            squares += 1
            counter += 1
            self.addChild(targets[3])
        }
        
        
        for i in 0..<squares {
            ySide[i] = Int(arc4random_uniform(UInt32(sides)))
            xSide[i] = Int(arc4random_uniform(UInt32(sides)))
            if i != 0{
                var j = 0
                while j < i {
                    if ySide[i] == ySide[j] && xSide[i] == xSide[j]{
                        ySide[i] = Int(arc4random_uniform(UInt32(sides)))
                        xSide[i] = Int(arc4random_uniform(UInt32(sides)))
                        j = 0
                    }else{
                        j += 1
                    }
                }
            }
        }
        targetIndex = Int(arc4random_uniform(UInt32(squares)))
        user.texture = users[targetIndex]
    }
    
    func updateGame() {
        
        targetBack.size.width += GROWTH_RATE
        targetBack.size.height += GROWTH_RATE
        subTargetBack.size.width += GROWTH_RATE
        subTargetBack.size.height += GROWTH_RATE
        
        // RESIZE Squares
        for i in 0...squares - 1 {
            targets[i].size = CGSize( width: Int(targetBack.size.width) / sides, height: Int(targetBack.size.height) / sides)
            
            if sides % 2 == 0{
                let scalarX = Float(xSide[i] - sides / 2) + 0.5
                let scalarY = Float(ySide[i] - sides / 2) + 0.5
                targets[i].position = CGPoint(x: targetBack.position.x + CGFloat(scalarX) * targets[i].size.width,
                                              y: targetBack.position.y + CGFloat(scalarY) * targets[i].size.height)
            } else {
                let scalarX = xSide[i] - sides / 2
                let scalarY = ySide[i] - sides / 2
                targets[i].position = CGPoint(x: Int(targetBack.position.x) + scalarX * Int(targets[i].size.width),
                                              y: Int(targetBack.position.y) + scalarY * Int(targets[i].size.height))
            }
        }
    }
    
    func gameOverFunction() {
        // GAME OVER
        RESTART = true
        //(highScore)
        
        if completions > highScore || true {
            if completions >= BRONZE_MEDAL_SCORE && highScore < BRONZE_MEDAL_SCORE {
                BRONZECINEMATIC = true
            }
            if completions >= SILVER_MEDAL_SCORE && highScore < SILVER_MEDAL_SCORE {
                SILVERCINEMATIC = true
            }
            if completions >= GOLD_MEDAL_SCORE && highScore < GOLD_MEDAL_SCORE {
                GOLDCINEMATIC = true
            }
            
            userDefault.set(completions, forKey: "highscore")
            highScorePopup(old: highScore)
            highScore = completions
        }
        
        CONTINUE = false
        self.addChild(gameOver)
        self.addChild(restart)
        
        // TARGET
        popup.size = CGSize(width: MAX_TARGET_BACK, height: MAX_TARGET_BACK)
        
        self.addChild(popup)
        self.addChild(mainMenuButton)
    }

    func initNodes() {
        
        TOP_LR_BORDER =  self.frame.maxY - self.frame.height / 3
        BOTTOM_LR_BORDER = self.frame.minY + self.frame.height / 3
        INNER_RIGHT = self.frame.midX
        INNER_LEFT = self.frame.midX
        LEFT_UD = self.frame.midX - self.frame.width / 3
        RIGHT_UD = self.frame.midX + self.frame.width / 3
        LOWER_TOP = self.frame.maxY - self.frame.height / 3
        UPPER_BOTTOM = self.frame.minY + self.frame.height / 3
        
        center = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        background = SKSpriteNode(texture: SKTexture(imageNamed: "Background.png"), size: CGSize(width: self.frame.size.height * 0.8, height: self.frame.size.height))
        background.position = center
        background.zPosition = -4
        
        sides = INIT_SIDES
        
        sWidth = self.frame.width
        
        INIT_GROWTH_RATE = sWidth / 400
        
        print(INIT_GROWTH_RATE)
        
        GROWTH_RATE = INIT_GROWTH_RATE
        
        TARGET_BACK_INIT_HEIGHT = sWidth / 5
        TARGET_BACK_INIT_WIDTH = TARGET_BACK_INIT_HEIGHT
        MAX_TARGET_BACK = 3 * sWidth / 4
        
        targetBack = SKSpriteNode(color: UIColor(red: 0, green: 0, blue: 0 , alpha:1),
                                  size: CGSize(width:TARGET_BACK_INIT_WIDTH, height: TARGET_BACK_INIT_HEIGHT))
        targetBack.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        targetBack.zPosition = 0
        
        subTargetBack = SKSpriteNode(color: UIColor.red, size: CGSize(width: targetBack.size.width + 4,
                                                                      height: targetBack.size.height + 4))
        subTargetBack.position = center
        subTargetBack.zPosition = -1
        
        var square = SKTexture()
        var userz = SKTexture()
        
        // initializing targets
        
        for i in 0...3{
            var name1 : String?
            var name2 : String?
            
            switch i {
            case 1:
                name1 = "redSquare.png"
                name2 = "redUser.png"
            case 0:
                name1 = "blueSquare.png"
                name2 = "blueUser.png"
            case 2:
                name1 = "yellowSquare.png"
                name2 = "yellowUser.png"
            case 3:
                name1 = "greenSquare.png"
                name2 = "greenUser.png"
            default:
                break
            }
            
            square = SKTexture(imageNamed: name1!)
            userz = SKTexture(imageNamed: name2!)
            
            hole = SKSpriteNode(color: UIColor.black, size: CGSize(width: MAX_TARGET_BACK,
                                                                   height: MAX_TARGET_BACK))
            hole.position = CGPoint(x: self.frame.midX,y: self.frame.midY)
            hole.zPosition = -2
            
            subHole = SKSpriteNode(color: UIColor.red, size: CGSize(width: hole.size.width + 10,
                                                                    height: hole.size.height + 10))
            subHole.position = center
            subHole.zPosition = -3
            
            if i == 0 {
                
                // LEFT
                
                users[0] = userz
                
                user = SKSpriteNode(texture: userz)
                user.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                
                user.size.height = (MAX_TARGET_BACK / CGFloat(sides)) * 7 / 8
                user.size.width = (MAX_TARGET_BACK / CGFloat(sides)) * 7 / 8
                
                targets[i] = SKSpriteNode(texture: square)
                targets[i].position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                
                targets[i].size.height = TARGET_BACK_INIT_HEIGHT / CGFloat(sides)
                targets[i].size.width = TARGET_BACK_INIT_WIDTH / CGFloat(sides)
                
                user.zPosition = 1
            } else {
                
                targets.append(SKSpriteNode(texture: square))
                users.append(userz)
            }
        }
        
        popup = SKSpriteNode(color: UIColor(red: CGFloat( 0 ),green: CGFloat( 0 ),
                                            blue: CGFloat( 0 ), alpha: 1), size: CGSize(width: MAX_TARGET_BACK, height: MAX_TARGET_BACK))
        popup.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        popup.zPosition = 2
        
        skip = SKSpriteNode(texture: SKTexture(imageNamed: "skip.png"), size: CGSize(width: 100, height: 100))
        skip.position = CGPoint(x: self.frame.maxX - skip.size.width / 2, y: self.frame.minY + skip.size.height / 2)
        skip.name = "skip"
        skip.zPosition = 4
        
        play = SKSpriteNode(texture: SKTexture(imageNamed: "play.png"), size: CGSize(width: 100, height: 100))
        play.position = center
        play.name = "play"
        play.zPosition = 10
        
        pauseButton = SKSpriteNode(texture: SKTexture(imageNamed: "pause.png"), size: CGSize(width: 100, height: 100))
        pauseButton.position = CGPoint(x: self.frame.maxX - pauseButton.size.width / 2,
                                       y: self.frame.maxY - pauseButton.size.height / 2)
        pauseButton.name = "pause"
        pauseButton.zPosition = 4

        selectionBoxWhite = SKSpriteNode(color: UIColor.white, size: CGSize(width: 100, height: 50))
        selectionBoxWhite.position = CGPoint(x: center.x - 50, y: center.y + 50)
        selectionBoxWhite.name = "SwipeTap"
        selectionBoxWhite.zPosition = 4
        
        selectionBoxBlue = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 200, height: 50))
        selectionBoxBlue.position = CGPoint(x: center.x, y: center.y + 50)
        selectionBoxBlue.zPosition = 3
        
        swipeLabel.text = "swipe"
        swipeLabel.fontColor = UIColor.white
        swipeLabel.fontSize = 30
        swipeLabel.position = CGPoint(x: center.x + 50, y: center.y + 50 - 10)
        swipeLabel.zPosition = 5
        
        tapLabel.text = "tap"
        tapLabel.fontColor = UIColor.blue
        tapLabel.fontSize = 30
        tapLabel.position = CGPoint(x: center.x - 50, y: center.y + 50 - 10)
        tapLabel.zPosition = 5
        
        tapLabel.name = "Tap"
        swipeLabel.name = "Swipe"
        
        motionLabel.text = "Move"
        motionLabel.fontSize = 40
        motionLabel.position = CGPoint(x: center.x, y: selectionBoxBlue.position.y + 80)
        motionLabel.zPosition = 5
        
        sliderHeight = 10
        minSlider =  self.frame.minX + self.frame.width / 5
        maxSlider = self.frame.maxX - self.frame.width / 5
        volumeSliderHeight = self.frame.midY - 100
        
        volumeSliderNode[0] = SKSpriteNode(texture: SKTexture(imageNamed:"volumeNode.png"),
                                           size: CGSize(width: sliderHeight + 50 , height: sliderHeight + 50))
        volumeSliderNode[0].name = "volume\(0)"
        volumeSliderNode[0].zPosition = 5
        
        volumeSliderNode[0].position = CGPoint(x: minSlider + (maxSlider - minSlider) * CGFloat(volume), y: center.y - 100.0)
        
        blueSliderBox[0] = SKSpriteNode(color: UIColor.blue,
                                        size: CGSize(width: abs(minSlider - volumeSliderNode[0].position.x), height: sliderHeight))
        blueSliderBox[0].zPosition = 4
        
        whiteSliderBox[0] = SKSpriteNode(color: UIColor.white,
                                         size: CGSize(width: abs(maxSlider - volumeSliderNode[0].position.x), height: sliderHeight))
        whiteSliderBox[0].zPosition = 3
        
        blueSliderBox[0].position = CGPoint(x: (minSlider + volumeSliderNode[0].position.x) / 2,
                                            y: volumeSliderNode[0].position.y)
        whiteSliderBox[0].position = CGPoint(x: (maxSlider + volumeSliderNode[0].position.x) / 2,
                                             y: volumeSliderNode[0].position.y)
        
        if TAP {
            // Move nodes to tap position
            selectionBoxWhite.position.x = selectionBoxWhite.position.x + 100
            tapLabel.fontColor = UIColor.white
            swipeLabel.fontColor = UIColor.blue
        }
        
        settingsNodes[0] =  selectionBoxWhite
        settingsNodes.append(selectionBoxBlue)
        settingsLabels[0] = tapLabel
        settingsLabels.append(swipeLabel)
        settingsLabels.append(SFXLabel)
        settingsLabels.append(musicLabel)
        settingsLabels.append(motionLabel)
        settingsNodes.append(whiteSliderBox[0])
        settingsNodes.append(blueSliderBox[0])
        settingsNodes.append(volumeSliderNode[0])
        settingsNodes.append(popup)
        
        musicLabel.text = "Volume"
        musicLabel.fontColor = UIColor.white
        musicLabel.fontSize = 40
        musicLabel.position = CGPoint(x: center.x, y: volumeSliderNode[0].position.y + 50)
        musicLabel.zPosition = 4
        
        motionLabel.text = "Move"
        motionLabel.fontColor = UIColor.white
        motionLabel.fontSize = 40
        motionLabel.position = CGPoint(x: center.x, y: selectionBoxBlue.position.y + 60)
        motionLabel.zPosition = 4
        
        exit = SKSpriteNode(texture: SKTexture(imageNamed: "exit.png"), size: volumeSliderNode[0].size)
        exit.name = "exit"
        exit.zPosition = 10
        
        //Game Over
        score.text = "0"
        score.fontSize = 90
        score.color = UIColor(red:0, green:0, blue:0, alpha:1)
        score.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 150)
        
        gameOver.text = "Game Over"
        gameOver.fontSize = 60
        gameOver.fontColor = SKColor.green
        gameOver.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
        gameOver.zPosition = 3
        
        restart.text = "Replay"
        restart.fontSize = 45
        restart.fontColor = SKColor.green
        restart.position = CGPoint(x: self.frame.midX, y: gameOver.position.y - 100)
        restart.zPosition = 3
        
        mainMenuButton.text = "Main Menu"
        mainMenuButton.fontSize = 45
        mainMenuButton.fontColor = SKColor.green
        mainMenuButton.position = CGPoint(x: self.frame.midX, y: gameOver.position.y - 200)
        mainMenuButton.zPosition = 3
        
        hSPopup = SKSpriteNode(color: UIColor(red:60.0/255, green:60.0/255, blue:60.0/255, alpha:0.8), size: self.frame.size)
        hSPopup.position = center
        hSPopup.zPosition = 5
        
        hsLabelNode = SKSpriteNode(texture: SKTexture(imageNamed: "HighScoreLabel.png"),
                                   size: CGSize(width: MAX_TARGET_BACK, height: MAX_TARGET_BACK * 9 / 16 ))
        hsLabelNode.position = CGPoint(x: center.x , y: score.position.y - 100)
        hsLabelNode.zPosition = 10
    
        hSLabel.text = ""
        hSLabel.fontSize = score.fontSize
        hSLabel.fontColor = UIColor.white
        hSLabel.position = center
        hSLabel.zPosition = 6    }
    
    func restartGame(){
        
        sides = INIT_SIDES
        squares = 1
        
        userX = 1
        userY = 1
        user.size.width = (CGFloat(MAX_TARGET_BACK) / CGFloat(sides)) * 7 / 8
        user.size.height = (CGFloat(MAX_TARGET_BACK) / CGFloat(sides)) * 7 / 8
        user.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        user.texture = users[0]
        
        completions = 0
        score.text = "0"
        
        targetIndex = 0
        
        targetBack.size = CGSize(width: TARGET_BACK_INIT_WIDTH, height: TARGET_BACK_INIT_HEIGHT)
        subTargetBack.size = CGSize(width: TARGET_BACK_INIT_WIDTH + 4, height: TARGET_BACK_INIT_HEIGHT + 4)
        
        
        GROWTH_RATE = INIT_GROWTH_RATE
        removeChildren(in: targets)
        
        xSide[0] = Int(arc4random_uniform(UInt32(sides)))
        ySide[0] = Int(arc4random_uniform(UInt32(sides)))
        self.addChild(targets[0])
        
        restart.removeFromParent()
        gameOver.removeFromParent()
        mainMenuButton.removeFromParent()
        popup.removeFromParent()
        
        CONTINUE = true
        RESTART = false
        
    }
    
    func startGame() {
        
        sides = INIT_SIDES
        userX = sides / 2
        userY = sides / 2
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.addChild(background)
        self.addChild(hole)
        self.addChild(subHole)
        
        restartGame()
        
        self.addChild(user)
        self.addChild(score)
        self.addChild(subTargetBack)
        self.addChild(targetBack)
        self.addChild(pauseButton)
        if TAP{
            self.addChild(skip)
        }
    }
    
    func highScorePopup( old: Int){
        hSLabel.text = "\(old)"
        self.addChild(hSPopup)
        if GOLDCINEMATIC{
            hsLabelNode.texture = SKTexture(imageNamed: "GoldLabel.png")
        } else if SILVERCINEMATIC {
            hsLabelNode.texture = SKTexture(imageNamed: "SilverLabel.png")
        } else if BRONZECINEMATIC {
            hsLabelNode.texture = SKTexture(imageNamed: "BronzeLabel.png")
        } else {
            hsLabelNode.texture = SKTexture(imageNamed: "HighScoreLabel.png")
        }
        self.addChild(hsLabelNode)
        self.addChild(hSLabel)
        HIGHSCOREPOPUP = true
        RESTART = false
    }
    
    func hSCinematic(new: Int){
        hSLabel.text = "\(new)"
        playAudio(name: "Win")
    }

    func pause(){
        CONTINUE = false
        PAUSE = true
        settings()
        exit.removeFromParent()
        play.size = CGSize(width: 100, height: 100)
        play.position = pauseButton.position
        pauseButton.zPosition = 0
        self.addChild(play)
    }
    
    func settings(){
        // Add Settings nodes
        popup.size = CGSize(width: MAX_TARGET_BACK, height: MAX_TARGET_BACK)
        exit.position = CGPoint(x: popup.position.x + popup.size.width / 2 - exit.size.width / 2 - 10, y: popup.position.y + popup.size.height / 2 - exit.size.height / 2 - 10)
        
        self.addChild(exit)
        self.addChild(popup)
        for i in 0..<1{
            self.addChild(volumeSliderNode[i])
            self.addChild(blueSliderBox[i])
            self.addChild(whiteSliderBox[i])
        }
        self.addChild(selectionBoxWhite)
        self.addChild(selectionBoxBlue)
        self.addChild(swipeLabel)
        self.addChild(tapLabel)
        self.addChild(musicLabel)
        self.addChild(motionLabel)
    }
    
    func playAudio(name : String){
        
        var url: URL?
        var ext: String = ""
        
        if name == "LevelPassed" || name == "Next" || name == "Menu"{
            ext = "wav"
        }else if name == "LevelUp" || name == "Win"{
            ext = "mp3"
        }
        
        url = Bundle.main.url(forResource: name, withExtension: ext)!
        
        do{
            player = try AVAudioPlayer(contentsOf: url!)
            player.volume = volume
            player.play()
        }catch{}
    }
}
