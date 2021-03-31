//
//  ViewController.swift
//  SigmaITTest
//
//  Created by Ngavt on 3/30/21.
//

import UIKit
import CoreLocation
import Foundation
import Moya

class ViewController: UIViewController {
    
    @IBOutlet weak var countDataLb: UILabel!

    let locationManager = CLLocationManager()
    let semaphore = DispatchSemaphore(value: 1)
    
    let limitNumber = 5
    let locationTaskRepeatTime = 6.0 * 60
    let batteryTaskRepeatTime = 9.0 * 60
    var timer1: Timer?
    var timer2: Timer?
    
    var sharedResources = [String]() {
        didSet {
            if self.sharedResources.count >= limitNumber {
                self.getDataFromApi()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UIDevice.current.isBatteryMonitoringEnabled = true
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    
    func queue() {
        timer1 = Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(self.getLocation), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 9.0, target: self, selector: #selector(self.getBattery), userInfo: nil, repeats: true)
    }
    
    @objc func getLocation(){
        DispatchQueue.global().async {
            self.semaphore.wait()
            defer {
                self.semaphore.signal()
            }
            self.getDeviceLocation()
        }
        
    }
    
    @objc func getBattery(){
        DispatchQueue.global().async {
            self.semaphore.wait()
            defer {
                self.semaphore.signal()
            }
            self.getDeviceBattery()
        }
        
    }
    
    func getDeviceLocation(){
        var currentLoc: CLLocation?
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLoc = locationManager.location
            print("sharedResources Count", self.sharedResources.count + 1)
            self.sharedResources.append("Lat: \(currentLoc?.coordinate.latitude ?? 0) - Long: \(currentLoc?.coordinate.longitude ?? 0)")
        }
    }
    
    func getDeviceBattery(){
        let level = UIDevice.current.batteryLevel
        print("sharedResources Count", self.sharedResources.count + 1)
        self.sharedResources.append("Current battery: \(level)")
    }

    func getDataFromApi(){
        var input: [String:Any] = [:]
        input["codes"] = sharedResources
        self.getDatas(input: input)
    }
    
    @IBAction func startAct(_ sender: Any) {
        queue()
    }
    
    @IBAction func stopAct(_ sender: Any) {
        timer1?.invalidate()
        timer1 = nil
        timer2?.invalidate()
        timer2 = nil
        var requests = Operator.shared.requests
        requests.forEach { cancellable in cancellable.cancel() }
            requests.removeAll()
    }
    
    
    func getDatas(input: [String: Any], success: (([TestBO])->())? = nil, failure: (()->())? = nil){
        
        let target = MultiTarget(TestService.test(params: input))
        NetworkManager.request(class: TestBO.self, target: target, isCancel: true, success: { obj in
            if let success = success {
                success(obj)
            }
        }, failure: { _ in
            if let failure = failure {
                failure()
            }
        })
    }
    
}

