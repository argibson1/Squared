//
//  MainMenu.swift
//  Squared2.0
//
//  Created by Alexander Gibson on 11/12/17.
//  Copyright © 2017 GibsonDesignGroup. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class MainMenu: SKScene {
    
    var TITLE_PROPORTIONALITY_CONSTANT : CGFloat = 7/18
    var TITLE_SIDE_ADJUSTMENT : CGFloat = 200
    var MAX_TARGET_BACK = CGFloat()
    var HALF_TARGET_BACK = CGFloat()
    var QUARTER_TARGET_BACK = CGFloat()
    
    var title = SKSpriteNode()
    var background = SKSpriteNode()
    
    var playLabel = SKSpriteNode()
    var playButton = SKSpriteNode()
    
    var leaderboardLabel = SKSpriteNode()
    var leaderboardButton = SKSpriteNode()
    
    var settingImg = SKSpriteNode()
    var settingsButton = SKSpriteNode()
    
    var helpLabel = SKSpriteNode()
    var helpButton = SKSpriteNode()
    
    // Settings Nodes
    
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
    
    var popup = SKSpriteNode()
    var exit =  SKSpriteNode()
    
    // Booleans
    
    var SETTINGS = false
    var TAP = false
    var SWIPE = true
    var MOVEVOLUME = false
    
    // MISC
    
    let userDefault = Foundation.UserDefaults.standard
    var highScore = 0
    var player = AVAudioPlayer()
    var volume : Float = 1
    
    override func didMove(to view: SKView) {
        scene?.scaleMode = SKSceneScaleMode.aspectFit
        let tap1 : Bool? = userDefault.bool(forKey: "tap")
        
        if tap1 == nil {
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
        
        self.backgroundColor = SKColor.black
        self.addChild(title)
        self.addChild(background)
        self.addChild(playLabel)
        self.addChild(playButton)
        self.addChild(leaderboardLabel)
        self.addChild(leaderboardButton)
        self.addChild(settingImg)
        self.addChild(settingsButton)
        self.addChild(helpLabel)
        self.addChild(helpButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : UITouch = touches.first!
        let location =  touch.location(in: self)
        let node: SKNode = self.atPoint(location)
        if node.name != nil {
            if SETTINGS {
                switch node.name!{
                case "volume0":
                    MOVEVOLUME = true
                case "exit":
                    for nodes in settingsNodes {
                        nodes.removeFromParent()
                    }
                    for labels in settingsLabels {
                        labels.removeFromParent()
                    }
                    SETTINGS = false
                default:
                    break
                }
                
                if TAP == false && node.name == "Tap"{
                    TAP = true
                    SWIPE = false
                    selectionBoxWhite.position.x = selectionBoxWhite.position.x + 100
                    tapLabel.fontColor = UIColor.white
                    swipeLabel.fontColor = UIColor.blue
                    userDefault.set(true, forKey: "tap")
                } else if SWIPE == false && node.name == "Swipe"{
                    TAP = false
                    SWIPE = true
                    selectionBoxWhite.position.x = selectionBoxWhite.position.x - 100
                    tapLabel.fontColor = UIColor.blue
                    swipeLabel.fontColor = UIColor.white
                    userDefault.set(false, forKey: "tap")
                } else if node.name == "SwipeTap"{
                    if SWIPE == true{
                        SWIPE = false
                        TAP = true
                        selectionBoxWhite.position.x = selectionBoxWhite.position.x + 100
                        tapLabel.fontColor = UIColor.white
                        swipeLabel.fontColor = UIColor.blue
                        userDefault.set(true, forKey: "tap")
                    } else{
                        TAP = false
                        SWIPE = true
                        selectionBoxWhite.position.x = selectionBoxWhite.position.x - 100
                        tapLabel.fontColor = UIColor.blue
                        swipeLabel.fontColor = UIColor.white
                        userDefault.set(false, forKey: "tap")
                    }
                    
                }
                
            } else {
                switch node.name! {
                case "play":
                    startGame()
                case "leaderboard":
                    leaderboard()
                case "settings":
                    settings()
                case "help":
                    help()
                default:
                    break
                }
            }
            playAudio(name: "Menu")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch : UITouch = touches.first!
        let location =  touch.location(in: self)
        
        if MOVEVOLUME { // a node is moving
            if MOVEVOLUME && location.x >= minSlider && location.x <= maxSlider{
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
        }
        
        volume = Float((volumeSliderNode[0].position.x - minSlider) / (maxSlider - minSlider))
        if volume < 0.05{
            volume = 0.0
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if MOVEVOLUME {
            userDefault.set(volume, forKey: "volume")
        }
        MOVEVOLUME = false
    }
    
    func initNodes(){
        MAX_TARGET_BACK = 3 * self.frame.size.width / 4
        HALF_TARGET_BACK = MAX_TARGET_BACK / 2
        QUARTER_TARGET_BACK = HALF_TARGET_BACK / 2
        
        let center = CGPoint(x: self.frame.midX, y: self.frame.midY)
    
        title = SKSpriteNode(texture: SKTexture(imageNamed: "Title.png"),
                             size: CGSize(width: self.frame.size.width - TITLE_SIDE_ADJUSTMENT, height: (self.frame.size.width - TITLE_SIDE_ADJUSTMENT) * TITLE_PROPORTIONALITY_CONSTANT ))
        title.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 150)
        title.zPosition = 1
    
        playLabel = SKSpriteNode(texture: SKTexture(imageNamed: "playButton.png"),
                                 size: CGSize(width: HALF_TARGET_BACK - 12, height: HALF_TARGET_BACK - 12))
        playLabel.name = "play"
        playLabel.position = CGPoint(x: self.frame.midX - QUARTER_TARGET_BACK,
                                     y: self.frame.midY + QUARTER_TARGET_BACK - 5)
        playLabel.zPosition = 1
    
        playButton = SKSpriteNode(texture: SKTexture(imageNamed: "blueSquare.png"),
                                  size: CGSize(width: HALF_TARGET_BACK - 12, height: HALF_TARGET_BACK - 12))
        playButton.name = "play"
        playButton.position = CGPoint(x: playLabel.position.x, y: playLabel.position.y + 5)
        playButton.zPosition = playLabel.zPosition - 1
    
        leaderboardLabel = SKSpriteNode(texture: SKTexture(imageNamed: "leaderBoard.png"), size: playButton.size)
        leaderboardLabel.name = "leaderboard"
        leaderboardLabel.position = CGPoint(x: playLabel.position.x + HALF_TARGET_BACK, y: playLabel.position.y)
        leaderboardLabel.zPosition = 1
    
        leaderboardButton = SKSpriteNode(texture: SKTexture(imageNamed: "redSquare.png"), size: playButton.size)
        leaderboardButton.name = "leaderboard"
        leaderboardButton.position = CGPoint(x: leaderboardLabel.position.x, y: playLabel.position.y + 5)
        leaderboardButton.zPosition = 0
    
        settingImg = SKSpriteNode(texture: SKTexture(imageNamed: "cog.png"), size: leaderboardLabel.size)
        settingImg.name = "settings"
        settingImg.position = CGPoint(x: playButton.position.x, y: self.frame.midY - QUARTER_TARGET_BACK + 2)
        settingImg.zPosition = 1
    
    
        settingsButton = SKSpriteNode(texture: SKTexture(imageNamed: "yellowSquare"), size: playLabel.size)
        settingsButton.position = settingImg.position
        settingsButton.name =  "settings"
        settingsButton.zPosition = 0
    
        helpLabel = SKSpriteNode(texture: SKTexture(imageNamed: "help.png"), size: playLabel.size)
        helpLabel.name = "help"
        helpLabel.position = CGPoint(x: leaderboardLabel.position.x, y: settingImg.position.y)
        helpLabel.zPosition = 1
    
        helpButton = SKSpriteNode(texture: SKTexture(imageNamed: "greenSquare.png"), size: playButton.size)
        helpButton.name = "help"
        helpButton.position = helpLabel.position
        helpButton.zPosition = 0
        
        background = SKSpriteNode(texture: SKTexture(imageNamed: "Background.png"), size: CGSize(width: self.frame.size.height * 0.8 , height: self.frame.size.height))
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.zPosition = -4
        
        
        // Settings Nodes
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
        
        // TODO: Make the boxes paint in the correct positions depending on TAP/SWIPE
        
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
        
        exit = SKSpriteNode(texture: SKTexture(imageNamed: "exit.png"), size: volumeSliderNode[0].size)
        exit.name = "exit"
        exit.zPosition = 10
        
        popup = SKSpriteNode(color: UIColor(red: CGFloat( 0 ),green: CGFloat( 0 ),
                                            blue: CGFloat( 0 ), alpha: 1), size: CGSize(width: MAX_TARGET_BACK, height: MAX_TARGET_BACK))
        popup.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        popup.zPosition = 2
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
        settingsNodes.append(exit)
        
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
        
    }
    
    func startGame(){
        // Change to GameScene
        let scene : SKScene = GameScene(size: self.size)
        self.view?.presentScene(scene, transition: SKTransition.init())
    }
    
    func leaderboard(){
        // Change to LeaderboardScene
        let scene : SKScene = LeaderboardScene(size: self.size)
        self.view?.presentScene(scene, transition: SKTransition.init())
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
        
        SETTINGS = true
    }
    
    func help(){
        // Change to HelpScene
        let scene : SKScene = HelpScene(size: self.size)
        self.view?.presentScene(scene, transition: SKTransition.init())
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
