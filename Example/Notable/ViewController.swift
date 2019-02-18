//
//  ViewController.swift
//  Notable
//
//  Created by erusso1 on 02/17/2019.
//  Copyright (c) 2019 erusso1. All rights reserved.
//

import UIKit
import Notable

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Notable.shared.getNotificationAuthorizationStatus { status in
            
            DispatchQueue.main.async {
                
                if status == .authorized {
                    
                    Notable.shared.registerForRemoteNotifications()
                    
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        Notable.shared.requestAuthorization { granted, _ in
            
            DispatchQueue.main.async {
                
                guard granted else { return }
                
                Notable.shared.registerForRemoteNotifications()
            }
        }
    }
    
    @IBAction func simulateSocketEventPressed(_ sender: UIButton) {
        
        let payload = BaseNotificationPayload(action: .newRestaurantNearby, reference: UUID().uuidString)
        
        Notable.shared.displayBannerUINotificationWith(payload: payload, afterDelay: 1)
    }
}

