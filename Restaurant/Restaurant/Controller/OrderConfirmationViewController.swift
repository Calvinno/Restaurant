//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  Created by Calvin Cantin on 2019-02-17.
//  Copyright © 2019 Calvin Cantin. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    @IBOutlet weak var timeRemainigLabel: UILabel!
    var minutes: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeRemainigLabel.text = "Thank you for your order! Your wait time is appromately \(minutes ?? 0) minutes."

        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
