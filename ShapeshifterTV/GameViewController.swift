//
//  GameViewController.swift
//  ShapeshifterTV
//
//  Created by David Lang on 9/13/15.
//  Copyright (c) 2015 David Lang. All rights reserved.
//

import UIKit
import SpriteKit
import CoreBluetooth
import AVKit
import AVFoundation
import MediaPlayer

var theMonitor = HeartRateLEMonitor()
var theSecondMonitor:HeartRateLEMonitor!
var alreadyConnected = [CBPeripheral]()
var thePlayer = ""
var notification:NSNotificationCenter = NSNotificationCenter.defaultCenter()
var currentLevel = 1
var restTime = 10

var conqueredLevel = false
var coinBoost:CGFloat = 30.0
var cloudBoost:CGFloat = 350.0
var heartRateBoost:CGFloat = 300.0
var modCoinBoost:CGFloat!
var modHeartRateBoost:CGFloat!
var modCloudBoost:CGFloat!
var scoreMultiplier:CGFloat = 0.5
var difficultyLevel = "Easy"

var allTimeScore = 0.0

var musicShouldPlay = true
let defaults = NSUserDefaults.standardUserDefaults()
var showExplainScene = true

var levelScore = 0.0
var sessionScore = 0.0
var score = 0.0
var currentScore = 1.0
var levelScoreP2 = 0.0
var sessionScoreP2 = 0.0
var scoreP2 = 0.0
var currentScoreP2 = 1.0
var levelsConquered = 0
var player1Won = true


var numberOfPlayers = 1
var playerNumberChanged = false

//music variables
var musicItemList = [AVPlayerItem]()
var songItem:AVPlayerItem!
var backgroundMusicPlayer:AVQueuePlayer!
//var mediaQuery = MPMediaQuery.
var playlists:[AnyObject]!
//var musicPlayer:AVQueuePlayer!
//var myPlayer:MPMusicPlayerController = MPMusicPlayerController.applicationMusicPlayer()
var playlistPath:NSIndexPath?
var songLength:Float!
var musicTimer:NSTimer!
var playlistHasBeenOpened = true
var musicDefaults = NSUserDefaults.standardUserDefaults()

var playpauseRecognizer:UIGestureRecognizer!
var menuRecognizer:UIGestureRecognizer!
var playing = false
var theMenuViewController: UIViewController!
var skView:SKView!
var connectedDevices = []
var checkPeripherals:NSTimer!
var checkCounter = 0
var theGameContext = 0
var theLoadScene:LoadScene!
var theGameScene:GameScene!

var gameInitialized = false


enum gameContext:Int {
    case load = 0
    case menu = 1
    case game = 2
    case win = 3
    case lose = 4
}

class heartRateMessage: NSObject {
    var monitorName = ""
    var serialNumber = ""
    var theHeartRate = 0
    
    init(name: String, number: String, rate: Int) {
        monitorName = name
        serialNumber = number
        theHeartRate = rate
    }
}


class GameViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        print("GVC VDL")
        
        if gameInitialized == false {
            theMonitor.startUpCentralManager()
            theSecondMonitor = HeartRateLEMonitor()

                theSecondMonitor.startUpCentralManager()
            notification.addObserver(self, selector: "findMonitors:", name: "findMonitors", object: nil)
            //notification.addObserver(self, selector: "findMonitors:", name: "findMonitors", object: nil)
            theGameContext = gameContext.load.rawValue
            UIApplication.sharedApplication().idleTimerDisabled = true

        }
        
        if skView == nil {
            skView = self.view as! SKView
            let size = CGSize(width: 1920.0, height: 1080.0)
    
            theLoadScene = LoadScene(size: size)
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            //skView.ignoresSiblingOrder = true
            skView.presentScene(theLoadScene)
        }
        gameInitialized = true
    }
    
    func menuTapped(sender: UITapGestureRecognizer) {
        self.performSegueWithIdentifier("menuSegue", sender: self)
    }
