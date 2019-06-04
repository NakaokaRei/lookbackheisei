//
//  SensorViewController.swift
//  lookbackheisei
//
//  Created by 中岡黎 on 2019/05/05.
//  Copyright © 2019 NakaokaRei. All rights reserved.
//

import UIKit
import CoreMotion
import SocketIO

class SensorViewController: UIViewController {
    var gyro_x: Double!
    var gyro_y: Double!
    var gyro_z: Double!
    @IBOutlet weak var imageGame: UIImageView!
    var degree:Double! = 0
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    let motionManager = CMMotionManager()
    
    func newsEmit(_ sender: Any) {
        self.socket.emit("my_broadcast_event", ["event": "news"])
    }
    
    func twitterEmit(_ sender: Any) {
        self.socket.emit("my_broadcast_event", ["event": "twitter"])
    }
    
    func reiwaEmit(_ sender: Any) {
        self.socket.emit("my_broadcast_event", ["event": "reiwa"])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager = SocketManager(socketURL: URL(string: "https://look-back-heisei.herokuapp.com")!, config: [.log(true), .forceWebsockets(true), .forcePolling(true)])
        self.socket = self.manager.socket(forNamespace: "/test")
        self.socket.connect()

        // Do any additional setup after loading the view.
        motionManager.deviceMotionUpdateInterval = 0.1
        
        // Start motion data acquisition
        motionManager.startDeviceMotionUpdates( to: OperationQueue.current!, withHandler:{
            deviceManager, error in            
            let gyro: CMRotationRate = deviceManager!.rotationRate
            self.gyro_x = gyro.x
            self.gyro_y = gyro.y
            self.gyro_z = gyro.z
            self.loop(angular: gyro.y)
        })
    }
    
    // センサー取得を止める場合
    func stopAccelerometer(){
        if (motionManager.isAccelerometerActive) {
            motionManager.stopAccelerometerUpdates()
        }
        
    }
    
    func loop(angular: Double){
        self.degree += angular * 0.1 * 57.2
        if self.degree >= 90{
            self.socket.emit("my_broadcast_event", ["event": "news"])
            self.imageGame.image = UIImage(named: "left")
            self.degree = 0
        } else if -self.degree >= 90{
            self.socket.emit("my_broadcast_event", ["event": "twitter"])
            self.imageGame.image = UIImage(named: "right")
            self.degree = 0
        }
    }
    
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


