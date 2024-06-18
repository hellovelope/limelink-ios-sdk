//
//  RetrofitClient.swift
//  LimelinkIOSSDK_Example
//
//  Created by artue on 6/18/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation

public class RetrofitClient {
    static let shared = RetrofitClient()
    
    private init() {}
    
    lazy var apiService: ApiSerivce = {
        return ApiServiceImpl()
    }()
}
