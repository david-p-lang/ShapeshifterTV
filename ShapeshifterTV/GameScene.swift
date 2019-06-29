//
//  GameScene.swift
//  Shapeshifter
//
//  Created by David Lang on 6/9/15.
//  Copyright (c) 2015 David Lang. All rights reserved.
//

import SpriteKit
import AVFoundation

var player:SKNode!
var player2:SKNode!
var tapToStartNode:SKSpriteNode!
var HUDBackNode:SKSpriteNode!
var endLevelY = 0
var dragonFrames : [SKTexture]!
var coastFrames = [SKTexture]()
var firstFrame:SKTexture!
var restComplete = false
var restTimer:Timer!
var restedTime = 0
var theFlyingPoints:[SKLabelNode]!
var thePlayerSprite = SKSpriteNode()
var thePlayerSprite2 = SKSpriteNode()
var displayMenuItems = true

struct CollisionCategoryBitmask {
    static let Player: UInt32 = 0x00
    static let Star: UInt32 = 0x01
    static let Platform: UInt32 = 0x02
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var notification = NotificationCenter.default
    var backgroundNode: SKNode!
    var backgroundNode2: SKNode!
    var midgroundNode: SKNode!
    var midgroundNode2: SKNode!
    var foregroundNode: SKNode!
    var foregroundNode2: SKNode!
    var hudNode: SKNode!
    var floorNode: PlatformNode!
    
    var heartRateLabel = SKLabelNode(fontNamed: "Copperplate")
    var heartRateLabel2 = SKLabelNode(fontNamed: "Copperplate")
    var countdownLabel = SKLabelNode(fontNamed: "Copperplate")
    var HRLabel = SKLabelNode(fontNamed: "Copperplate")
    var HRLabel2 = SKLabelNode(fontNamed: "Copperplate")
    var CDLabel = SKLabelNode(fontNamed: "Copperplate")
    var easyButton = SKLabelNode(fontNamed: "Copperplate")
    var mediumButton = SKLabelNode(fontNamed: "Copperplate")
    var hardButton = SKLabelNode(fontNamed: "Copperplate")
    var boostLabel = SKLabelNode(fontNamed: "Arial")

    var theTimer:Timer!
    //var comRate = 0
    var comRate2 = 0
    var knownRate = theMonitor.currentHeartRate
    var knownRateP2 = 0
    var countdownRunning = false
    var countdown = 35
    var menuRecognizer:UIGestureRecognizer!
 
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        notification.addObserver(self, selector: "pauseGame:", name: NSNotification.Name(rawValue: "pause"), object: nil)
        notification.addObserver(self, selector: Selector("receiveRates:"), name: NSNotification.Name(rawValue: "heartRateBroadcast"), object: nil)

