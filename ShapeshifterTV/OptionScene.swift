//
//  OptionScene.swift
//  ShapeshifterTV
//
//  Created by David Lang on 9/14/15.
//  Copyright © 2015 David Lang. All rights reserved.
//
import SpriteKit
import AVFoundation


class OptionScene: SKScene {
    
    var finishButton = SKLabelNode(fontNamed: "Copperplate-Bold")
    //var playButton = SKTexture(imageNamed: "playButton")
//    var playNode = SKSpriteNode()
    //var playNode = UIImage(contentsOfFile: "playButton")

    let backgroundNode = SKNode()
    var backSep = SKLabelNode(fontNamed: "Copperplate-Light")
    var difficultyNode = SKLabelNode(fontNamed: "Copperplate-Light")
    var musicNode = SKLabelNode(fontNamed: "Copperplate-Light")
    var easyButton = SKLabelNode(fontNamed: "Copperplate-Bold")
    var mediumButton = SKLabelNode(fontNamed: "Copperplate-Bold")
    var hardButton = SKLabelNode(fontNamed: "Copperplate-Bold")
    var musicButton = SKLabelNode(fontNamed: "Copperplate-Bold")
    var diffSep = SKLabelNode(fontNamed: "Copperplate-Light")
    var restTimeLabel = SKLabelNode(fontNamed: "Copperplate-Light")
    var moreRest = SKLabelNode(fontNamed: "Copperplate-Bold")
    var lessRest = SKLabelNode(fontNamed: "Copperplate-Bold")
    var restSep = SKLabelNode(fontNamed: "Copperplate-Light")
    var monitorNode = SKNode()
    var heartRateLabel = SKLabelNode(fontNamed: "Copperplate-Light")
    var hrSep = SKLabelNode(fontNamed: "Copperplate-Light")
    
