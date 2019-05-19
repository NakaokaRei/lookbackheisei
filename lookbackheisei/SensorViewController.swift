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
    @IBOutlet weak var gyro_x: UILabel!
    @IBOutlet weak var gyro_y: UILabel!
    @IBOutlet weak var gyro_z: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var imageGame: UIImageView!
    var degree:Double! = 0
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    let motionManager = CMMotionManager()
    
    @IBAction func newsEmit(_ sender: Any) {
        self.socket.emit("my_broadcast_event", ["event": "news"])
    }
    
    @IBAction func twitterEmit(_ sender: Any) {
        self.socket.emit("my_broadcast_event", ["event": "twitter"])
    }
    
    @IBAction func reiwaEmit(_ sender: Any) {
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
            self.gyro_x.text = String(format: "%.2f", gyro.x)
            self.gyro_y.text = String(format: "%.2f", gyro.y)
            self.gyro_z.text = String(format: "%.2f", gyro.z)
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
        self.degreeLabel.text = String(self.degree)
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