/*    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for item in presses {
            if item.type == .Select {
                self.view!.backgroundColor = UIColor.greenColor()
                print("select pressed")
            }
            if item.type == .Menu {
               
                if checkPeripherals != nil {
                    checkPeripherals = nil
                }
                if playing == true {
                    notification.postNotification(NSNotification(name: "pause", object: nil))
                }
                notification.postNotification(NSNotification(name: "menu", object: nil))
                self.performSegueWithIdentifier("menuSegue", sender: nil)
                //self.view!.window!.rootViewController?.performSegueWithIdentifier("menuSegue", sender: self) //.performSegueWithIdentifier("PurchasedViewController" sender:self
                print("menu pressed from gameview controller")
                
            }
            if item.type == .PlayPause {
                if gameContext == "load" {
                    if checkPeripherals != nil {
                        checkPeripherals = nil
                    }
                    checkPeripherals = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "periphCheck", userInfo: nil, repeats: true)
                } else {
                    if checkPeripherals != nil {
                        checkPeripherals = nil
                    }
                    notification.postNotification(NSNotification(name: "pause", object: nil))
                    notification.postNotification(NSNotification(name: "loadGame", object: nil))
                }
                print("pp pressed from gameview controller")

            }
        }
    } */
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            switch press.type {
            case .UpArrow:
                print("Up Arrow")
            case .DownArrow:
                print("Down arrow")
            case .LeftArrow:
                print("Left arrow")
            case .RightArrow:
                print("Right arrow")
            case .Select:
                print("Select")
            case .Menu:
                print("Menu")
                switch theGameContext {
                case gameContext.load.rawValue:
                    print("CONTEXT LOAD & MENU WAS PRESSED")
                    super.pressesBegan(presses, withEvent: event)
                case gameContext.game.rawValue:
                    print("CONTEXT GAME & MENU WAS PRESSED")
                    print("Playing var status: \(playing)")
                    if checkPeripherals != nil {
                        checkPeripherals = nil
                    }
                    
                    if playing == true {
                        notification.postNotification(NSNotification(name: "pause", object: nil))
                        theGameContext = gameContext.menu.rawValue
                        skView.presentScene(theLoadScene)
                    }
                    if theGameScene != nil {
                        theGameScene.pressesBegan(presses, withEvent: event)
                    }
                case gameContext.menu.rawValue:
                    print("CONTEXT MENU & MENU WAS PRESSED")

                    //performSegueWithIdentifier("menuSegue", sender: self)
                    //theMenuViewController.pressesBegan(presses, withEvent: event)
                    super.pressesBegan(presses, withEvent: event)
                    
                default: break
                }
                
            case .PlayPause:
                print("Play/Pause")
                switch theGameContext {
                
                case gameContext.load.rawValue:
                    if checkPeripherals != nil {
                        checkPeripherals = nil
                    }
                    if playing == false {
                        checkPeripherals = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "periphCheck", userInfo: nil, repeats: true)
                    }
                case gameContext.game.rawValue:
                    if checkPeripherals != nil {
                        checkPeripherals = nil
                    }
                    //if playing == false {
                    //    theLoadScene.pressesBegan(presses, withEvent: event)
                    //}
                    print("game context:  \(theGameContext)")
                    print("PLAY/PAUSE PRESSED|MSG FROM GVC")
                    notification.postNotification(NSNotification(name: "pause", object: nil))
                    notification.postNotification(NSNotification(name: "loadGame", object: nil))
                case gameContext.menu.rawValue:
                    break
                    //theMenuViewController.pressesBegan(presses, withEvent: event)
                default: break
                }
            }
        }
    }
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for item in presses {
            if item.type == .Menu {
                if playing == false && theGameContext == gameContext.menu.rawValue {
                    super.pressesEnded(presses, withEvent: event)
                    print("PressesEnded .Menu going up the chain")
                    print(superclass)
                    return
                } else if playing == false && theGameContext == gameContext.load.rawValue {
                    super.pressesEnded(presses, withEvent: event)
                    return
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func findMonitors(notification: NSNotification) {
        checkPeripherals = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "periphCheck", userInfo: nil, repeats: true)
    }
    func periphCheck() {
        print("checking periph count")
        connectedDevices = theMonitor.centralManager.retrieveConnectedPeripheralsWithServices([theMonitor.HeartRateService])
        
        if connectedDevices.count == 0 && numberOfPlayers == 1 {
            //theMonitor.startUpCentralManager()
            theMonitor.discoverDevices()
        } else if connectedDevices.count < 2 && numberOfPlayers == 2 {
            //theMonitor.startUpCentralManager()
            theMonitor.discoverDevices()
            //theSecondMonitor = HeartRateLEMonitor()
            //theSecondMonitor.startUpCentralManager()
            theSecondMonitor.discoverDevices()
        } else if connectedDevices.count == 1 && numberOfPlayers == 1 {
            
        } else if connectedDevices.count == 2 && numberOfPlayers == 2 {
            
        }
        
        //connectedDevices = theMonitor.centralManager.retrieveConnectedPeripheralsWithServices([theMonitor.HeartRateService])
        print(connectedDevices)
        print(connectedDevices.count)
        checkCounter += 1
        
        if checkCounter > 10 {
            checkCounter = 0
            checkPeripherals.invalidate()
        }
        
        if numberOfPlayers == 1 {
            switch checkCounter {
            case 1: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning for Heart Rate Monitor"]))
            case 2: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning for Heart Rate Monitor ."]))
            case 3: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning for Heart Rate Monitor . ."]))
            case 4: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning for Heart Rate Monitor . . ."]))
            case 5: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning for Heart Rate Monitor ."]))
            case 6: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning for Heart Rate Monitor . ."]))
            case 7: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning for Heart Rate Monitor . . ."]))
            case 8: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning for Heart Rate Monitor ."]))
            case 9: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning for Heart Rate Monitor . ."]))
            case 10: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning for Heart Rate Monitor . . ."]))
            default: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning for Heart Rate Monitor"]))
            }
            if connectedDevices.count > 0 {
                if checkPeripherals != nil {
                    checkPeripherals.invalidate()
                }
                let alertController = UIAlertController(title: "Available Connected Devices", message: "Select Monitor", preferredStyle: .ActionSheet)
                for i in 0...connectedDevices.count - 1 {
                    let deviceOne = UIAlertAction(title: connectedDevices[i].name, style: .Default) { (action) in
                        theMonitor.centralManager.connectPeripheral(connectedDevices[i] as! CBPeripheral, options: nil)
                        notification.postNotification(NSNotification(name: "updateScreen", object: self, userInfo: ["theStatus":"Press Play to Start"]))
                        if checkPeripherals != nil {
                            checkPeripherals.invalidate()
                        }
                        theGameContext = gameContext.game.rawValue
                    }
                    alertController.addAction(deviceOne)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                    // ...
                }
                alertController.addAction(cancelAction)
                
                self.presentViewController(alertController, animated: false) {
                    print("presenting alert view")
                }

            } else {
                if checkCounter == 10 {
                    theMonitor.centralManager = nil
                    theMonitor.startUpCentralManager()
                    theMonitor.discoverDevices()
                }
            }
        } 

        if numberOfPlayers == 2 {
            switch checkCounter {
            case 1: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning"]))
            case 2: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning ."]))
            case 3: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning . ."]))
            case 4: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning . . ."]))
            case 5: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning ."]))
            case 6: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning . ."]))
            case 7: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning . . ."]))
            case 8: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning ."]))
            case 9: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning . ."]))
            case 10: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning . . ."]))
            default: notification.postNotification(NSNotification(name: "updateScreen", object: nil, userInfo: ["theStatus":"Scanning"]))
            }

            if connectedDevices.count > 1 {
                checkPeripherals.invalidate()
                let alertController = UIAlertController(title: "Detected Heart Rate Monitors", message: "Select Player 1's Monitor", preferredStyle: .ActionSheet)
                    for i in 0...connectedDevices.count - 1 {
                        var idNum = String(connectedDevices[i].identifier)
                        let range = idNum.startIndex...idNum.endIndex.advancedBy(-5)
                        idNum.removeRange(range)
                        print(idNum)
                        print(range)
                        let deviceOne = UIAlertAction(title: connectedDevices[i].name + " " + idNum, style: .Default) { (action) in
                            //theMonitor.centralManager.connectPeripheral(connectedDevices[i] as! CBPeripheral, options: nil)
                                let connDevices = connectedDevices
                                theSecondMonitor.centralManager.connectPeripheral(connDevices[i] as! CBPeripheral, options: nil)
                                let reversedDevices = connDevices.reverse()
                                theSecondMonitor.centralManager.cancelPeripheralConnection(reversedDevices[i] as! CBPeripheral)
                           
                                theMonitor.centralManager.connectPeripheral(reversedDevices[i] as! CBPeripheral, options: nil)
                                theMonitor.centralManager.cancelPeripheralConnection(connDevices[i] as! CBPeripheral)
                            
                                print("the first player has monitor " + connDevices[i].name + String(connDevices[i].identifier))
                                print("the second player has monitor " + reversedDevices[i].name + String(reversedDevices[i].identifier))
                                    
                                if theMonitor.serialNumber == theSecondMonitor.serialNumber {
                                    print("####################################################################")
                                    
                                }
                            
                                print(connectedDevices)
                                print(reversedDevices)
                            
                            
                            checkPeripherals.invalidate()
                            theGameContext = gameContext.game.rawValue
                            notification.postNotification(NSNotification(name: "updateScreen", object: self, userInfo: ["theStatus":"Press Play to Start"]))
                        }
                alertController.addAction(deviceOne)
                }
    
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                    // ...
                }
                alertController.addAction(cancelAction)
            
                self.presentViewController(alertController, animated: false) {
                    print("presenting alert view")
                }

            } else {
                if checkCounter == 10 {
                    theMonitor.centralManager = nil
                    theMonitor.startUpCentralManager()
                    theMonitor.discoverDevices()
                    theSecondMonitor.centralManager = nil
                    theSecondMonitor.startUpCentralManager()
                    theSecondMonitor.discoverDevices()
                }
            }
        }
    }

    

}
