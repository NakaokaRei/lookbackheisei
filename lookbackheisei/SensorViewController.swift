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
    @IBOutlet weak var acc_x: UILabel!
    @IBOutlet weak var acc_y: UILabel!
    @IBOutlet weak var acc_z: UILabel!
    @IBOutlet weak var gyro_x: UILabel!
    @IBOutlet weak var gyro_y: UILabel!
    @IBOutlet weak var gyro_z: UILabel!
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    
    @IBAction func newsEmit(_ sender: Any) {
        self.socket.emit("my_broadcast_event", ["event": "news"])
    }
    
    @IBAction func twitterEmit(_ sender: Any) {
        self.socket.emit("my_broadcast_event", ["event": "twitter"])
    }
    
    @IBAction func reiwaEmit(_ sender: Any) {
        self.socket.emit("my_broadcast_event", ["event": "reiwa"])
    }
    
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager = SocketManager(socketURL: URL(string: "https://look-back-heisei.herokuapp.com")!, config: [.log(true), .forceWebsockets(true), .forcePolling(true)])
        self.socket = self.manager.socket(forNamespace: "/test")
        
        self.socket.connect()

        // Do any additional setup after loading the view.
        motionManager.deviceMotionUpdateInterval = 0.05
        
        // Start motion data acquisition
        motionManager.startDeviceMotionUpdates( to: OperationQueue.current!, withHandler:{
            deviceManager, error in
            let accel: CMAcceleration = deviceManager!.userAcceleration
            self.acc_x.text = String(format: "%.2f", accel.x)
            self.acc_y.text = String(format: "%.2f", accel.y)
            self.acc_z.text = String(format: "%.2f", accel.z)
            
            let gyro: CMRotationRate = deviceManager!.rotationRate
            self.gyro_x.text = String(format: "%.2f", gyro.x)
            self.gyro_y.text = String(format: "%.2f", gyro.y)
            self.gyro_z.text = String(format: "%.2f", gyro.z)
        })
    }
    
    func outputAccelData(acceleration: CMAcceleration){
        // 加速度センサー [G]
        acc_x.text = String(format: "%06f", acceleration.x)
        acc_y.text = String(format: "%06f", acceleration.y)
        acc_z.text = String(format: "%06f", acceleration.z)
    }
    
    // センサー取得を止める場合
    func stopAccelerometer(){
        if (motionManager.isAccelerometerActive) {
            motionManager.stopAccelerometerUpdates()
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


