//
//  ViewController.swift
//  LimelinkIOSSDK
//
//  Created by hellovelope@gmail.com on 05/10/2024.
//  Copyright (c) 2024 hellovelope@gmail.com. All rights reserved.
//

import UIKit
import LimelinkIOSSDK

public class ViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        Test.sayBye(with: "희엽")
        LimelinkIOSSDK.test(with: "희엽")
        // Do any additional setup after loading the view, typically from a nib.
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

