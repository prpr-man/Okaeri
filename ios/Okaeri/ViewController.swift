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
    private var rssiArray:[Int] = [];
    private var rssiSum:Int = 0;
    private var rssiAve:Float = 0;
    private var enter = false;
    
    
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
        
        calcRssiAverage(RSSI.integerValue);
        
        if(!enter && RSSI.floatValue > threshold){
            enter = true;
            self.peripheral = peripheral;
            self.centralManager.connectPeripheral(peripheral, options: nil);
        }else if(enter && RSSI.floatValue < threshold*1.5){
            enter = false;
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral)
    {
        centralManager.cancelPeripheralConnection(peripheral);
    }
    
    func calcRssiAverage(RSSI : Int) {
        rssiArray.append(RSSI);
        rssiSum += RSSI;
        if(rssiArray.count > 10){
            rssiSum -= rssiArray.removeFirst();
            rssiAve = Float(rssiSum)/10.0;
        }else{
            rssiAve = Float(rssiSum)/Float(rssiArray.count);
        }
    }
    
    @IBAction func setThreshold(sender: AnyObject) {
        if(rssiArray.count == 0){
            return
        }
        
        threshold = rssiAve;
        NSUserDefaults.standardUserDefaults().setObject(threshold, forKey: "threshold");
        NSUserDefaults.standardUserDefaults().synchronize();
    }
}