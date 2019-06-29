//
//  MenuViewController.swift
//  ShapeshifterTV
//
//  Created by David Lang on 10/1/15.
//  Copyright © 2015 David Lang. All rights reserved.
//

import UIKit
import SpriteKit

class MenuViewController: UIViewController {

    //@IBOutlet weak var playerNumLabel: UILabel!
    @IBOutlet weak var diffLabel: UILabel!
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var hrcLabel: UILabel!
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var addRestTimeButton: UIButton!
    @IBOutlet weak var decreaseRestTimeButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theMenuViewController = self
        restTimeLabel.text = "Rest Time: " + String(restTime)
        //notification.addObserver(self, selector: "menuPressed:", name: "menu", object: nil)
        //self.view.window?.rootViewController = self
        print(self.view.window?.rootViewController)
        if musicShouldPlay == true {
            musicLabel.text = "Music: On"
        } else {
            musicLabel.text = "Music: Off"
        }
        hrcLabel.text = "Heart Rate Monitor:" + String(theMonitor.currentHeartRate)
        diffLabel.text = "Difficulty: " + difficultyLevel
        restTimeLabel.text = "Rest Time: " + String(restTime)
        theGameContext = gameContext.menu.rawValue
    }

    @IBAction func easyButton(sender: AnyObject) {
        coinBoost = 100.0
        cloudBoost = 550.0
        scoreMultiplier = 0.5
        heartRateBoost = 400.0
    }
    @IBAction func mediumButton(sender: AnyObject) {
        coinBoost = 100.0
        cloudBoost = 500.0
        scoreMultiplier = 1.0
        heartRateBoost = 350.0
    }
    @IBAction func hardButton(sender: AnyObject) {
        coinBoost = 100.0
        cloudBoost = 270.0
        scoreMultiplier = 2.5
        heartRateBoost = 225.0
    }
    @IBAction func musicButton(sender: AnyObject) {
        if musicShouldPlay == true {
            musicLabel.text = "Music: Off"
            musicShouldPlay = false
            backgroundMusicPlayer.pause()
            musicButton.setTitle("Off", for: UIControl.State.normal)
        } else {
            musicLabel.text = "Music: On"
            musicShouldPlay = true
            backgroundMusicPlayer.play()
            musicButton.setTitle("On", for: UIControl.State.normal)
        }
    }
    @IBAction func addRestTime(sender: AnyObject) {
        restTime += 1
        restTimeLabel.text = "Rest Time: " + String(restTime)
    }
    @IBAction func decreaseRestTime(sender: AnyObject) {
        restTime -= 1
        restTimeLabel.text = "Rest Time: " + String(restTime)

    }
    @IBAction func connectMonitor(sender: AnyObject) {
        theMonitor.centralManager = nil
        theMonitor.startUpCentralManager()
        theMonitor.discoverDevices()
        print("attempting to connect HRM")
        hrcLabel.text = "Heart Rate Monitor:" + String(theMonitor.currentHeartRate)
        //var cTimer = NSTimer(timeInterval: 1.0, target: self, selector: "updateHR", userInfo: nil, repeats: true)
    }
    
    @IBAction func playButton(sender: AnyObject) {
        //self.view.window!.rootViewController!.performSegueWithIdentifier("gameSegue", sender:self)
        self.performSegue(withIdentifier: "gameSegue", sender: self)
        for view in (self.view?.subviews)! {
            view.removeFromSuperview()
        }
    }
    @IBAction func credits(sender: AnyObject) {
        self.performSegue(withIdentifier: "toCreditsSegue", sender: self)
    }
    func UpdateHR() {
        hrcLabel.text = "Heart Rate Monitor:" + String(theMonitor.currentHeartRate)
    }
    
/*    @IBAction func onePlayer(sender: AnyObject) {
        numberOfPlayers = 1
        playerNumLabel.text = "Number of Players: 1"
    }
    @IBAction func twoPlayer(sender: AnyObject) {
        if numberOfPlayers == 1 {
            playerNumberChanged = true
        }
        numberOfPlayers = 2
        playerNumLabel.text = "Number of Players: 2"
        notification.postNotificationName("device2", object: nil, userInfo: ["theDevices":"checkPeriphs"])
    } */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func menuPressed(notification: NSNotification) {
    }
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            switch press.type {
            case .upArrow:
                print("Up Arrow from menusc")
            case .downArrow:
                print("Down arrow from menusc")
            case .leftArrow:
                print("Left arrow from menusc")
            case .rightArrow:
                print("Right arrow from menusc")
            case .select:
                print("Select from menusc")
            case .menu:
                print("Menu from menusc")
                switch theGameContext {
                case gameContext.load.rawValue:
                    print("loc:menu,but:menu,contxt:load")
                    super.pressesBegan(presses, with: event)
                case gameContext.game.rawValue: break
                    
                    //notification.postNotification(NSNotification(name: "pause", object: nil))
                    //notification.postNotification(NSNotification(name: "loadGame", object: nil))
                case gameContext.menu.rawValue:
                    
                    print("menu button menu scene context menu")
                    break
                    //theMenuViewController.pressesBegan(presses, withEvent: event)
                default: break
                }
                
            case .playPause:
                print("Play/Pause")
                switch theGameContext {
                    
                case gameContext.load.rawValue:
                    if checkPeripherals != nil {
                        checkPeripherals = nil
                    }
                    checkPeripherals = Timer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "periphCheck", userInfo: nil, repeats: true)
                    
                case gameContext.game.rawValue:
                    if checkPeripherals != nil {
                        checkPeripherals = nil
                    }
                    theLoadScene.pressesBegan(presses, with: event)
                    notification.postNotification(NSNotification(name: "pause", object: nil))
                    //notification.postNotification(NSNotification(name: "loadGame", object: nil))
                case gameContext.menu.rawValue:
                    //self.performSegueWithIdentifier("gameSegue", sender: self)
                    notification.postNotification(NSNotification(name: "pause", object: nil))
                    notification.postNotification(NSNotification(name: "loadGame", object: nil))

                    //theMenuViewController.pressesBegan(presses, withEvent: event)
                default: break
                }
            }
        }
    }

    
}