        buildLevel()
        
    }
    override init() {
        super.init()
        self.removeChildren(in: [countdownLabel, CDLabel, HRLabel, heartRateLabel])
        //buildLevel()
    }
    
    override func didMove(to view: SKView) {
        conqueredLevel = false
        print(self.view!.window?.rootViewController)
        self.removeChildren(in: [countdownLabel, CDLabel, HRLabel, heartRateLabel])
        menuRecognizer = UIGestureRecognizer(target: self, action: "menuTapped:")
        self.view?.addGestureRecognizer(menuRecognizer)
        /*if playerNumberChanged {
            buildLevel()
            playerNumberChanged = false
        } */

        //buildLevel()
    }
    func buildLayers() {
        modCoinBoost = coinBoost
        modHeartRateBoost = heartRateBoost
        modCloudBoost = cloudBoost
        if numberOfPlayers == 1 {
            backgroundNode = createBackgroundNode(numberOfPlayers: 1,currentPlayer: 0)
            backgroundNode.zPosition = -4
            addChild(backgroundNode)
        }
        
        if numberOfPlayers == 2 {
            backgroundNode = createBackgroundNode(numberOfPlayers: 2, currentPlayer: 1)
            backgroundNode.zPosition = -4
            addChild(backgroundNode)
            //backgroundNode2 = createBackgroundNode(2, currentPlayer: 1)
            //backgroundNode2.zPosition = -4
            //addChild(backgroundNode2)
            midgroundNode2 = createMidgroundNode()
            addChild(midgroundNode2)
            modCoinBoost = modCoinBoost * 0.15
            modHeartRateBoost = modHeartRateBoost * 0.15
            modCloudBoost = modCloudBoost * 0.4
        }
        
        // Midground
        midgroundNode = createMidgroundNode()
        midgroundNode.zPosition = -3
        addChild(midgroundNode)
        
        foregroundNode = SKNode()
        foregroundNode.zPosition = -2
        addChild(foregroundNode)
        
        // H U D
        hudNode = SKNode()
        hudNode.zPosition = -1
        addChild(hudNode)

    }
    func loadMPLevelData() {
        var levelPlist = Bundle.main.path(forResource: "MPLevel01", ofType: "plist")
        
        if currentLevel == 1 {
            levelPlist = Bundle.main.path(forResource:"MPLevel01", ofType: "plist")
        } else if currentLevel == 2 {
            levelPlist = Bundle.main.path(forResource:"MPLevel02", ofType: "plist")
        } else if currentLevel == 3 {
            levelPlist = Bundle.main.path(forResource:"MPLevel03", ofType: "plist")
        } else if currentLevel == 4 {
            levelPlist = Bundle.main.path(forResource:"MPLevel04", ofType: "plist")
        } else if currentLevel == 5 {
            levelPlist = Bundle.main.path(forResource:"MPLevel05", ofType: "plist")
        } else if currentLevel == 6 {
            levelPlist = Bundle.main.path(forResource:"MPLevel06", ofType: "plist")
        } else if currentLevel == 7 {
            levelPlist = Bundle.main.path(forResource:"MPLevel07", ofType: "plist")
        } else if currentLevel == 8 {
            levelPlist = Bundle.main.path(forResource:"MPLevel08", ofType: "plist")
        } else if currentLevel == 9 {
            levelPlist = Bundle.main.path(forResource:"MPLevel09", ofType: "plist")
        } else if currentLevel == 10 {
            levelPlist = Bundle.main.path(forResource:"MPLevel10", ofType: "plist")
        }
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        
        // Height at which the player ends the level
        endLevelY = levelData["EndY"]!.integerValue!
        
        let platforms = levelData["Platforms"] as! NSDictionary
        let platformPatterns = platforms["Patterns"] as! NSDictionary
        let platformPositions = platforms["Positions"] as! [NSDictionary]
        
        for platformPosition in platformPositions {
            //let patternX = platformPosition["x"]?.floatValue
            let patternY = platformPosition["y"]?.floatValue
            let pattern = platformPosition["pattern"] as! NSString
            
            // Look up the pattern
            let platformPattern = platformPatterns[pattern] as! [NSDictionary]
            for platformPoint in platformPattern {
                //let x = platformPoint["x"]?.floatValue
                let y = (platformPoint["y"]?.floatValue)! / 10.0
                let type = PlatformType(rawValue: platformPoint["type"]!.integerValue)
                //let positionX = CGFloat(x! + patternX!)
                let xMod = CGFloat(arc4random_uniform(49))
                let positionX1 = CGFloat(self.size.width/2.0 - 325 + xMod)
                let positionX2 = CGFloat(self.size.width/2.0 + 275 + xMod)
                let positionY = CGFloat(y + patternY!) / 10.0
                let sMod = CGFloat(arc4random_uniform(2)) / 1.0
                let platformNode = createPlatformAtPosition(CGPoint(x: positionX1, y: positionY), ofType: type!)
                platformNode.setScale(sMod)
                let platformNode2 = createPlatformAtPosition(CGPoint(x: positionX2, y: positionY), ofType: type!)
                platformNode2.setScale(sMod)
                if arc4random_uniform(2) > 0 {
                    midgroundNode.addChild(platformNode)
                } else {
                    midgroundNode.addChild(platformNode2)
                }
            }
        }
        
        // Add the stars
        let stars = levelData["Stars"] as! NSDictionary
        let starPatterns = stars["Patterns"] as! NSDictionary
        let starPositions = stars["Positions"] as! [NSDictionary]
        
        for starPosition in starPositions {
            //let patternX = starPosition["x"]?.floatValue
            let patternY = starPosition["y"]?.floatValue
            let pattern = starPosition["pattern"] as! NSString
            
            // Look up the pattern
            let starPattern = starPatterns[pattern] as! [NSDictionary]
            for starPoint in starPattern {
                //let x = starPoint["x"]?.floatValue
                let y = (starPoint["y"]?.floatValue)! / 10.0
                let type = StarType(rawValue: starPoint["type"]!.integerValue)
                //let positionX = CGFloat(x! + patternX!)
                let positionX1 = CGFloat(self.size.width/2.0 - 300)
                let positionX2 = CGFloat(self.size.width/2.0 + 300)
                let positionY = CGFloat(y + patternY!) / 5.0
                let starNode = createStarAtPosition(CGPoint(x: positionX1, y: positionY), ofType: type!)
                let starNode2 = createStarAtPosition(CGPoint(x: positionX2, y: positionY), ofType: type!)
                midgroundNode.addChild(starNode)
                midgroundNode.addChild((starNode2))
            }
        }
    }
    func loadLevelData() {
        var levelPlist = Bundle.main.path(forResource:"Level01", ofType: "plist")
        
        if currentLevel == 1 {
            levelPlist = Bundle.main.path(forResource:"Level01", ofType: "plist")
        } else if currentLevel == 2 {
            levelPlist = Bundle.main.path(forResource:"Level02", ofType: "plist")
        } else if currentLevel == 3 {
            levelPlist = Bundle.main.path(forResource:"Level03", ofType: "plist")
        } else if currentLevel == 4 {
            levelPlist = Bundle.main.path(forResource:"Level04", ofType: "plist")
        } else if currentLevel == 5 {
            levelPlist = Bundle.main.path(forResource:"Level05", ofType: "plist")
        } else if currentLevel == 6 {
            levelPlist = Bundle.main.path(forResource:"Level06", ofType: "plist")
        } else if currentLevel == 7 {
            levelPlist = Bundle.main.path(forResource:"Level07", ofType: "plist")
        } else if currentLevel == 8 {
            levelPlist = Bundle.main.path(forResource:"Level08", ofType: "plist")
        } else if currentLevel == 9 {
            levelPlist = Bundle.main.path(forResource:"Level09", ofType: "plist")
        } else if currentLevel == 10 {
            levelPlist = Bundle.main.path(forResource:"Level10", ofType: "plist")
        }
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        
        // Height at which the player ends the level
        endLevelY = levelData["EndY"]!.integerValue!
        
        let platforms = levelData["Platforms"] as! NSDictionary
        let platformPatterns = platforms["Patterns"] as! NSDictionary
        let platformPositions = platforms["Positions"] as! [NSDictionary]
        
        for platformPosition in platformPositions {
            //let patternX = platformPosition["x"]?.floatValue
            let patternY = platformPosition["y"]?.floatValue
            let pattern = platformPosition["pattern"] as! NSString
            
            // Look up the pattern
            let platformPattern = platformPatterns[pattern] as! [NSDictionary]
            for platformPoint in platformPattern {
                //let x = platformPoint["x"]?.floatValue
                let y = platformPoint["y"]?.floatValue
                let type = PlatformType(rawValue: platformPoint["type"]!.integerValue)
                //let positionX = CGFloat(x! + patternX!)
                let positionX = CGFloat(self.size.width/2.0)
                let positionY = CGFloat(y! + patternY!)
                let platformNode = createPlatformAtPosition(CGPoint(x: positionX, y: positionY), ofType: type!)
                midgroundNode.addChild(platformNode)
            }
        }
        
        // Add the stars
        let stars = levelData["Stars"] as! NSDictionary
        let starPatterns = stars["Patterns"] as! NSDictionary
        let starPositions = stars["Positions"] as! [NSDictionary]
        
        for starPosition in starPositions {
            //let patternX = starPosition["x"]?.floatValue
            let patternY = starPosition["y"]?.floatValue
            let pattern = starPosition["pattern"] as! NSString
            
            // Look up the pattern
            let starPattern = starPatterns[pattern] as! [NSDictionary]
            for starPoint in starPattern {
                //let x = starPoint["x"]?.floatValue
                let y = starPoint["y"]?.floatValue
                let type = StarType(rawValue: starPoint["type"]!.integerValue)
                //let positionX = CGFloat(x! + patternX!)
                let positionX = CGFloat(self.size.width/2.0)
                let positionY = CGFloat(y! + patternY!)
                let starNode = createStarAtPosition(CGPoint(x: positionX, y: positionY), ofType: type!)
                midgroundNode.addChild(starNode)
            }
        }
    }
    func buildPlayer() {
        let dragonAtlas = SKTextureAtlas(named: "dragonAnim")
        var dragonFrames = [SKTexture]()
    
        let numImages = dragonAtlas.textureNames.count - 1
        for i in 0...numImages-1 {
        let dragonName = String(format: "dragonFlyAnim%02d" ,i + 1)
        //print(dragonName)
        dragonFrames.append(dragonAtlas.textureNamed(dragonName))
        }
        var firstFrame = dragonFrames[0]
    
        let anim = SKAction.animateWithTextures(dragonFrames, timePerFrame: 0.05)
        let anim.timingMode = SKActionTimingMode.EaseInEaseOut
        thePlayerSprite = SKSpriteNode(texture: firstFrame)
        thePlayerSprite.runAction(SKAction.repeatActionForever(anim))
        //thePlayerSprite.setScale(0.5)
        //thePlayerSprite.setScale(scaleFactor)
        
        player = createPlayer(numberOfPlayers, currentPlayer: 1)
        thePlayerSprite.position = player.position
        foregroundNode.addChild(player)
        foregroundNode.addChild(thePlayerSprite)
        if numberOfPlayers > 1 {
            player2 = createPlayer(numberOfPlayers, currentPlayer: 2)
            //thePlayerSprite2.position = player2.position
            thePlayerSprite2 = SKSpriteNode(texture: firstFrame)
            thePlayerSprite2.runAction(SKAction.repeatActionForever(anim))
            foregroundNode.addChild(player2)
            foregroundNode.addChild(thePlayerSprite2)
            print("player2 created")
            thePlayerSprite.setScale(0.2)
            thePlayerSprite2.setScale(0.2)
        }

    }
    func buildHUD() {
        CDLabel.fontSize = 70
        CDLabel.fontColor = SKColor.whiteColor()
        CDLabel.position = CGPoint(x: self.size.width / 1.2, y: self.size.height / 1.2)
        CDLabel.text = "Countdown"
        hudNode.addChild(CDLabel)
        
        HRLabel.fontSize = 70
        HRLabel.fontColor = SKColor.whiteColor()
        HRLabel.position = CGPoint(x: self.size.width / 7 , y: self.size.height / 1.2)
        HRLabel.text = "Heart Rate"
        hudNode.addChild(HRLabel)
        
        heartRateLabel.fontSize = 130
        heartRateLabel.fontColor = SKColor.whiteColor()
        heartRateLabel.position = CGPoint(x: self.size.width / 7, y: self.size.height / 1.35)
        heartRateLabel.text =  String(theMonitor.currentHeartRate)
        hudNode.addChild(heartRateLabel)
        
        countdownLabel.fontSize = 130
        countdownLabel.fontColor = SKColor.whiteColor()
        countdownLabel.position = CGPoint(x: self.size.width / 1.2, y: self.size.height / 1.35)
        countdownLabel.text = String(countdown)
        hudNode.addChild(countdownLabel)
        
        boostLabel.fontSize = 50
        boostLabel.fontColor = SKColor.whiteColor()
        boostLabel.alpha = 0.1
        boostLabel.position = CGPoint(x: self.size.width / 4.0, y: 10)
        boostLabel.text = "HR boost:" + String(modHeartRateBoost) + " coin boost:" + String(modCoinBoost) + "HR1P:" + String(theMonitor.currentHeartRate)
        hudNode.addChild(boostLabel)
 
        if numberOfPlayers == 2 {
            
            HRLabel2.fontSize = 70
            HRLabel2.fontColor = SKColor.whiteColor()
            HRLabel2.position = CGPoint(x: self.size.width / 1.2 , y: self.size.height / 1.2)
            HRLabel2.text = "Heart Rate"
            hudNode.addChild(HRLabel2)
            
            heartRateLabel2.fontSize = 130
            heartRateLabel2.fontColor = SKColor.whiteColor()
            heartRateLabel2.position = CGPoint(x: self.size.width / 1.2, y: self.size.height / 1.35)
            heartRateLabel2.text =  String(theSecondMonitor.currentHeartRate)
            hudNode.addChild(heartRateLabel2)
            countdownLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.2)
            CDLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.35)
            CDLabel.fontColor = SKColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            countdownLabel.fontColor = SKColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)

            
        }
    }
    func buildMultiPlayerLevel() {
        
    }
    func buildLevel() {
        self.removeChildrenInArray([countdownLabel, CDLabel, HRLabel, heartRateLabel])

        print("build level " + String(stringInterpolationSegment: conqueredLevel))
        conqueredLevel = false
        playing = true
        if musicShouldPlay == true {
            backgroundMusicPlayer.play()
        }
        
        
        if currentLevel > 1 {
            self.removeChildrenInArray([countdownLabel, CDLabel, HRLabel, heartRateLabel])
            score = 0.0
            scoreP2 = 0.0
        }
        
        buildLayers()
        if numberOfPlayers > 1 {
            loadMPLevelData()
            knownRateP2 = theSecondMonitor.currentHeartRate
        } else {
            loadLevelData()
        }
        buildPlayer()
        buildHUD()
 
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.2)
        physicsWorld.contactDelegate = self
        
        let block = SKSpriteNode(imageNamed: "Block")
        floorNode = PlatformNode()
        floorNode.platformType = PlatformType.Normal
        floorNode.position = CGPoint(x: self.size.width/2, y: -10)
        floorNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 1920, height: 30))
        floorNode.physicsBody?.dynamic = false
        floorNode.physicsBody?.restitution = 0
        floorNode.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Platform
        floorNode.physicsBody?.collisionBitMask = 0
        floorNode.addChild(block)
        floorNode.alpha = 0.1
        midgroundNode.addChild(floorNode)
        
        
        theTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "motivator", userInfo: nil, repeats: true)
        countdown = 35
    }
    
    func createBackgroundNode(numberOfPlayers: Int, currentPlayer: Int) -> SKNode {
        // 1
        // Create the node
        let backgroundNode = SKNode()
        if numberOfPlayers == 1 {
            if currentLevel <= 11 {
                for index in 0...10 {
                    var node = SKSpriteNode()
                    if currentLevel <= 10 && index == 0 {
                        node = SKSpriteNode(imageNamed: "ground01")
                        node.setScale(1.0)
                    }   else if currentLevel <= 10 && index > 0 {
                        node = SKSpriteNode(imageNamed: "sky01")
                        node.setScale(1.0)
                    }
                    //node.setScale(0.72)
                    node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
                    node.position = CGPoint(x: self.size.width / 2, y: self.size.height * CGFloat(index))
                    backgroundNode.addChild(node)
                }
            }
        }
        if numberOfPlayers == 2 && currentPlayer == 1 {
                var node = SKSpriteNode()
                node = SKSpriteNode(imageNamed: "ground01")
                node.setScale(1.0)
                //node.position = CGPoint(x: 0, y: self.size.height * CGFloat(index))
                node.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)

                backgroundNode.addChild(node)
           

        }
        /*if numberOfPlayers == 2 && currentPlayer == 2 {
            for index in 0...10 {
                var node = SKSpriteNode()
                if currentLevel == 1 && index == 0 {
                    node = SKSpriteNode(imageNamed: "ground01")
                    node.setScale(1.0)
                }   else if currentLevel == 1 && index > 0 {
                    node = SKSpriteNode(imageNamed: "sky01")
                    node.setScale(1.0)
                }
                //node.setScale(0.72)
                node.position = CGPoint(x:self.size.width, y: self.size.height * CGFloat(index))
                backgroundNode.addChild(node)
            }
        }*/
        return backgroundNode
    }
    
    func createPlayer(numberOfPlayers: Int, currentPlayer: Int) -> SKNode {
        let playerNode = SKNode()
        if numberOfPlayers == 1 {
            playerNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 4)
            playerNode.name = "PLAYER_1"
        } else {
            if currentPlayer == 1 {
                playerNode.position = CGPoint(x: self.size.width / 2 - 300, y: self.size.height/10)
                print("player1 position set")
                playerNode.name = "PLAYER_1"
            } else if currentPlayer == 2 {
                playerNode.position = CGPoint(x: self.size.width / 2 + 300, y: self.size.height/10)
                print("player 2 position set")
                playerNode.name = "PLAYER_2"
            }
        }
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: thePlayerSprite.size.width/3)
        playerNode.physicsBody?.dynamic = false
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.restitution = 0
        playerNode.physicsBody?.friction = 0.0
        playerNode.physicsBody?.angularDamping = 0.0
        playerNode.physicsBody?.linearDamping = 0.0
        playerNode.physicsBody?.usesPreciseCollisionDetection = false
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Player
        playerNode.physicsBody?.collisionBitMask = 0
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryBitmask.Star | CollisionCategoryBitmask.Platform
        playerNode.physicsBody?.dynamic = true
        playerNode.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 300.0))
        if countdownRunning == false {
            countdownRunning = true
        }
        
        return playerNode
    }
   
    func menuTapped(sender: UITapGestureRecognizer) {
        //self.view!.window!.rootViewController?.performSegueWithIdentifier("menuSegue", sender: nil)
        print("menu has been pressed")
      
    }
    /*override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for item in presses {
            if item.type == .Select {
                self.view!.backgroundColor = UIColor.greenColor()
                print("select pressed")
            }
            if item.type == .Menu {
                //self.view!.window!.rootViewController?.performSegueWithIdentifier("menuSegue", sender: self)
                //print("menu pressed")
            }
            if item.type == .PlayPause {
                if playing == true {
                    player.physicsBody?.dynamic = false
                    countdownRunning = false
                } else {
                    print("pp pressed")
                    player.physicsBody?.dynamic = true
                    countdownRunning = true
                    
                }
            }
        }
    } */
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for item in presses {
            switch item.type {
            case .Select:
                self.view!.backgroundColor = UIColor.greenColor()
                print("select pressed")
            case .Menu: //break
                print("GAME SCENE MENU PRESS HANDLING")
                //self.view?.window?.rootViewController?.performSegueWithIdentifier("menuSegue", sender: self)
                //print("menu pressed")
                //performSegueWithIdentifier("menuSegue", sender: self)

            case .PlayPause:
                if playing == true {
                    player.physicsBody?.dynamic = false
                    countdownRunning = false
                } else {
                    print("pp pressed")
                    player.physicsBody?.dynamic = true
                    countdownRunning = true
                }
            default: break
            }
        }
    }
    func pauseGame(notification: NSNotification) {
        if playing == true {
            player.physicsBody?.dynamic = false
            countdownRunning = false
            print("paused from within gamescene via gvc")
            player.paused = true
            thePlayerSprite.paused = true
            scene?.paused = true
            playing = false
            print("\(playing)  \(theGameContext)")
            backgroundMusicPlayer.pause()
        } else {
            print("pp pressed")
            player.physicsBody?.dynamic = true
            countdownRunning = true
            player.paused = false
            thePlayerSprite.paused = false
            scene?.paused = false
            playing = true
            print("\(playing)  \(theGameContext)")
            if musicShouldPlay == true {
                backgroundMusicPlayer.play()
            }
        }

    }
    
    // T O U C H E S  B E G A N
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* if player.physicsBody!.dynamic {
        return
        }
        tapToStartNode.removeFromParent()
        player.physicsBody?.dynamic = true
        player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 40.0))
        if countdownRunning == false {
        countdownRunning = true
        } */
        let touch: UITouch = touches.first!
        let location = touch.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
    }
    
    func createStarAtPosition(position: CGPoint, ofType type: StarType) -> StarNode {
        let node = StarNode()
        let thePosition = CGPoint(x: position.x, y: position.y)
        node.position = thePosition
        node.name = "NODE_STAR"
        node.starType = type
        var sprite: SKSpriteNode
        if type == .Special {
            sprite = SKSpriteNode(imageNamed: "Coin02")
            if numberOfPlayers == 1 {
                sprite.setScale(0.3)
            } else if numberOfPlayers == 2 {
                sprite.setScale(0.09)
            }
        } else {
            sprite = SKSpriteNode(imageNamed: "Coin01")
            if numberOfPlayers == 1 {
                sprite.setScale(0.3)
            } else if numberOfPlayers == 2 {
                sprite.setScale(0.09)
            }
        }
        node.addChild(sprite)
        if numberOfPlayers == 1 {
            node.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        } else {
            node.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 7)

        }
        node.physicsBody?.dynamic = false
        node.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Star
        node.physicsBody?.collisionBitMask = 0
        
        return node
    }
    func didBeginContact(contact: SKPhysicsContact) {
        var launchPointDisplay = false
        var launchPointDisplayP2 = false
        
        print("bodyA " + "\(contact.bodyA.node?.name)")
        print("bodyB " + "\(contact.bodyB.node?.name)")
        if contact.bodyA.node?.name == "PLAYER_1" || contact.bodyB.node?.name == "PLAYER_1" {
            let whichNode = (contact.bodyA.node != player) ? contact.bodyA.node : contact.bodyB.node
            let other = whichNode as! GameObjectNode
            launchPointDisplay = other.collisionWithPlayer(player)
            print("PLAYER 1 CONTACT DETECTED")
        }
        if numberOfPlayers == 1 {
            if launchPointDisplay {
                let addScore = Double(5 * scoreMultiplier)
                score = score + addScore
                let flyDisplay = createFlyingPoints(addScore, playerObj: player)
                flyDisplay.zPosition = 3
                hudNode.addChild(flyDisplay)
                let wait = SKAction.waitForDuration(2.0)
                let remove = SKAction.runBlock({
                    flyDisplay.removeFromParent()
                })
                let sequence = SKAction.sequence([wait, remove])
                runAction(sequence)

            }
        }
        if numberOfPlayers == 2 {
           if launchPointDisplay {
                let addScore = Double(5 * scoreMultiplier)
                score = score + addScore
                //print("PLAYER 1 SCORE ADDED " + String(score))
                let flyDisplay = createFlyingPoints(addScore, playerObj: player)
                flyDisplay.zPosition = 3
                hudNode.addChild(flyDisplay)
                let wait = SKAction.waitForDuration(2.0)
                let remove = SKAction.runBlock({
                flyDisplay.removeFromParent()
                })
                let sequence = SKAction.sequence([wait, remove])
                runAction(sequence)

            }
            if contact.bodyA.node?.name == "PLAYER_2" || contact.bodyB.node?.name == "PLAYER_2" {
                print("PLAYER 2 CONTACT DETECTED")

                if let whichNodeP2 = (contact.bodyA.node != player2) ? contact.bodyA.node : contact.bodyB.node {
                    let otherP2 = whichNodeP2 as! GameObjectNode
                    launchPointDisplayP2 = otherP2.collisionWithPlayer(player2)
                }
                if launchPointDisplayP2 {
                    let addScoreP2 = Double(5 * scoreMultiplier)
                    scoreP2 = scoreP2 + addScoreP2
                    print("PLAYER 2 SCORE ADDED " + String(scoreP2))
                    let flyDisplay = createFlyingPoints(addScoreP2, playerObj: player2)
                    flyDisplay.zPosition = 3
                    hudNode.addChild(flyDisplay)
                    let wait = SKAction.waitForDuration(2.0)
                    let remove = SKAction.runBlock({
                        flyDisplay.removeFromParent()
                    })
                    let sequence = SKAction.sequence([wait, remove])
                    runAction(sequence)
                }
            }
        }
    }
    func createFlyingPoints(addScore: Double, playerObj: SKNode) -> SKLabelNode {
        let launchPoints = SKLabelNode(text: String(Int(addScore)))
        launchPoints.fontSize = 50
        launchPoints.fontColor = SKColor.yellowColor()
        if numberOfPlayers == 1 {
            launchPoints.position = CGPoint(x: self.size.width / 2.0, y: self.size.height / 2.0)
        } else if numberOfPlayers == 2 {
            launchPoints.position = playerObj.position
        }
        launchPoints.physicsBody = SKPhysicsBody(circleOfRadius: launchPoints.frame.size.width/2)
        launchPoints.physicsBody?.dynamic = true
        launchPoints.physicsBody?.allowsRotation = false
        launchPoints.physicsBody?.restitution = 0.0
        launchPoints.physicsBody?.friction = 1.0
        launchPoints.physicsBody?.density = 1.0
        launchPoints.physicsBody?.angularDamping = 1.0
        launchPoints.physicsBody?.linearDamping = 1.0
        launchPoints.physicsBody?.affectedByGravity = true
        launchPoints.physicsBody?.categoryBitMask = 0
        if playerObj.name == "PLAYER_1" {
            launchPoints.physicsBody?.velocity = CGVector(dx: -350.0, dy: 150.0)
        }
        if playerObj.name == "PLAYER_2" {
            launchPoints.physicsBody?.velocity = CGVector(dx: 350.0, dy: 150.0)
        }
        return launchPoints
    }
    func createPlatformAtPosition(position: CGPoint, ofType type: PlatformType) -> PlatformNode {
        let node = PlatformNode()
        let thePosition = CGPoint(x: position.x, y: position.y)
        node.position = thePosition
        node.name = "NODE_PLATFORM"
        node.platformType = type
        var sprite: SKSpriteNode
        if type == .Break {
            sprite = SKSpriteNode(imageNamed: "Cloud04")
            if numberOfPlayers == 1 {
                sprite.setScale(1.0)
            } else if numberOfPlayers == 2 {
                sprite.setScale(0.3)
            }
        } else {
            let cloudSelect = arc4random_uniform(3)
            switch cloudSelect {
            case 0: sprite = SKSpriteNode(imageNamed: "Cloud03")
            case 1: sprite=SKSpriteNode(imageNamed: "Cloud5")
            case 2: sprite=SKSpriteNode(imageNamed: "Cloud6")
            case 3: sprite=SKSpriteNode(imageNamed: "Cloud7")
            default: sprite = SKSpriteNode(imageNamed: "Cloud03")
            }
            if numberOfPlayers == 1 {
                sprite.setScale(1.0)
            } else if numberOfPlayers == 2 {
                sprite.setScale(0.4 + CGFloat(arc4random_uniform(3)) / 5)
            }
        }
        node.addChild(sprite)
        node.setScale(1.0)
        node.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: sprite.size.width, height: sprite.size.height / 3.0))
        node.physicsBody?.dynamic = false
        node.physicsBody?.restitution = 0
        node.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Platform
        node.physicsBody?.collisionBitMask = 0
        return node
    }
    
    func createMidgroundNode() -> SKNode {
        let theMidgroundNode = SKNode()
        //var anchor: CGPoint!
        var xPosition: CGFloat!
        
        for index in 0...9 {
            var spriteName: String
            let r = arc4random() % 2
            if r > 0 {
                spriteName = "Cloud01"
                xPosition = self.size.width - CGFloat(arc4random_uniform(300))
            } else {
                spriteName = "Cloud02"
                xPosition = 0.0 + CGFloat(arc4random_uniform(300))
            }
            let branchNode = SKSpriteNode(imageNamed: spriteName)
            let aMod = CGFloat(arc4random_uniform(10)) * 0.1
            branchNode.alpha = aMod
            let sMod = CGFloat(arc4random_uniform(1)) * 0.2
            branchNode.setScale(sMod)
            branchNode.position = CGPoint(x: xPosition, y: CGFloat((CGFloat(arc4random_uniform(100)) + CGFloat(400.0)) * CGFloat(index)) + 350.0)
            theMidgroundNode.addChild(branchNode)
        }
        
        return theMidgroundNode
    }
    
    func showWinNode()  {
        levelsConquered = levelsConquered + 1
        allTimeScore = allTimeScore + score
        sessionScore = sessionScore + score
        sessionScoreP2 = sessionScoreP2 + scoreP2
        backgroundMusicPlayer.advanceToNextItem()
        let theCurrentItem:AVPlayerItem = musicItemList.removeAtIndex(0)
        backgroundMusicPlayer.pause()
        musicItemList.append(theCurrentItem)
        let secondScene = WinScene(size: self.size)
        let transition = SKTransition.flipVerticalWithDuration(1.0)
        secondScene.scaleMode = SKSceneScaleMode.ResizeFill
        self.scene!.view?.presentScene(secondScene, transition: transition)
        scene?.paused = true
        conqueredLevel = true
        countdownRunning = false
        //restTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "checkRest", userInfo: nil, repeats: true)
        if currentLevel <= 10 {
            currentLevel += 1
        } else {
            currentLevel = 1
        }
        resetLevel()
        
    }
    
    func checkRest() {
        restedTime += 1
        if restedTime >= 5 {
            resetLevel()
        }
    }
    func resetLevel() {
        self.removeChildrenInArray([countdownLabel, CDLabel, HRLabel, heartRateLabel])
        //buildLevel()
        //restTimer.invalidate()
        theTimer.invalidate()
        restedTime = 0
        conqueredLevel = false
    }
    func motivator(){
        boostLabel.text = "HR boost:" + String(modHeartRateBoost) + " coin boost:" + String(modCoinBoost) + " HR1P:" + String(theMonitor.currentHeartRate) + " HR2P:" + String(theSecondMonitor.currentHeartRate) + " END LVL Y " + String(endLevelY) + " P1 Y POS " + String(Int(player.position.y))

        if countdownRunning == true {
            print("theMonitor hr \(theMonitor.currentHeartRate)")
            if theSecondMonitor != nil {
                //theSecondMonitor.currentHeartRate += 1
                print("theSecondmonitor hr \(theSecondMonitor.currentHeartRate)")
            }
            countdown -= 1
            countdownLabel.text = String(countdown)
            
            if countdown < 6 {
                countdownLabel.fontSize = 125
            }
            
        }
        if theMonitor.currentHeartRate >= knownRate {
            var deltaRate:CGFloat = CGFloat(theMonitor.currentHeartRate) - CGFloat(knownRate)
            if deltaRate > 3 {
                deltaRate = 3
            }
            let yVector = deltaRate * modHeartRateBoost
            
            if player.physicsBody?.velocity.dy < 40 {
                player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy:  yVector * 0.9))
            } else if player.physicsBody?.velocity.dy >= 40 && player.physicsBody?.velocity.dy < 400 {
                player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy:  yVector * 0.4))
                //println("med velocity" + String(stringInterpolationSegment: player.physicsBody?.velocity.dy))
                //println(String(stringInterpolationSegment: yVector * 0.5))
            } else if player.physicsBody?.velocity.dy >= 400 {
                player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy:  yVector * 0.2))

                //println("high velocity" + String(stringInterpolationSegment: player.physicsBody?.velocity.dy))
                //println(String(stringInterpolationSegment: -yVector * 0.5))
            }
        }
        knownRate = theMonitor.currentHeartRate
        if theSecondMonitor != nil {
            if theSecondMonitor.currentHeartRate >= knownRateP2 {
                var deltaRate:CGFloat = CGFloat(theSecondMonitor.currentHeartRate) - CGFloat(knownRateP2)
                if deltaRate > 3 {
                    deltaRate = 3
                }
                let yVector = deltaRate * modHeartRateBoost
                if player2 != nil {
                    if player2.physicsBody?.velocity.dy < 40 {
                        player2.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy:  yVector * 0.9))
                    } else if player2.physicsBody?.velocity.dy >= 40 && player2.physicsBody?.velocity.dy < 400 {
                        player2.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy:  yVector * 0.4))
                    } else if player2.physicsBody?.velocity.dy >= 400 {
                        player2.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy:  yVector * 0.2))

                    }
                }
            }
            knownRateP2 = theSecondMonitor.currentHeartRate

        }

    }
    
    override func update(currentTime: NSTimeInterval) {
        heartRateLabel.text = String(theMonitor.currentHeartRate)
        heartRateLabel2.text = String(comRate2)

        if player != nil {
            thePlayerSprite.position = player.position
            if numberOfPlayers == 1 {
                if player.position.y > 250.0 {
                    backgroundNode.position = CGPoint(x: 0.0, y: -((player.position.y - 250.0))) ///10))
                    midgroundNode.position = CGPoint(x: 0.0, y: -((player.position.y - 250.0)))  ///4))
                    foregroundNode.position = CGPoint(x: 0.0, y: -(player.position.y - 250.0))
                }
                if Int(player.position.y) >= (endLevelY - 50) && conqueredLevel == false {
                    player.physicsBody?.dynamic = false
                    showWinNode()
                }
            }
            if numberOfPlayers == 2 {
                if Int(player.position.y) >= Int(self.size.height - 20) && conqueredLevel == false {
                    player.physicsBody?.dynamic = false
                    if player2 != nil {
                        player2.physicsBody?.dynamic = false
                    }
                    player1Won = true
                    showWinNode()
                } else if player2 != nil && Int(player2.position.y) >= Int(self.size.height - 20) && conqueredLevel == false {
                    player.physicsBody?.dynamic = false
                    player2.physicsBody?.dynamic = false
                    player1Won = false
                    showWinNode()
                }
            }
        }
        if player2 != nil {
           
            thePlayerSprite2.position = player2.position
            /*if player2.position.y > player.position.y + 400.0 {
                player.position.y = player2.position.y - 400.0 //physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 10.0))
            }
            if player.position.y > player2.position.y + 400.0 {
                player2.position.y = player.position.y - 400.0//physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 10.0))
            }
            //if player2.position.y > player.position.y {
            if player2.position.y > 250.0 {
                backgroundNode2.position = CGPoint(x: 960.0, y: -(player.position.y - 500.0))
                midgroundNode2.position = CGPoint(x: 960.0, y: -(player.position.y - 500.0))
                //foregroundNode.position = CGPoint(x: 960.0, y: -(player.position.y - 500.0))
            } */
            //} else {
            /*    if player.position.y > 250.0 {
                    backgroundNode.position = CGPoint(x: 0.0, y: -((player.position.y - 250.0)))
                    midgroundNode.position = CGPoint(x: 0.0, y: -((player.position.y - 250.0)))
                    foregroundNode.position = CGPoint(x: 0.0, y: -(player.position.y - 250.0))
                }
            }
            //if player.position.y > 250.0 && player.position.y >= player2.position.y {
            //    backgroundNode.position = CGPoint(x: 0.0, y: -((player.position.y - 250.0)))
            //    midgroundNode.position = CGPoint(x: 0.0, y: -((player.position.y - 250.0)))
            //    foregroundNode.position = CGPoint(x: 0.0, y: -(player.position.y - 250.0))
            //}
            if Int(player2.position.y) >= (endLevelY - 50) && conqueredLevel == false {
                player2.physicsBody?.dynamic = false
                showWinNode()
            } */
        }
        if self.countdown == -1 && conqueredLevel == false {
            showFailScene()
        }
    }
    func showFailScene() {
        //backgroundMusicPlayer.advanceToNextItem()
        backgroundMusicPlayer.pause()
        theTimer.invalidate()
        let nextScene = FailScene(size: self.size)
        nextScene.scaleMode = SKSceneScaleMode.ResizeFill
        self.scene!.view?.presentScene(nextScene)
    }
    func receiveRates(notification: NSNotification){
        var theHeartRateMessage:heartRateMessage = (notification.userInfo?["message"])! as! heartRateMessage
        if theSecondMonitor != nil {
            if theSecondMonitor.serialNumber == theHeartRateMessage.serialNumber {
                print("the second monitor theheartrtmsg \(theHeartRateMessage.serialNumber)")
                print("the second monitor theheartrtmsg \(theHeartRateMessage.theHeartRate)")
                //print(theSecondMonitor.currentHeartRate)
                comRate2 = theHeartRateMessage.theHeartRate
                print(comRate2)
            }
        }
        if theMonitor.serialNumber == theHeartRateMessage.serialNumber {
            //print("the monitor serial number \(theMonitor.serialNumber)  theheartrtmsg \(theHeartRateMessage.serialNumber)")
           // print("the monitor hr \(theMonitor.currentHeartRate)  theheartrtmsg \(theHeartRateMessage.theHeartRate)")
           // print(theMonitor.currentHeartRate)
            //comRate = theHeartRateMessage.theHeartRate
        }
        
    }

