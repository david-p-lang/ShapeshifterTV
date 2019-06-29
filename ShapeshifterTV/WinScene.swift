//
//  WinScene.swift
//  ShapeshifterTV
//
//  Created by David Lang on 9/13/15.
//  Copyright © 2015 David Lang. All rights reserved.
//

import SpriteKit
import AVFoundation

class WinScene: SKScene {
    var myLabel:SKLabelNode!
    var backgroundNode = SKSpriteNode()
    var selectedFontSize:CGFloat = 32.0
    var regularFontSize:CGFloat = 28.0
    var failScreenTimer:NSTimer!
    var failCount = restTime
    var timerDisplay = SKLabelNode(fontNamed: "Copperplate")
    var timerDisplayLabel = SKLabelNode(fontNamed: "Copperplate")
    var scoreDisplay = SKLabelNode(fontNamed: "Copperplate")
    var totalScoreDisplayP2 = SKLabelNode(fontNamed: "Copperplate")
    var totalScoreDisplay = SKLabelNode(fontNamed: "Copperplate")
    var totalScoreLabelP2 = SKLabelNode(fontNamed: "Copperplate")
    var totalScoreLabel = SKLabelNode(fontNamed: "Copperplate")
    var scoreDisplayP2 = SKLabelNode(fontNamed: "Copperplate")
    var HRLabel = SKLabelNode(fontNamed: "Copperplate")
    var HRLabelP2 = SKLabelNode(fontNamed: "Copperplate")
    var heartRate = SKLabelNode(fontNamed: "Copperplate")
    var heartRateP2 = SKLabelNode(fontNamed: "Copperplate")
    var coinNode = SKSpriteNode(imageNamed:String("Coin01"))
    var coinNodeP2 = SKSpriteNode(imageNamed:String("Coin02"))
    var coinsNode = SKSpriteNode(imageNamed:String("coins"))
    var coinsNodeP2 = SKSpriteNode(imageNamed:String("coins"))
    var playerLabel = SKLabelNode(fontNamed: "Copperplate")
    var playerLabelP2 = SKLabelNode(fontNamed: "Copperplate")
    var winMusicPlayer = AVPlayer()
    var stepScore = 0.0
    var stepScoreP2 = 0.0
    let scoreTick = SKAction.playSoundFileNamed("CounterNoise.mp3", waitForCompletion: true)
    var thePlayerSprite = SKSpriteNode()
    var thePlayerSpriteP2 = SKSpriteNode()
    var winRunning = true
    var flame = SKEmitterNode()
    var flame2 = SKEmitterNode()

    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        levelScore = score
        //sessionScore += score
        levelScoreP2 = scoreP2
        //sessionScoreP2 += scoreP2
        let gj = SKAction.playSoundFileNamed("gj.wav", waitForCompletion: true)
        runAction(gj)
        failScreenTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "checkTime", userInfo: nil, repeats: true)
        //backgroundMusicPlayer.pause()
        //createBackgroundNode()
        
        backgroundNode = SKSpriteNode(imageNamed: "winBackDropB")
        backgroundNode.position = CGPoint(x: self.size.width / 2.0, y: self.size.height / 2.0)
        self.addChild(backgroundNode)
        notification.addObserver(self, selector: "pauseGame:", name: "pause", object: nil)

        
        let dragonAtlas = SKTextureAtlas(named: "dragonAnim")
        var dragonFrames = [SKTexture]()
        
        let numImages = dragonAtlas.textureNames.count - 1
        for var i=0; i<=numImages; i++ {
            let dragonName = String(format: "dragonFlyAnim%02d" ,i + 1)
            //print(dragonName)
            dragonFrames.append(dragonAtlas.textureNamed(dragonName))
        }
        firstFrame = dragonFrames[0]
        
        let anim = SKAction.animateWithTextures(dragonFrames, timePerFrame: 0.05)
        anim.timingMode = SKActionTimingMode.EaseInEaseOut
        thePlayerSprite = SKSpriteNode(texture: firstFrame)
        thePlayerSprite.runAction(SKAction.repeatActionForever(anim))
        thePlayerSprite.setScale(1.7)
        thePlayerSprite.position = CGPoint(x: self.size.width / 2.0, y: self.size.height / 2.5)
        
        if numberOfPlayers == 1 {
            let path = NSBundle.mainBundle().pathForResource("Flame", ofType: "sks")
            flame = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
            flame.particlePosition = thePlayerSprite.position
            self.addChild(flame)
        } else if numberOfPlayers == 2 && player1Won == true {
            let path = NSBundle.mainBundle().pathForResource("Flame", ofType: "sks")
            flame = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
            //flame.particlePosition = CGPoint(x: self.size.width / 5, y: self.size.height / 2.4)
            flame.position = CGPoint(x: self.size.width / 5, y: self.size.height / 2.4)

            self.addChild(flame)
        }
        self.addChild(thePlayerSprite)

        
        //timerDisplay.setScale(scaleFactor)
        timerDisplay.fontColor = SKColor.whiteColor()
        timerDisplay.fontSize = 130
        timerDisplay.zPosition = 2
        timerDisplay.position = CGPoint(x: self.size.width / 1.2, y: self.size.height / 1.35)
        self.addChild(timerDisplay)
        
        coinNode.zPosition = 2
        coinNode.setScale(0.25)
        coinNode.position = CGPoint(x: self.size.width / 1.5, y: self.size.height / 1.35)
        self.addChild(coinNode)
        
        coinsNode.zPosition = 2
        coinsNode.setScale(1.0)
        coinsNode.position = CGPoint(x: self.size.width / 1.5, y: self.size.height / 1.45)
        self.addChild(coinsNode)
        
        //scoreDisplay.setScale(scaleFactor)
        scoreDisplay.fontColor = SKColor.whiteColor()
        scoreDisplay.fontSize = 70
        scoreDisplay.zPosition = 2
        scoreDisplay.text = String(Int(stepScore))
        scoreDisplay.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.35)
        self.addChild(scoreDisplay)
        computeNextDisplayScore()
        
        totalScoreDisplay.fontColor = SKColor.whiteColor()
        totalScoreDisplay.fontSize = 70
        totalScoreDisplay.zPosition = 2
        totalScoreDisplay.text = String(Int(sessionScore))
        totalScoreDisplay.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.45)
        self.addChild(totalScoreDisplay)
 
        //timerDisplayLabel.setScale(scaleFactor)
        timerDisplayLabel.text = "Next Level in"
        timerDisplayLabel.fontColor = SKColor.whiteColor()
        timerDisplayLabel.fontSize = 70
        timerDisplayLabel.position = CGPoint(x: self.size.width / 1.2, y: self.size.height / 1.2)
        self.addChild(timerDisplayLabel)
        
        HRLabel.fontSize = 70
        HRLabel.fontColor = SKColor.whiteColor()
        HRLabel.position = CGPoint(x: self.size.width / 7, y: self.size.height / 1.2)
        HRLabel.text = "Heart Rate"
        self.addChild(HRLabel)

        heartRate.fontSize = 130
        heartRate.fontColor = SKColor.whiteColor()
        heartRate.position = CGPoint(x: self.size.width / 7, y: self.size.height / 1.35)
        heartRate.text =  String(theMonitor.currentHeartRate)
        self.addChild(heartRate)
        
        if player2 != nil {
            playerLabel.fontSize = 70
            playerLabel.fontColor = SKColor.whiteColor()
            playerLabel.position = CGPoint(x: self.size.width / 5, y: self.size.height / 1.2)
            playerLabel.text = "Player 1"
            self.addChild(playerLabel)

            coinNode.position = CGPoint(x: self.size.width / 5, y: self.size.height / 1.45)
            coinsNode.position = CGPoint(x: self.size.width / 5, y: self.size.height / 1.65)
            scoreDisplay.position = CGPoint(x: self.size.width / 5, y: self.size.height / 1.50)
            scoreDisplay.fontSize = 70.0
            scoreDisplay.text = String(Int(score))
            totalScoreDisplay.position = CGPoint(x: self.size.width / 5, y: self.size.height / 1.7)
            totalScoreDisplay.fontSize = 70.0
            totalScoreLabel.position = CGPoint(x: self.size.width / 4.9, y: self.size.height / 1.45)


            HRLabel.position = CGPoint(x: self.size.width / 5, y: self.size.height / 5)
            heartRate.position = CGPoint(x: self.size.width / 5, y: self.size.height / 9)
 
            thePlayerSprite.position = CGPoint(x: self.size.width / 5, y: self.size.height / 2.4)

            flame.position = thePlayerSprite.position
 
      
            thePlayerSprite.setScale(1.2)
            
            timerDisplayLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.2)
            timerDisplay.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.35)
            
            playerLabelP2.fontSize = 70
            playerLabelP2.fontColor = SKColor.whiteColor()
            playerLabelP2.position = CGPoint(x: self.size.width / 1.25, y: self.size.height / 1.2)
            playerLabelP2.text = "Player 2"
            self.addChild(playerLabelP2)
            
            HRLabelP2.fontSize = 70
            HRLabelP2.fontColor = SKColor.whiteColor()
            HRLabelP2.position = CGPoint(x: self.size.width / 1.25, y: self.size.height / 5)
            HRLabelP2.text = "Heart Rate"
            self.addChild(HRLabelP2)
            
            heartRateP2.fontSize = 130
            heartRateP2.fontColor = SKColor.whiteColor()
            heartRateP2.position = CGPoint(x: self.size.width / 1.25, y: self.size.height / 9)
            heartRateP2.text =  String(theMonitor.currentHeartRate)
            self.addChild(heartRateP2)

            thePlayerSpriteP2 = SKSpriteNode(texture: firstFrame)
            thePlayerSpriteP2.runAction(SKAction.repeatActionForever(anim))
            thePlayerSpriteP2.setScale(1.2)
            thePlayerSpriteP2.position = CGPoint(x: self.size.width / 1.25, y: self.size.height / 2.4)
            if player1Won == false {
                let path = NSBundle.mainBundle().pathForResource("Flame", ofType: "sks")
                flame2 = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
                flame2.position = CGPoint(x: self.size.width / 1.25, y: self.size.height / 2.4)
                self.addChild(flame2)
            }
            self.addChild(thePlayerSpriteP2)
            
            coinNodeP2.zPosition = 2
            coinNodeP2.setScale(0.25)
            coinNodeP2.position = CGPoint(x: self.size.width / 1.25, y: self.size.height / 1.45)
            self.addChild(coinNodeP2)

            coinsNodeP2.zPosition = 2
            coinsNodeP2.setScale(1.0)
            coinsNodeP2.position = CGPoint(x: self.size.width / 1.25, y: self.size.height / 1.65)
            self.addChild(coinsNodeP2)
            
            scoreDisplayP2.fontColor = SKColor.whiteColor()
            scoreDisplayP2.fontSize = 70
            scoreDisplayP2.zPosition = 2
            scoreDisplayP2.text = String(Int(scoreP2))
            scoreDisplayP2.position = CGPoint(x: self.size.width / 1.25, y: self.size.height / 1.50)
            print(score)
            self.addChild(scoreDisplayP2)
            //computeNextDisplayScoreP2()
            
            totalScoreDisplayP2.fontColor = SKColor.whiteColor()
            totalScoreDisplayP2.fontSize = 70
            totalScoreDisplayP2.zPosition = 2
            totalScoreDisplayP2.text = String(Int(sessionScoreP2))
            totalScoreDisplayP2.position = CGPoint(x: self.size.width / 1.25, y: self.size.height / 1.7)
            self.addChild(totalScoreDisplayP2)
        }
    }
    
    func checkTime() {
        if winRunning == true {
            heartRate.text =  String(theMonitor.currentHeartRate)
            if player2 != nil {
                heartRateP2.text = String(theSecondMonitor.currentHeartRate)
            }
            if failCount > 0 {
                failCount -= 1
                print(failCount)
                timerDisplay.text = String(failCount)
            } else {
                print("present gamescene")
                let nextScene = GameScene(size: self.size)
                nextScene.scaleMode = SKSceneScaleMode.ResizeFill
                self.scene!.view?.presentScene(nextScene)
                winMusicPlayer.pause()
                failScreenTimer.invalidate()
            }
            if failCount == restTime - 7 {
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func createBackgroundNode(){
        let node = SKSpriteNode(imageNamed:String("LoseBackDrop"))
        node.setScale(self.size.width / 320)
        node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        node.position = CGPoint(x: self.size.width / 2, y: 0)
        self.addChild(node)
    }
    
    func computeNextDisplayScore() {
        if stepScore < score - 15 {
            let wait = SKAction.waitForDuration(0.03)
            let update = SKAction.runBlock({
                self.stepScore += 15
                self.scoreDisplay.text = String(Int(self.stepScore))
                self.runAction(self.scoreTick)
                self.computeNextDisplayScore()
            })
            let sequence = SKAction.sequence([wait, update])
            runAction(sequence)
        } else {
            scoreDisplay.text = String(Int(sessionScore))
            if musicShouldPlay == true {
                backgroundMusicPlayer.pause()
                winMusicPlayer.play()
            }
        }
    }
    func computeNextDisplayScoreP2() {
        if stepScoreP2 < scoreP2 - 15 {
            let wait = SKAction.waitForDuration(0.03)
            let update = SKAction.runBlock({
                self.stepScoreP2 += 15
                self.scoreDisplayP2.text = String(Int(self.stepScoreP2))
                self.runAction(self.scoreTick)
                self.computeNextDisplayScore()
            })
            let sequence = SKAction.sequence([wait, update])
            runAction(sequence)
        } else {
            scoreDisplayP2.text = String(Int(sessionScoreP2))
            if musicShouldPlay == true {
                backgroundMusicPlayer.pause()
                winMusicPlayer.play()
            }
        }
    }

    func pauseGame(notification: NSNotification) {
        if playing == true {
            scene?.paused = true
            playing = false
            backgroundMusicPlayer.pause()
            winRunning = false
        } else {
            winRunning = true
            backgroundMusicPlayer.play()
            scene?.paused = false
            playing = true
        }
        
    }

    
    
}
