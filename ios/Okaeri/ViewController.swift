//
//  ViewController.swift
//  Okaeri
//
//  Created by PeroPeroMan on 2015/12/18.
//  Copyright © 2015年 prpr_man. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!;
    private var peripheral:CBPeripheral?;
    
    private var threshold:Float = -60.0;
    private var configuring:Bool = false;
    
    
    private var count:Int = 0;
    private var rssiSum:Int = 0;
    private var enter:Bool = false;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: nil);
        if let data:Float = NSUserDefaults.standardUserDefaults().objectForKey("threshold") as? Float {
            threshold = data;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch (central.state) {
        case .PoweredOn:
            central.scanForPeripheralsWithServices([CBUUID(string: "00002800-0000-1000-8000-00805F9B34FB")], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true]);
        default: break;
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        if(RSSI.integerValue > 0){
            return;
        }
        
        if(configuring){
            let finish:Bool = configureThreshold(RSSI.integerValue);
            if(finish){
                NSUserDefaults.standardUserDefaults().setObject(threshold, forKey: "threshold");
                NSUserDefaults.standardUserDefaults().synchronize();
                configuring = false;
            }
            return;
        }
        
        if(!enter && RSSI.floatValue > threshold){
            enter = true;
            self.peripheral = peripheral;
            self.centralManager.connectPeripheral(peripheral, options: nil);
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral)
    {
        //centralManager.cancelPeripheralConnection(peripheral);
    }
    
    func configureThreshold(RSSI : Int) -> Bool {
        count++;
        rssiSum += RSSI;
        if(count >= 10){
            threshold = Float(rssiSum)/10.0;
            count = 0;
            rssiSum = 0;
            return true;
        }
        return false;
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        enter = false;
        print("disconnect");
    }
    
    @IBAction func setThreshold(sender: AnyObject) {
        configuring = true
        if(enter){
            self.centralManager.cancelPeripheralConnection(self.peripheral!);
        }
    }
}