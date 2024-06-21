//
//  RetrofitClient.swift
//  LimelinkIOSSDK
//
//  Created by artue on 6/21/24.
//

import Foundation

public class RetrofitClient {
    static let shared = RetrofitClient()
    
    private init() {}
    
    lazy var apiService: ApiSerivce = {
        return ApiServiceImpl()
    }()
}