    var selectedFontSize:CGFloat = 32.0
    var regularFontSize:CGFloat = 28.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        buildScene()
        
    }
    override init() {
        super.init()
        buildScene()
    }

    
    override func didMoveToView(view: SKView) {
        var playButton = UIButton(frame: CGRect(x: 0, y: 0, width: 420, height: 200))
        playButton.setTitle("Play", forState: UIControlState.Normal)
        //playButton.setImage(UIImage(contentsOfFile: "Coin01"), forState: UIControlState.Normal)
        //playButton.imageForState(UIControlState.Normal)
        var playNode = SKNode()
        //playNode.a
        playButton.layer.zPosition = 2 //playNode.position = CGPoint(x: 100.0, y: 50.0)
        view.addSubview(playButton)
    }
    
    func buildScene() {
        /* Setup your scene here */
        print("did move to view")
        backgroundColor = UIColor.purpleColor()
        
        //let ySpacing = 150.0 * scaleFactor
        
        //var playNode = UIImage(contentsOfFile: "playButton")
        //playNode.setScale(scaleFactor)
        //var playNode = UIImage(
        
        difficultyNode.text = "Difficulty Level"
        difficultyNode.position = CGPoint(x: CGFloat(self.size.width/2), y: CGFloat(self.size.height/1.1))
        self.addChild(difficultyNode)
        
        easyButton.name = "Easy"
        easyButton.text = "Easy"
        easyButton.zPosition = 2
        easyButton.fontColor = SKColor.whiteColor()
        easyButton.position = CGPoint(x: CGFloat(self.size.width/2 - 90), y: CGFloat(self.size.height/1.1 - 35.0))
        self.addChild(easyButton)
        
        mediumButton.name = "Medium"
        mediumButton.text = "Med"
        mediumButton.fontColor = SKColor.grayColor()
        mediumButton.zPosition = 2
        mediumButton.position = CGPoint(x: CGFloat(self.size.width/2), y: CGFloat(self.size.height/1.1 - 35.0))
        self.addChild(mediumButton)
        
        hardButton.name = "Hard"
        hardButton.text = "Hard"
        hardButton.fontColor = SKColor.grayColor()
        hardButton.zPosition = 2
        hardButton.position = CGPoint(x: CGFloat(self.size.width/2 + 90.0), y: CGFloat(self.size.height/1.1 - 35.0))
        self.addChild(hardButton)
        
        diffSep.text = "____________________"
        diffSep.position = CGPoint(x: CGFloat(self.size.width/2), y: CGFloat(self.size.height/1.1 - 50.0))
        self.addChild(diffSep)
        
        musicNode.text = "Background Music"
        musicNode.position = CGPoint(x: CGFloat(self.size.width/2), y: CGFloat(self.size.height/1.35))
        self.addChild(musicNode)
        
        musicButton.name = "Music"
        musicButton.text = "On"
        musicButton.fontColor = SKColor.whiteColor()
        musicButton.zPosition = 2
        musicButton.position = CGPoint(x: CGFloat(self.size.width/2), y: CGFloat(self.size.height/1.35 - 35.0))
        self.addChild(musicButton)
        
        backSep.text = "____________________"
        backSep.position = CGPoint(x: CGFloat(self.size.width/2), y: CGFloat(self.size.height/1.35 - 50.0))
        self.addChild(backSep)
        
        restTimeLabel.text = "Rest time: " + String(restTime)
        restTimeLabel.zPosition = 2
        restTimeLabel.fontColor = SKColor.whiteColor()
        restTimeLabel.position = CGPoint(x:self.size.width/2.0, y: CGFloat(self.size.height/1.75))
        self.addChild(restTimeLabel)
        
        moreRest.name = "more"
        moreRest.text = "+"
        moreRest.zPosition = 2
        moreRest.fontColor = SKColor.whiteColor()
        moreRest.position = CGPoint(x: CGFloat(self.size.width/2 - 90), y: CGFloat(self.size.height/1.75 - 35.0))
        self.addChild(moreRest)
        
        restSep.text = "____________________"
        restSep.position = CGPoint(x: CGFloat(self.size.width/2), y: CGFloat(self.size.height/1.75 - 50.0))
        self.addChild(restSep)
        
        lessRest.name = "less"
        lessRest.text = "-"
        lessRest.zPosition = 2
        lessRest.fontColor = SKColor.whiteColor()
        lessRest.position = CGPoint(x: CGFloat(self.size.width/2 + 90), y: CGFloat(self.size.height/1.75 - 35.0))
        self.addChild(lessRest)
        
        heartRateLabel.text = "Heart rate: " + String(theMonitor.currentHeartRate) + " bpm"
        heartRateLabel.fontColor = SKColor.whiteColor()
        heartRateLabel.position = CGPoint(x: CGFloat(self.size.width/2), y: CGFloat(self.size.height/2.5))
        self.addChild(heartRateLabel)
        

        
        hrSep.text = "____________________"
        hrSep.position = CGPoint(x: CGFloat(self.size.width/2), y: CGFloat(self.size.height/2.5 - 70.0))
        self.addChild(hrSep)
        
        finishButton.text = "Finish Workout"
        finishButton.name = "finish"
        finishButton.fontColor = SKColor.whiteColor()
        finishButton.position = CGPoint(x: self.size.width/2.0, y: self.size.height/5.5)
        self.addChild(finishButton)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touch")
        let touch: UITouch = touches.first!
        print(touch)
        let location = touch.locationInNode(self)
        print(location)
        let node = self.nodeAtPoint(location)
        print(node)
        
        // If next button is touched, start transition to second scene
        if (node.name == "PlayButton") {
            print("play pressed")
            let secondScene = GameScene(size: self.size)
            let transition = SKTransition.flipVerticalWithDuration(1.0)
            secondScene.scaleMode = SKSceneScaleMode.ResizeFill
            self.removeChildrenInArray([backgroundNode,node])
            self.scene!.view?.presentScene(secondScene, transition: transition)
        } else if (node.name == "Easy") {
            coinBoost = 30.0
            cloudBoost = 550.0
            scoreMultiplier = 1.0
            heartRateBoost = 200.0
            easyButton.fontColor = SKColor.whiteColor()
            mediumButton.fontColor = SKColor.grayColor()
            hardButton.fontColor = SKColor.grayColor()
            let buttonPress = SKAction.playSoundFileNamed("ButtonPress1.aiff", waitForCompletion: true)
            runAction(buttonPress)
            
        } else if (node.name == "Medium") {
            
            coinBoost = 15.0
            cloudBoost = 500.0
            scoreMultiplier = 1.3
            heartRateBoost = 50.0
            easyButton.fontColor = SKColor.grayColor()
            mediumButton.fontColor = SKColor.whiteColor()
            hardButton.fontColor = SKColor.grayColor()
            let buttonPress = SKAction.playSoundFileNamed("ButtonPress1.aiff", waitForCompletion: true)
            runAction(buttonPress)
            
        } else if (node.name == "Hard") {
            coinBoost = 5.0
            cloudBoost = 270.0
            scoreMultiplier = 1.5
            heartRateBoost = 40.0
            easyButton.fontColor = SKColor.grayColor()
            mediumButton.fontColor = SKColor.grayColor()
            hardButton.fontColor = SKColor.whiteColor()
            let buttonPress = SKAction.playSoundFileNamed("ButtonPress1.aiff", waitForCompletion: true)
            runAction(buttonPress)
        } else if node.name == "finish" {
            let finishScene = FinishScene(size: self.size)
            finishScene.scaleMode = SKSceneScaleMode.ResizeFill
            //self.removeChildrenInArray([])
            self.scene!.view?.presentScene(finishScene)
        } else if (node.name == "Music") {
            
            if musicShouldPlay == false {
                musicShouldPlay = true
                musicButton.text = "On"
                let buttonPress = SKAction.playSoundFileNamed("ButtonPress1.aiff", waitForCompletion: true)
                
            } else {
                musicShouldPlay = false
                musicButton.text = "Off"
                
            }
        } else if node.name == "less" {
            restTime -= 1
            restTimeLabel.text = "Rest time: " + String(restTime)
        } else if node.name == "more" {
            restTime += 1
            restTimeLabel.text = "Rest time: " + String(restTime)
        } else if (node.name == "monitor") {
            theMonitor.centralManager = nil
            theMonitor.startUpCentralManager()
            theMonitor.discoverDevices()
            displayMenuItems = true
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        heartRateLabel.text = "Heart rate: " + String(theMonitor.currentHeartRate) + " bpm"
        
    }
    
}
