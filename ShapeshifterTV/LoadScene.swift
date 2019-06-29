//
//  LoadScene.swift
//  ShapeshifterTV
//
//  Created by David Lang on 10/4/15.
//  Copyright © 2015 David Lang. All rights reserved.
//

import UIKit
import SpriteKit
import AVKit

class LoadScene: SKScene {
    var playerCountLabel = UILabel()
    var playLabel = UILabel()
    var musicList = ["Call to Adventure.mp3", "Feral Chase.mp3", "Dangerous.mp3", "Round Drums.mp3", "Mechanolith.mp3", "Clenched Teeth.mp3",  "Machinations.mp3", "The Descent.mp3", "Mechanolith.mp3"]
    var diffLabel:UILabel!
    var button1 = UIButton()
    var difficultyButton = UIButton()
    var startConnectButton = UIButton()
    var musicButton = UIButton()
    var increaseRestButton = UIButton()
    var decreaseRestButton = UIButton()
    var restLabel = UILabel()
    var musicLabel = UILabel()
    var creditsButton = UIButton()
   //for testing
    var exitButton = UIButton()
    var msg = ""

    
    override func didMoveToView(view: SKView) {

        notification.addObserver(self, selector: "loadGame:", name: "loadGame", object:nil)
        notification.addObserver(self, selector: "updateScreen:", name: "updateScreen", object:nil)

        playBackgroundMusic()

        let backImage = UIImageView(frame: CGRectMake(0, 0, (self.view?.bounds.size.width)!, (self.view?.bounds.size.height)!))
        backImage.image = UIImage(named: "dragonBack")
        self.view?.addSubview(backImage)
        
        let title = UILabel(frame: CGRectMake(view.bounds.size.width/2 - 600, 0, 1200,250))
        title.text = "Shapeshifter"
        title.textColor = UIColor.whiteColor()
        title.textAlignment = NSTextAlignment.Center
        title.font = UIFont(name: "Avenir", size: 150.0)
        self.view?.addSubview(title)
        
        
/*      let button1=UIButton(frame: CGRectMake(view.bounds.size.width/2 - 600, 375, 400, 180))
        button1.imageForState(UIControlState.Focused)
        button1.setTitle("One", forState: UIControlState.Focused)
        button1.setTitle("One", forState: UIControlState.Normal)
        button1.setTitleColor(UIColor.blueColor(), forState: UIControlState.Focused)
        button1.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button1.titleLabel?.font = UIFont(name: "Avenir", size: 100.0)
        button1.addTarget(self, action: "onePlayer", forControlEvents: UIControlEvents.PrimaryActionTriggered)
        self.view!.addSubview(button1)

        let button2=UIButton(frame: CGRectMake(view.bounds.size.width/2 + 150, 375, 400, 180))
        button2.imageForState(UIControlState.Focused)
        button2.setTitle("Two", forState: UIControlState.Focused)
        button2.setTitle("Two", forState: UIControlState.Normal)
        button2.setTitleColor(UIColor.blueColor(), forState: UIControlState.Focused)
        button2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button2.titleLabel?.font = UIFont(name: "Avenir", size: 100.0)
        button2.addTarget(self, action: "twoPlayer", forControlEvents: UIControlEvents.PrimaryActionTriggered)
        self.view!.addSubview(button2)
*/
        playerCountLabel = UILabel(frame: CGRectMake(50,200,650,300))
        playerCountLabel.text = "Players: "
        playerCountLabel.font = UIFont(name: "Avenir", size: 75.0)
        playerCountLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(playerCountLabel)

        button1=UIButton(frame: CGRectMake(view.bounds.size.width/2 - 200, 200, 400, 300))
        button1.imageForState(UIControlState.Focused)
        if numberOfPlayers == 1 {
            button1.setTitle("One", forState: UIControlState.Focused)
            button1.setTitle("One", forState: UIControlState.Normal)
        } else {
            button1.setTitle("Two", forState: UIControlState.Focused)
            button1.setTitle("Two", forState: UIControlState.Normal)
        }
        
        button1.setTitleColor(UIColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 1.0), forState: UIControlState.Focused)
        button1.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button1.titleLabel?.font = UIFont(name: "Avenir", size: 100.0)
        button1.addTarget(self, action: "onePlayer", forControlEvents: UIControlEvents.PrimaryActionTriggered)
        self.view!.addSubview(button1)
        
/*
        let button4=UIButton(frame: CGRectMake(view.bounds.size.width/2 - 200, 650, 400, 180))
        button4.imageForState(UIControlState.Focused)
        button4.setTitle("Medium", forState: UIControlState.Focused)
        button4.setTitle("Medium", forState: UIControlState.Normal)
        button4.setTitleColor(UIColor.blueColor(), forState: UIControlState.Focused)
        button4.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button4.titleLabel?.font = UIFont(name: "Avenir", size: 100.0)
        button4.addTarget(self, action: "medDiff", forControlEvents: UIControlEvents.PrimaryActionTriggered)
        self.view!.addSubview(button4)
        
        let button5=UIButton(frame: CGRectMake(1300, 650, 400, 180))
        button5.imageForState(UIControlState.Focused)
        button5.setTitle("Hard", forState: UIControlState.Focused)
        button5.setTitle("Hard", forState: UIControlState.Normal)
        button5.setTitleColor(UIColor.blueColor(), forState: UIControlState.Focused)
        button5.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button5.titleLabel?.font = UIFont(name: "Avenir", size: 100.0)
        button5.addTarget(self, action: "hardDiff", forControlEvents: UIControlEvents.PrimaryActionTriggered)
        self.view!.addSubview(button5)
*/
        
