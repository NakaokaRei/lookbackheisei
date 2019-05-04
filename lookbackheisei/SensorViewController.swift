//
//  SensorViewController.swift
//  lookbackheisei
//
//  Created by 中岡黎 on 2019/05/05.
//  Copyright © 2019 NakaokaRei. All rights reserved.
//

import UIKit
import CoreMotion

class SensorViewController: UIViewController {
    @IBOutlet weak var acc_x: UILabel!
    @IBOutlet weak var acc_y: UILabel!
    @IBOutlet weak var acc_z: UILabel!
    
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if motionManager.isAccelerometerAvailable {
            // intervalの設定 [sec]
            motionManager.accelerometerUpdateInterval = 0.2
            
            // センサー値の取得開始
            motionManager.startAccelerometerUpdates(
                to: OperationQueue.current!,
                withHandler: {(accelData: CMAccelerometerData?, errorOC: Error?) in
                    self.outputAccelData(acceleration: accelData!.acceleration)
            })
            
        }
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


