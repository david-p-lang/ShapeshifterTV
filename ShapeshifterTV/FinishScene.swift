//
//  FinishScene.swift
//  ShapeshifterTV
//
//  Created by David Lang on 9/14/15.
//  Copyright © 2015 David Lang. All rights reserved.
//

//
//  FinishScene.swift
//  Shapeshifter
//
//  Created by David Lang on 8/13/15.
//  Copyright (c) 2015 David Lang. All rights reserved.
//

import UIKit
import SpriteKit
//import Social

class FinishScene: SKScene {
    var thisSceneFontSize:CGFloat = 36.0
    var fbButton = SKTexture(imageNamed: "FBLogo")
    var fbNode = SKSpriteNode()
    var tButton = SKTexture(imageNamed: "twitterLogo")
    var tNode = SKSpriteNode()
    var allTimeScoreLabel = SKLabelNode(fontNamed: "Copperplate-Light")
    var sessionScoreLabel = SKLabelNode(fontNamed: "Copperplate-Light")
    var allTimeLabel = SKLabelNode(fontNamed: "Copperplate-Light")
    var sessionLabel = SKLabelNode(fontNamed: "Copperplate-Light")
    var restartButton = SKLabelNode(fontNamed: "Copperplate-Light")
    var scaleFactor:CGFloat!
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.purpleColor()
        scaleFactor = (self.size.width / 320.0)
        
        /*        allTimeLabel.text = "All Time Score"
        allTimeLabel.fontColor = SKColor.whiteColor()
        allTimeLabel.fontSize = thisSceneFontSize
        allTimeLabel.position = CGPoint(x: self.size.width/2, y: self.size.height-40.0)
        self.addChild(allTimeLabel)
        
        allTimeScoreLabel.text = String(Int(allTimeScore)) + " gold coins"
        allTimeScoreLabel.fontColor = SKColor.whiteColor()
        allTimeScoreLabel.fontSize = thisSceneFontSize
        allTimeScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height-80.0)
        self.addChild(allTimeScoreLabel) */
        
        sessionScoreLabel.text = "Current Score"
        sessionScoreLabel.fontColor = SKColor.whiteColor()
        sessionScoreLabel.fontSize = thisSceneFontSize
        sessionScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height-50.0)
        self.addChild(sessionScoreLabel)
        
        sessionLabel.text = String(Int(allTimeScore)) + " gold coins"
        sessionLabel.fontColor = SKColor.whiteColor()
        sessionLabel.fontSize = thisSceneFontSize
        sessionLabel.position = CGPoint(x: self.size.width/2, y: self.size.height-100.0)
        self.addChild(sessionLabel)
        
        restartButton.text = "Restart Game"
        restartButton.name = "restart"
        restartButton.fontColor = SKColor.whiteColor()
        restartButton.fontSize = thisSceneFontSize + 10.0
        restartButton.position = CGPoint(x: self.size.width/2, y: self.size.height / 2.0)
        self.addChild(restartButton)
        
        fbButton.filteringMode = SKTextureFilteringMode.Linear
        fbNode = SKSpriteNode(texture: fbButton, size: CGSize(width: 100.0, height: 100.0))
        
        fbNode.setScale(0.8 * scaleFactor)
        fbNode.name = "facebook"
        fbNode.zPosition = 2
        fbNode.position = CGPoint(x: (self.size.width / 2.0), y: 80)
        self.addChild(fbNode)
        
        /*       tButton.filteringMode = SKTextureFilteringMode.Linear
        tNode = SKSpriteNode(texture: tButton, size: CGSize(width: 100.0, height: 100.0))
        
        tNode.setScale(0.8 * scaleFactor)
        tNode.name = "facebook"
        tNode.zPosition = 2
        tNode.position = CGPoint(x: (self.size.width / 2.0  + tNode.size.width), y: 80)
        self.addChild(tNode) */
        
        //save allTimescore
        defaults.setFloat(Float(allTimeScore + sessionScore), forKey: "allTimeScore")
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location = touch.locationInNode(self)
        let node = self.nodeAtPoint(location)
        if node.name == "facebook" {
            NSNotificationCenter.defaultCenter().postNotificationName("facebookPost", object: nil)
        } else if node.name == "restart" {
            currentLevel = 1
            levelScore = 0.0
            sessionScore = 0.0
            score = 0.0
            currentScore = 1.0
            levelsConquered = 0
            let secondScene = GameScene(size: self.size)
            secondScene.scaleMode = SKSceneScaleMode.ResizeFill
            self.scene!.view?.presentScene(secondScene)
            
        }
    }
}
