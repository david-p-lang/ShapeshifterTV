import Foundation
import CoreBluetooth


class HeartRateLEMonitor:NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    var centralManager:CBCentralManager!
    var thePeripheral: CBPeripheral!
    var heartRateCharacteristic: CBCharacteristic!
    var currentHeartRate = 0
    var blueToothReady = false
    var bluetoothConnected = false
    
    var InfoService:CBUUID = CBUUID(string: "180A")
    var HeartRateService:CBUUID = CBUUID(string: "180D")
    var HeartRateCharUUID:CBUUID = CBUUID(string: "2A37")
    var HeartRateLocation:CBUUID = CBUUID(string: "2A38")
    var HRManu:CBUUID = CBUUID(string: "2A29")
    var batteryLevelCharUUID:CBUUID = CBUUID(string: "2A19")
    var serialNumberUUID:CBUUID = CBUUID(string: "2A25")
    var serialNumberChar:CBCharacteristic?
    
    var heartRateCBServiceCollection:[AnyObject] = [CBUUID(string: "180D")]
    var heartRateCBService:CBService!
    var periphs:[AnyObject]!
    var knownMonitors = ""
    
    var heartRateCheckerCount = 0
    var heartRateCheckerNew = ""
    var heartRateCheckerOld = ""
    
    var monitorName = ""
    var serialNumber = ""
    
  /*  class heartRateMessage: NSObject {
        var monitorName = ""
        var serialNumber = ""
        var theHeartRate = 0
        
        init(name: String, number: String, rate: Int) {
            monitorName = name
            serialNumber = number
            theHeartRate = rate
        }
    } */
    
    var notification = NotificationCenter.default
    
    //===============================CUSTOM FUNCTIONS==============================
    func startUpCentralManager() {
        NSLog("Initializing central manager")
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    //===============================DISCOVER DEVICES==============================
    func discoverDevices() {
        NSLog("discovering devices")
        /*var theMonitorManager = MonitorsManager()
        knownMonitors = theMonitorManager.getMonitorName()
        if theMonitorManager.identifier != nil {
        theMonitorManager.getMonitorIdentifier()
        println("the monitor manager identifier--\(theMonitorManager.identifier)") */
        let perId = centralManager.retrieveConnectedPeripherals(withServices: [HeartRateService])
        alreadyConnected = perId
        /*if perId.count > 0 {
        for i in 0...perId.count - 1 {
        var v: AnyObject  = perId[i]
        println("\(v.description)")
        centralManager.connectPeripheral(v as! CBPeripheral, options: nil)
        }
        }
        }
        if bluetoothConnected == false {
            self.periphs = centralManager.retrieveConnectedPeripheralsWithServices([self.HeartRateService])
            print("system connected peripherals: \(periphs.count)")
            if periphs.count > 0 {
                for i in 0...periphs.count - 1 {
                    notification.postNotificationName("devices", object: self, userInfo: ["theDevices":"checkPeriphs"])
                    let v: AnyObject = periphs[i]
                    print("\(periphs.count) Peripheral count" + "\(periphs)")
                    var idChecker:NSUUID!
                    idChecker = v.identifier as NSUUID
                    if idChecker != nil {
                        //println("* ID: \(idChecker)")
                        //println("* ID: \(v.identifier as NSUUID)")
                        //theMonitorManager.saveMonitor(v.name, andIdentifier: idChecker)
                    }
                }
            }
        } */
        //if self.periphs.count == 0 {
           // print("Still scanning for a device")
        centralManager.scanForPeripherals(withServices: [HeartRateService], options: nil)
       // }
    }
    //==============================STOP SCANNING============================
    func stopScanning() {
        centralManager.stopScan()
    }
    //=============================USER SCAN FOR PERIPHERAL========================
    func scanForMonitor() {
        centralManager.scanForPeripherals(withServices: [HeartRateService], options: nil)
    }
    //=============================CHECK HEART RATE CONNECTION=====================
    func checkHeartRateConnection() {
        switch self.thePeripheral.state {
        case .disconnected:
            bluetoothConnected = false
        default:
            bluetoothConnected = false
        }
    }
    
    //===========================CENTRAL MANAGER FUNCTIONS=========================
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        NSLog("checking state")
        var theLEState = ""
        switch (central.state) {
        case .poweredOff:
            theLEState = "Bluetooth is powered off"
        case .poweredOn:
            theLEState = "Bluetooth is ready"
            blueToothReady = true;
        case .resetting:
            theLEState = "Bluetooth on your device is resetting"
        case .unauthorized:
            theLEState = "Bluetooth on your device is unauthorized"
        case .unknown:
            theLEState = "Bluetooth on your device is unknown"
        case .unsupported:
            theLEState = "Bluetooth type needed is unsupported on this platform"

        }
        NSLog(theLEState)
        notification.post(name: NSNotification.Name(rawValue: "bluetoothStatus"), object: nil)
        if blueToothReady {
            discoverDevices()
        }
    }
    
    func centralManager(central: CBCentralManager!, didRetrievePeripherals peripherals: [AnyObject]!) {
        print("--didretrieveIdentifiedPeripheral")
    }
    func centralManager(central: CBCentralManager!, didRetrieveConnectedPeripherals peripherals: [AnyObject]!) {
        print("--didretrieveConnectedPeripheral")
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        NSLog("--didconnectperipheral")
        peripheral.delegate = self
        switch (peripheral.state) {
        case .connected:
            NSLog("the central manager reports the peripheral state is connected")
            notification.post(name: NSNotification.Name(rawValue: "peripheralStatus"), object: nil)

            self.thePeripheral = peripheral
            self.thePeripheral.discoverServices(nil)
            //centralManager.stopScan()
            bluetoothConnected = true
        case .disconnected:
            bluetoothConnected = false
            NSLog("peripheral state is disconnected")
        case .connecting:
            NSLog("peripheral state is connecting")
        default:
            NSLog("peripheral state is connecting")
        }
        
    }
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        NSLog("did fail connect")
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        NSLog("Discovered \(peripheral.name)")
        self.thePeripheral = peripheral
        notification.post(name: NSNotification.Name(rawValue: "peripheralStatus"), object: nil)
        centralManager.connect(peripheral, options: nil)
        var peripheralConnectionStatus = "Disconnected"
        switch (peripheral.state) {
        case .connected:
            NSLog("peripheral state is connected")
            notification.post(name: NSNotification.Name(rawValue: "peripheralStatus"), object: nil)
            bluetoothConnected = true
            centralManager.stopScan()
            return
        case .disconnected:
            NSLog("peripheral state is disconnected")
            bluetoothConnected = false
        case .connecting:
            NSLog("peripheral state is connecting")
        default:
            print(peripheral.state)
            
        }
        
    }
    //==============================PERIPHERAL FUNCTIONS==================================
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        NSLog("did discover services")
        if peripheral.services != nil {
            heartRateCBServiceCollection = peripheral.services!
            for heartRateCBService in heartRateCBServiceCollection {
                NSLog("Discovered service: \(heartRateCBService.uuid)")
                if (heartRateCBService.UUID == "Heart Rate") {
                    
                }
                self.thePeripheral.discoverCharacteristics(nil, for: heartRateCBService as! CBService)
            }
        }
        
    }
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        NSLog("did discover characteristics")
        if service.characteristics != nil {
            for chars in service.characteristics! {
                thePeripheral.setNotifyValue(true, for: chars )
                heartRateCharacteristic = chars
                thePeripheral.readValue(for: heartRateCharacteristic)
                self.thePeripheral.setNotifyValue(true, for: heartRateCharacteristic)
            }
        }
        
    }
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic,
        error: NSError?)
    {
        if characteristic.uuid == HeartRateCharUUID {
            let data = characteristic.value
            if data == nil {
                //print("data variable was nil")
                return
            }
            let reportData = UnsafePointer<UInt8>(data!.bytes)
            var bpm : UInt16
            if (reportData[0] & 0x01) == 0 {
                bpm = UInt16(reportData[1])
            } else {
                bpm = UnsafePointer<UInt16>(reportData + 1)[0]
                bpm = CFSwapInt16LittleToHost(bpm)
            }
            
            let outputBPM = String(bpm)
            //print("-->"+outputBPM)
            currentHeartRate = Int(outputBPM)!
            
            //println("report \(reportData[0])")
            if (reportData[0] & 0x0011) == 0 {
                //println("sensor contact status not supplied")
            } else if (reportData[0] & 0x0011) == 1 {
                //println("Sensor Contact feature is not supported in the current connection")
            } else if (reportData[0] & 0x0011) == 2 {
                print("Sensor Contact feature is supported, but contact is not detected")
            } else if (reportData[0] & 0x0011) == 3 {
                print("Sensor Contact feature is supported and contact is detected")
            }
            
            /*switch (reportData[0] & 0x00001) {
            case 0:
            println("Energy Expended field is not present")
            case 1:
            println("Energy Expended field is present. Units: kilo Joules")
            default:
            println("ERROR")
            }
            switch (reportData[0] & 0x000001) {
            case 0:
            println("RR-Interval values are not present")
            case 1:
            println("One or more RR-Interval values are present. Units: 1/1024 seconds")
            default:
            println("ERROR")
            }*/
            
            let heartRateCom = heartRateMessage(name: monitorName, number: serialNumber, rate: currentHeartRate)
            notification.postNotificationName("heartRateBroadcast", object: nil, userInfo: ["message":heartRateCom])
            
            //=====
            let heartRateHex:String = data!.description
            //println("hrh: " + heartRateHex)
            var charcount = 0
            var subHRHex:String = "0x"
            for character in heartRateHex.characters {
                if charcount == 3 {
                    subHRHex.append(character)
                    
                } else if charcount == 4 {
                    subHRHex.append(character)
                }
                charcount += 1
            }
            let scanner = Scanner(string: subHRHex)
            var conversionNum:UInt32 = 0
            if scanner.scanHexInt32(&conversionNum) == true {
                //println("HM-->\(conversionNum)")
            }
            
        }
        if characteristic.uuid == batteryLevelCharUUID {
            let data = characteristic.value
            let reportData = UnsafePointer<UInt8>(data!.bytes)
            let batteryLevel = reportData[0]
            print("Battery charged: \(batteryLevel)%")
            notification.postNotificationName("bluetoothStatus", object: nil, userInfo: ["theBTState":characteristic.service.peripheral.name! + " Battery:" + String(batteryLevel) + "%"])
            
        }
        if characteristic.uuid == HRManu {
            
            //if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]])
            //peripheral.readValueForCharacteristic(characteristic)
            let data = characteristic.value
            print(data)
            monitorName = String(data)
            print("Monitor name: \(monitorName)")
        }
        
        if characteristic.uuid == serialNumberUUID {
            serialNumberChar = characteristic
            let data = characteristic.value
            print(data)
            let reportData = UnsafePointer<UTF8>(data!.bytes)
            let serialNum = reportData[0]
            print("serial number: \(serialNum)")
            serialNumber = String(data)
            print("Serial Number: \(serialNumber)")
        }
        
        /*if characteristic.UUID == serialNumberUUID {
        let data = characteristic.value
        println(data.description)
        }
        if characteristic.UUID == CBUUID(string: "2A29") {
        let data = characteristic.value
        println(characteristic.service.peripheral.identifier.UUIDString)
        println(data.description)
        }*/
    }
}
