//
//  ViewController.swift
//  LimelinkIOSSDK
//
//  Created by hellovelope@gmail.com on 05/10/2024.
//  Copyright (c) 2024 hellovelope@gmail.com. All rights reserved.
//

import UIKit


public class ViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.example.com/test/product/value")
        saveLimeLinkStatus(url: url, privateKey: "VB7b9tjk8G5FV04CNmY9j7OdKSLbnKoK")
        print("Hello")
        // UILabel 생성
        let label = UILabel()
        label.text = "Hello, World!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false

        // UILabel을 View에 추가
        view.addSubview(label)

        // 제약 조건 설정
        NSLayoutConstraint.activate([
         label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        // Do any additional setup after loading the view.

        // Do any additional setup after loading the view, typically from a nib.
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