        diffLabel = UILabel()
        diffLabel.frame = CGRectMake(50,450,340,300)
        diffLabel.text = "Difficulty: "
        diffLabel.font = UIFont(name: "Avenir", size: 75.0)
        diffLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(diffLabel)
 
        difficultyButton=UIButton(frame: CGRectMake(view.bounds.size.width/2 - 200, 450, 400, 300))
        difficultyButton.imageForState(UIControlState.Focused)
        difficultyButton.setTitle("Easy", forState: UIControlState.Focused)
        difficultyButton.setTitle("Easy", forState: UIControlState.Normal)
        difficultyButton.setTitleColor(UIColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 1.0), forState: UIControlState.Focused)
        difficultyButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        difficultyButton.titleLabel?.font = UIFont(name: "Avenir", size: 100.0)
        difficultyButton.addTarget(self, action: "easyDiff", forControlEvents: UIControlEvents.PrimaryActionTriggered)
        self.view!.addSubview(difficultyButton)
        
        startConnectButton=UIButton(frame: CGRectMake(view.bounds.size.width/2 - 750, 725, 1500, 300))
        startConnectButton.imageForState(UIControlState.Focused)
        startConnectButton.setTitle("Connect Heart Rate Monitor", forState: UIControlState.Focused)
        startConnectButton.setTitle("Connect Heart Rate Monitor", forState: UIControlState.Normal)
        startConnectButton.setTitleColor(UIColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 1.0), forState: UIControlState.Focused)
        startConnectButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        startConnectButton.titleLabel?.font = UIFont(name: "Avenir", size: 100.0)
        startConnectButton.addTarget(self, action: "startConnect", forControlEvents: UIControlEvents.PrimaryActionTriggered)
        self.view!.addSubview(startConnectButton)
        
        playLabel = UILabel()
        playLabel.frame = CGRectMake(view.bounds.size.width/2 - 300, view.bounds.size.height - 50,600,100)
        playLabel.text = ""
        playLabel.font = UIFont(name: "Avenir", size: 50.0)
        playLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.7)
        playLabel.textAlignment = NSTextAlignment.Center
        self.view?.addSubview(playLabel)
        
        exitButton = UIButton(frame: CGRectMake(view.bounds.size.width - 400, 980, 400, 100))
        exitButton.imageForState(UIControlState.Focused)
        exitButton.setTitle("reset", forState: UIControlState.Focused)
        exitButton.setTitle("reset", forState: UIControlState.Normal)
        exitButton.setTitleColor(UIColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 1.0), forState: UIControlState.Focused)
        exitButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        exitButton.titleLabel?.font = UIFont(name: "Avenir", size: 70.0)
        exitButton.addTarget(self, action: "reset", forControlEvents: UIControlEvents.PrimaryActionTriggered)
        exitButton.alpha = 0.1
        self.view!.addSubview(exitButton)

        if theGameContext == gameContext.menu.rawValue {
            //difficulty
            
            button1.frame = CGRect(x: view.bounds.size.width/2 - 750, y: 200, width: 1500, height: 100)
            button1.titleLabel?.font = UIFont(name: "Avenir", size: 70.0)
            playerCountLabel.frame = CGRect(x: 50, y:200, width: 700, height: 100)
            playerCountLabel.font = UIFont(name: "Avenir", size: 70.0)

            difficultyButton.frame = CGRect(x: view.bounds.size.width/2 - 750, y: 310, width: 1500, height: 100)
            difficultyButton.titleLabel?.font = UIFont(name: "Avenir", size: 70.0)
            diffLabel.frame = CGRectMake(50,310,340,100)
            diffLabel.font = UIFont(name: "Avenir", size: 70.0)
  
            //music on/off
            
            musicLabel = UILabel(frame: CGRectMake(50,420,650,100))
            musicLabel.text = "Music: "
            musicLabel.font = UIFont(name: "Avenir", size: 70.0)
            musicLabel.textColor = UIColor.whiteColor()
            self.view?.addSubview(musicLabel)
            
            musicButton=UIButton(frame: CGRectMake(view.bounds.size.width/2 - 250, 420, 500, 100))
            musicButton.imageForState(UIControlState.Focused)
            musicButton.setTitle("On", forState: UIControlState.Focused)
            musicButton.setTitle("On", forState: UIControlState.Normal)
            musicButton.setTitleColor(UIColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 1.0), forState: UIControlState.Focused)
            musicButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            musicButton.titleLabel?.font = UIFont(name: "Avenir", size: 70.0)
            musicButton.addTarget(self, action: "music", forControlEvents: UIControlEvents.PrimaryActionTriggered)
            self.view!.addSubview(musicButton)

            //rest length
            
            increaseRestButton = UIButton(frame: CGRectMake(view.bounds.size.width/2 - 200, 530, 200, 100))
            increaseRestButton.imageForState(UIControlState.Focused)
            increaseRestButton.setTitle("+", forState: UIControlState.Focused)
            increaseRestButton.setTitle("+", forState: UIControlState.Normal)
            increaseRestButton.setTitleColor(UIColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 1.0), forState: UIControlState.Focused)
            increaseRestButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            increaseRestButton.titleLabel?.font = UIFont(name: "Avenir", size: 70.0)
            increaseRestButton.addTarget(self, action: "addRestTime", forControlEvents: UIControlEvents.PrimaryActionTriggered)
            self.view!.addSubview(increaseRestButton)
            
            decreaseRestButton = UIButton(frame: CGRectMake(view.bounds.size.width/2 + 30, 530, 200, 100))
            decreaseRestButton.imageForState(UIControlState.Focused)
            decreaseRestButton.setTitle("-", forState: UIControlState.Focused)
            decreaseRestButton.setTitle("-", forState: UIControlState.Normal)
            decreaseRestButton.setTitleColor(UIColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 1.0), forState: UIControlState.Focused)
            decreaseRestButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            decreaseRestButton.titleLabel?.font = UIFont(name: "Avenir", size: 70.0)
            decreaseRestButton.addTarget(self, action: "decreaseRestTime", forControlEvents: UIControlEvents.PrimaryActionTriggered)
            self.view!.addSubview(decreaseRestButton)
            
            restLabel = UILabel()
            restLabel.frame = CGRectMake(50,530,500,100)
            restLabel.text = "Rest Time: \(restTime)"
            restLabel.font = UIFont(name: "Avenir", size: 70.0)
            restLabel.textColor = UIColor.whiteColor()
            self.view?.addSubview(restLabel)
            
            //Credits
            creditsButton = UIButton(frame: CGRectMake(view.bounds.size.width/2 - 200, 640, 400, 100))
            creditsButton.imageForState(UIControlState.Focused)
            creditsButton.setTitle("Credits", forState: UIControlState.Focused)
            creditsButton.setTitle("Credits", forState: UIControlState.Normal)
            creditsButton.setTitleColor(UIColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 1.0), forState: UIControlState.Focused)
            creditsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            creditsButton.titleLabel?.font = UIFont(name: "Avenir", size: 70.0)
            creditsButton.addTarget(self, action: "easyDiff", forControlEvents: UIControlEvents.PrimaryActionTriggered)
            self.view!.addSubview(creditsButton)
            
            //Play
            startConnectButton.setTitle("Play", forState: UIControlState.Focused)
            startConnectButton.setTitle("Play", forState: UIControlState.Normal)
            startConnectButton.frame = CGRectMake(view.bounds.size.width/2 - 750, 750, 1500, 300)
            self.view?.addSubview(startConnectButton)
            
            /*exitButton = UIButton(frame: CGRectMake(view.bounds.size.width/2 - 200, 980, 400, 100))
            exitButton.imageForState(UIControlState.Focused)
            exitButton.setTitle("reset", forState: UIControlState.Focused)
            exitButton.setTitle("reset", forState: UIControlState.Normal)
            exitButton.setTitleColor(UIColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 1.0), forState: UIControlState.Focused)
            exitButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            exitButton.titleLabel?.font = UIFont(name: "Avenir", size: 70.0)
            exitButton.addTarget(self, action: "reset", forControlEvents: UIControlEvents.PrimaryActionTriggered)
            self.view!.addSubview(exitButton) */
        }
    }
    
    
    func onePlayer() {
        print("1 player")
        
        if numberOfPlayers == 1 {
            numberOfPlayers = 2
            button1.setTitle("Two", forState: UIControlState.Normal)
            button1.setTitle("Two", forState: UIControlState.Focused)
        } else if numberOfPlayers == 2 {
            numberOfPlayers = 1
            button1.setTitle("One", forState: UIControlState.Normal)
            button1.setTitle("One", forState: UIControlState.Focused)
        }
            //playerCountLabel.text = "Number of Players: One"
    }
    func twoPlayer(){
        print("2 player")
        numberOfPlayers = 2
        playerCountLabel.text = "Number of Players: Two"
    }
    func reset() {
        exit(5)
    }
    func music() {
        if musicShouldPlay == true {
            musicButton.setTitle("Off", forState: UIControlState.Normal)
            musicButton.setTitle("Off", forState: UIControlState.Focused)
            musicShouldPlay = false
            backgroundMusicPlayer.pause()
        } else {
            musicButton.setTitle("On", forState: UIControlState.Normal)
            musicButton.setTitle("On", forState: UIControlState.Focused)
            musicShouldPlay = true
            backgroundMusicPlayer.play()
        }
    }
    func addRestTime() {
        restTime += 1
        restLabel.text = "Rest Time: " + String(restTime)
    }
    func decreaseRestTime() {
        restTime -= 1
        restLabel.text = "Rest Time: " + String(restTime)
    }

    func easyDiff () {
        if difficultyLevel == "Hard" {
            difficultyButton.setTitle("Easy", forState: UIControlState.Normal)
            difficultyButton.setTitle("Easy", forState: UIControlState.Focused)
            coinBoost = 400.0
            cloudBoost = 550.0
            scoreMultiplier = 1.0
            heartRateBoost = 1000.0
            difficultyLevel = "Easy"
        } else if difficultyLevel == "Easy" {
            difficultyLevel = "Medium"
            difficultyButton.setTitle("Medium", forState: UIControlState.Normal)
            difficultyButton.setTitle("Medium", forState: UIControlState.Focused)
            coinBoost = 350.0
            cloudBoost = 500.0
            scoreMultiplier = 1.3
            heartRateBoost = 550.0
        } else if difficultyLevel == "Medium" {
            difficultyButton.setTitle("Hard", forState: UIControlState.Normal)
            difficultyButton.setTitle("Hard", forState: UIControlState.Focused)
            difficultyLevel = "Hard"
            coinBoost = 250.0
            cloudBoost = 270.0
            scoreMultiplier = 1.5
            heartRateBoost = 325.0
        }
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for item in presses {
            switch item.type {
            case .Select:
                self.view!.backgroundColor = UIColor.greenColor()
                print("select pressed")
            
            case .Menu:
                switch theGameContext {
                /* if playing == true {
                    notification.postNotification(NSNotification(name: "pause", object: nil))
                }
                //self.performSegueWithIdentifier("menuSegue", sender: nil)
                self.view!.window!.rootViewController?.performSegueWithIdentifier("menuSegue", sender: self) */
                case gameContext.load.rawValue:
                    print("load screen game ctxt menu play menu button")
                case gameContext.game.rawValue:
                    print("load screen game ctxt menu play menu button")
                case gameContext.menu.rawValue:
                    print("load screen - game ctxt menu - menu button")
                default: break
                }
            case .PlayPause:
                switch theGameContext {
                case gameContext.load.rawValue:
                    //notification.postNotification(NSNotification(name: "pause", object: nil))
                    print("load screen game ctxt load play pause button")
              /*      let secondScene = GameScene(size: self.size)
                    let transition = SKTransition.flipVerticalWithDuration(1.0)
                    secondScene.scaleMode = SKSceneScaleMode.ResizeFill
                    self.scene!.view?.presentScene(secondScene, transition: transition)
                    playLabel.text = "Scanning"
                    for view in self.view!.subviews {
                        view.removeFromSuperview()
                    } */
                case gameContext.game.rawValue:
                    print("load screen game ctxt game play pause button")
                 /*   let secondScene = GameScene(size: self.size)
                    let transition = SKTransition.flipVerticalWithDuration(1.0)
                    secondScene.scaleMode = SKSceneScaleMode.ResizeFill
                    self.scene!.view?.presentScene(secondScene, transition: transition)
                    playLabel.text = "Scanning"
                    for view in self.view!.subviews {
                        view.removeFromSuperview()
                    }
*/
                case gameContext.menu.rawValue:
                    print("load screen game ctxt menu play pause button")
                default: break
                }
            default: break
            }
        }
    }

    
    func startConnect() {
        if playing == false && theGameContext != gameContext.game.rawValue  {
            if connectedDevices.count == 0 && numberOfPlayers == 1 {
                notification.postNotification(NSNotification(name: "findMonitors", object: nil))
            } else if connectedDevices.count < 1 && numberOfPlayers == 2 {
                notification.postNotification(NSNotification(name: "findMonitors", object: nil))
            }
        }
        if msg == "Press Play to Start" {
            if theGameScene == nil {
                theGameScene = GameScene(size: self.size)
            }
            let transition = SKTransition.crossFadeWithDuration(1.0)
            self.scene!.view?.presentScene(theGameScene, transition: transition)
            theGameContext = gameContext.game.rawValue
            for view in (self.scene!.view?.subviews)! {
                view.removeFromSuperview()
            }
            if playing == false {
                notification.postNotification(NSNotification(name: "pause", object: nil))
            }
        }
        //theGameContext = gameContext.game.rawValue
        //notification.postNotification(NSNotification(name: "pause", object: nil))
    }
    
    func loadGame(notification: NSNotification) {
        let secondScene = GameScene(size: self.size)
        let transition = SKTransition.flipVerticalWithDuration(1.0)
        secondScene.scaleMode = SKSceneScaleMode.ResizeFill
        self.scene!.view?.presentScene(secondScene, transition: transition)
        if self.view?.subviews != nil {
            for view in (self.view?.subviews)! {
                view.removeFromSuperview()
            }
        }
    }
    
    func updateScreen(notification: NSNotification) {
        msg = (notification.userInfo?["theStatus"])! as! String
        playLabel.text = msg
        playLabel.frame = CGRectMake((view?.bounds.size.width)!/2 - 200, (view?.bounds.size.height)! - 100 ,400,100)

        if msg == "Press Play to Start" {
            startConnectButton.setTitle("Start", forState: UIControlState.Normal)
            startConnectButton.setTitle("Start", forState: UIControlState.Focused)
            playLabel.text = "Ready"
            playLabel.textAlignment = NSTextAlignment.Center
        }
       
        
        if musicButton.state == UIControlState.Focused {
            musicLabel.textColor = UIColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 1.0)
        } else {
            musicLabel.textColor = UIColor.whiteColor()
        }

    }
    
    func playBackgroundMusic() {
        for i in 0...musicList.count - 1 {
            let song = NSBundle.mainBundle().URLForResource(
                musicList[i], withExtension: nil)
            songItem = AVPlayerItem(URL: song!)
            musicItemList.append(songItem)
            
        }
        let error: NSError? = nil
        
        if backgroundMusicPlayer == nil {
            backgroundMusicPlayer = AVQueuePlayer(items: musicItemList as [AVPlayerItem])
            backgroundMusicPlayer.play()
        } else {
            print("did not create music player")
        }
        if backgroundMusicPlayer == nil {
            print("Could not create audio player: \(error!)")
            return
        }
        backgroundMusicPlayer.volume = 0.6
        let avSession = AVAudioSession()
        let eP = NSErrorPointer()
        do {
            try avSession.setCategory(AVAudioSessionCategoryAmbient)
        } catch let error as NSError {
            eP.memory = error
        }
    }
    
    func playerItemFinished(notification: NSNotification) {
        backgroundMusicPlayer.advanceToNextItem()
    }

    override init(size: CGSize) {
        super.init(size: size)
        //self.view?.window?.rootViewController?.performSegueWithIdentifier("menuSegue", sender: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
